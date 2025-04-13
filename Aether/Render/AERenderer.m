//
//  AERenderSystem.m
//  Aether
//
//  Created by Allen on 2025/1/1.
//

#import "AERenderer.h"
#import "AEPipelineStateManager.h"
#import "AEWorldContext.h"
#import "AEView.h"
#import "AEScene.h"
#import "AEModel.h"
#import "AESkybox.h"
#import "AEMath.h"

#import "AEBasicGeometry.h"
#import "AEMaterial.h"


struct Uniforms {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
};

@interface AERenderer ()

@property (nonatomic,strong) id<MTLDevice> device;
@property (nonatomic,strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic,strong) AEPipelineStateManager *pipelineStateManager;
@property (nonatomic,strong) AEWorldContext *worldContext;

@property (nonatomic,strong) AEModel *model;
@property (nonatomic,assign) struct Uniforms uniform;

@property (nonatomic,strong) id<MTLTexture> msaaTexture;

@end

@implementation AERenderer

- (instancetype)initWithDevice:(id<MTLDevice>)device {
    if ((self = [super init])) {
        _device = device;
        _commandQueue = [device newCommandQueue];
        self.pipelineStateManager = [[AEPipelineStateManager alloc] init];
        [self setupPipeline];
        _model = [[AEModel alloc] initWithURL:nil device:self.device];
        [self setMSAA];
    }
    return self;
}

- (void)setupPipeline {
    
    id<MTLLibrary> library = [self.device newDefaultLibrary];
    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"main_vertex"];
    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"main_fragment"];
    id<MTLFunction> unlit_fs = [library newFunctionWithName:@"xlatMtlMain"];
    
    NSError *error;
    MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:self.device];
    MDLMesh *cube = [[MDLMesh alloc] initBoxWithExtent:simd_make_float3(0.1,0.1,0.1) segments:simd_make_uint3(20,20,20) inwardNormals:true geometryType:MDLGeometryTypeTriangles allocator:allocator];
    
    MTLRenderPipelineDescriptor *pipelineDes = [MTLRenderPipelineDescriptor new];
    pipelineDes.vertexFunction = vertexFunction;
    pipelineDes.fragmentFunction = fragmentFunction;
    pipelineDes.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
  
    
    pipelineDes.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(cube.vertexDescriptor);
    if (@available(iOS 16.0, *)) {
        pipelineDes.sampleCount = 4;
    } else {
        pipelineDes.rasterSampleCount = 4;
    }
    //self.pipelineState = [self.device newRenderPipelineStateWithDescriptor:pipelineDes error:&error];
    
    
//    // 创建和配置渲染管线状态
//    id<MTLLibrary> library = [self.device newDefaultLibrary];
//    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"main_vertex"];
//    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"main_fragment"];
//    MTLVertexDescriptor *vertexDescriptor = [self createVertexDescriptor];
//
    AEPipelineState *pipelineState = [[AEPipelineState alloc] initWithDevice:self.device
                                                               vertexFunction:vertexFunction
                                                              fragmentFunction:unlit_fs
                                                              vertexDescriptor:MTKMetalVertexDescriptorFromModelIO(cube.vertexDescriptor)
                                                                 pixelFormat:MTLPixelFormatBGRA8Unorm];
    [self.pipelineStateManager addPipelineState:pipelineState withName:@"BasicPipeline"];

}

- (void)setMSAA {
    if (self.view == NULL) { return; }
    if (self.msaaTexture) {
        return;
    }
    CAMetalLayer *layer = [self.view getLayer];
    
    
    MTLTextureDescriptor *msaa = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatBGRA8Unorm width:layer.frame.size.width height:layer.frame.size.height mipmapped:NO];
    msaa.textureType = MTLTextureType2DMultisample;  // 多重采样
    msaa.sampleCount = 4;
    msaa.usage = MTLTextureUsageRenderTarget;
    msaa.storageMode = MTLStorageModeMemoryless; //MTLStorageModePrivate;

    id<MTLTexture> msaaTex = [self.device newTextureWithDescriptor:msaa];
    self.msaaTexture = msaaTex;
}

- (void)renderWithScene:(AEScene*)scene {
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    
    if (self.view == NULL) { return; }
    [self setMSAA];
    CAMetalLayer *layer = [self.view getLayer];
    if (layer) {
        id<CAMetalDrawable> drawable = [layer nextDrawable];
        if (drawable == NULL) {
            return;
        }
        MTLRenderPassDescriptor *renderPassDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];
        if (self.msaaTexture) {
            renderPassDescriptor.colorAttachments[0].texture = self.msaaTexture;
            renderPassDescriptor.colorAttachments[0].resolveTexture = drawable.texture;
            renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionMultisampleResolve;
        } else {
            renderPassDescriptor.colorAttachments[0].texture = drawable.texture;
            renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
        }
        renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
//        renderPassDescriptor.colorAttachments[0].storeAction = MTLStoreActionDontCare;
        
//        renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1);
        

        
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        
        if ([scene getSkybox]) {
            [self renderSkybox:[scene getSkybox] Encoder:renderEncoder];
        }
        if ([scene getCamera]) {
            _uniform.projectionMatrix = [scene getCamera].projectionMatrix;
            _uniform.viewMatrix = [scene getCamera].viewMatrix;
        }
        
        // Set the pipeline state.
        AEPipelineState *pipelineState = [self.pipelineStateManager pipelineStateWithName:@"BasicPipeline"];
        [renderEncoder setRenderPipelineState:pipelineState.pipelineState];
        
        for (AEComponent *comp in scene.objects) {
            if ([comp isKindOfClass:[AEGeometry class]]) {
                AEGeometry* geometry = (AEGeometry*)comp;
                
                
                // model
                matrix_float4x4 trans = Translation_float4x4(geometry.position);
                matrix_float4x4 rotation = Rotation_float4x4(simd_make_float3(0,0,0));
                matrix_float4x4 scale = scaling(0.1, 0.05, 0.1);
                matrix_float4x4 modelMatrix = matrix_multiply(trans, matrix_multiply(rotation, scale));
                _uniform.modelMatrix = modelMatrix;
                
                [renderEncoder setVertexBytes:&_uniform length:sizeof(_uniform) atIndex:1];
                
                AEMaterial *mat = [geometry getMaterial];
                [renderEncoder setFragmentTexture:[mat getTexture] atIndex:1];
                
                [geometry render:renderEncoder];
            }
        }
        
        // Here you would set other render command encoder state and draw calls.
//        [self.view render];
        
        //[_model renderWithRenderEncoder:renderEncoder];
        
        // End encoding and present the drawable to the screen.
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:drawable];
    }
    [commandBuffer commit];
}

- (void)renderSkybox:(AESkybox*)skybox Encoder:(id<MTLRenderCommandEncoder>)encoder {
    
}

//- (instancetype)initWithMetalView:(MTKView *)metalView {
//    self = [super init];
//    if (self) {
//        self.device = metalView.device;
//        self.commandQueue = [self.device newCommandQueue];
//        self.pipelineStateManager = [[AEPipelineStateManager alloc] init];
//        self.worldContext = [[AEWorldContext alloc] initWithLayer:metalView.layer];
//    }
//    return self;
//}
//
//- (void)initialize {
//    // 初始化渲染资源，如管线状态、纹理等
//    // 创建和配置渲染管线状态
//    id<MTLLibrary> library = [self.device newDefaultLibrary];
//    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"main_vertex"];
//    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"main_fragment"];
//    MTLVertexDescriptor *vertexDescriptor = [self createVertexDescriptor];
//    
//    AEPipelineState *pipelineState = [[AEPipelineState alloc] initWithDevice:self.device
//                                                               vertexFunction:vertexFunction
//                                                              fragmentFunction:fragmentFunction
//                                                              vertexDescriptor:vertexDescriptor
//                                                                 pixelFormat:metalView.colorPixelFormat];
//    [self.pipelineStateManager addPipelineState:pipelineState withName:@"BasicPipeline"];
//}
//
//- (void)update {
//    // 更新渲染相关的数据，如相机位置、模型变换等
//    [self.worldContext update];
//}
//
//- (void)render {
//    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
//    id<MTLRenderPassDescriptor> renderPassDescriptor = [self createRenderPassDescriptor];
//    id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
//    
//    AEPipelineState *pipelineState = [self.pipelineStateManager pipelineStateWithName:@"BasicPipeline"];
//    [renderEncoder setRenderPipelineState:pipelineState.pipelineState];
//    
//    // 绘制场景中的对象
//    for (AEComponent *component in [self.worldContext.currentScene GetElements]) {
//        if ([component isKindOfClass:[AEMesh class]]) {
//            AEMesh *mesh = (AEMesh *)component;
//            [self drawMesh:mesh withRenderEncoder:renderEncoder];
//        }
//    }
//    
//    [renderEncoder endEncoding];
//    [commandBuffer presentDrawable:[self.worldContext.layer nextDrawable]];
//    [commandBuffer commit];
//}
//
//- (void)shutdown {
//    // 释放渲染资源
//    self.pipelineStateManager = nil;
//    self.worldContext = nil;
//    self.commandQueue = nil;
//    self.device = nil;
//}
//


- (MTLVertexDescriptor *)createVertexDescriptor {
    // 创建顶点描述符
    MTLVertexDescriptor *vertexDescriptor = [[MTLVertexDescriptor alloc] init];
    // 配置顶点描述符属性
    return vertexDescriptor;
}

- (MTLRenderPassDescriptor *)createRenderPassDescriptor {
    // 创建渲染通道描述符
    MTLRenderPassDescriptor *renderPassDescriptor = [[MTLRenderPassDescriptor alloc] init];
    // 配置渲染通道描述符
    return renderPassDescriptor;
}
//
//- (void)drawMesh:(AEMesh *)mesh withRenderEncoder:(id<MTLRenderCommandEncoder>)renderEncoder {
//    // 绘制网格
//    [renderEncoder setVertexBuffer:mesh.vertexBuffer offset:0 atIndex:0];
//    [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:mesh.vertexCount];
//}
//
@end
