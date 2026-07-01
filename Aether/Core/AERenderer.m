//
//  AERenderer.m
//  Aether
//

#import "AERenderer.h"
#import "AECamera.h"
#import "../Model/AEMesh.h"
#import "../Math/AEMath.h"

@interface AERenderer ()
@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;
@property (nonatomic, strong) id<MTLDepthStencilState> depthState;
@property (nonatomic, strong) id<MTLTexture> depthTexture;
@property (nonatomic, strong) dispatch_semaphore_t inFlightSemaphore;
@end

@implementation AERenderer

- (instancetype)initWithDevice:(id<MTLDevice>)device {
    if (self = [super init]) {
        _device = device;
        _commandQueue = [device newCommandQueue];
        _inFlightSemaphore = dispatch_semaphore_create(2);
        [self _buildPipeline];
    }
    return self;
}

- (void)_buildPipeline {
    id<MTLLibrary> lib = [self.device newDefaultLibrary];
    id<MTLFunction> vs = [lib newFunctionWithName:@"main_vertex"];
    id<MTLFunction> fs = [lib newFunctionWithName:@"main_fragment"];
    
    // Vertex descriptor matching AEMesh Vertex struct layout.
    // Buffer 0 = uniforms; buffer 1 = vertex data.
    MTLVertexDescriptor *vd = [MTLVertexDescriptor new];
    vd.attributes[0].format = MTLVertexFormatFloat3;
    vd.attributes[0].offset  = offsetof(Vertex, position);
    vd.attributes[0].bufferIndex = 1;
    vd.attributes[1].format = MTLVertexFormatFloat3;
    vd.attributes[1].offset  = offsetof(Vertex, normal);
    vd.attributes[1].bufferIndex = 1;
    vd.attributes[2].format = MTLVertexFormatFloat2;
    vd.attributes[2].offset  = offsetof(Vertex, uv);
    vd.attributes[2].bufferIndex = 1;
    vd.layouts[1].stride = sizeof(Vertex);
    vd.layouts[1].stepRate = 1;
    vd.layouts[1].stepFunction = MTLVertexStepFunctionPerVertex;

    MTLRenderPipelineDescriptor *desc = [MTLRenderPipelineDescriptor new];
    desc.vertexFunction = vs;
    desc.fragmentFunction = fs;
    desc.vertexDescriptor = vd;
    desc.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    desc.depthAttachmentPixelFormat = MTLPixelFormatDepth32Float;
    desc.sampleCount = 1;
    
    NSError *err = nil;
    _pipelineState = [self.device newRenderPipelineStateWithDescriptor:desc error:&err];
    if (!_pipelineState) {
        NSLog(@"AERenderer: pipeline error %@", err);
    }
    
    // Depth stencil state
    MTLDepthStencilDescriptor *dsDesc = [MTLDepthStencilDescriptor new];
    dsDesc.depthCompareFunction = MTLCompareFunctionLess;
    dsDesc.depthWriteEnabled = YES;
    _depthState = [self.device newDepthStencilStateWithDescriptor:dsDesc];
}

- (void)renderMesh:(AEMesh *)mesh inLayer:(CAMetalLayer *)layer {
    if (!mesh || !self.camera) return;
    
    @autoreleasepool {
        id<CAMetalDrawable> drawable = [layer nextDrawable];
        if (!drawable) return;
        
        // Lazily create depth texture matching drawable size
        NSUInteger drawableWidth = drawable.texture.width;
        NSUInteger drawableHeight = drawable.texture.height;
        if (drawableWidth < 1 || drawableHeight < 1) return;
        if (!self.depthTexture ||
            self.depthTexture.width != drawableWidth ||
            self.depthTexture.height != drawableHeight) {
            MTLTextureDescriptor *depthDesc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatDepth32Float
                                                                                                 width:drawableWidth
                                                                                                height:drawableHeight
                                                                                             mipmapped:NO];
            depthDesc.storageMode = MTLStorageModePrivate;
            depthDesc.usage = MTLTextureUsageRenderTarget;
            self.depthTexture = [self.device newTextureWithDescriptor:depthDesc];
        }
        
        MTLRenderPassDescriptor *rpd = [MTLRenderPassDescriptor renderPassDescriptor];
        rpd.colorAttachments[0].texture = drawable.texture;
        rpd.colorAttachments[0].loadAction = MTLLoadActionClear;
        rpd.colorAttachments[0].clearColor = MTLClearColorMake(0.1, 0.1, 0.12, 1.0);
        rpd.colorAttachments[0].storeAction = MTLStoreActionStore;
        rpd.depthAttachment.texture = self.depthTexture;
        rpd.depthAttachment.loadAction = MTLLoadActionClear;
        rpd.depthAttachment.storeAction = MTLStoreActionStore;
        rpd.depthAttachment.clearDepth = 1.0;
        
        // Guard: skip if depth texture is nil (e.g. allocation failed)
        if (!self.depthTexture) return;
        
        id<MTLCommandBuffer> cmdBuf = [self.commandQueue commandBuffer];
        id<MTLRenderCommandEncoder> enc = [cmdBuf renderCommandEncoderWithDescriptor:rpd];
        [enc setRenderPipelineState:self.pipelineState];
        [enc setDepthStencilState:self.depthState];
        
        struct {
            matrix_float4x4 modelMatrix;
            matrix_float4x4 viewMatrix;
            matrix_float4x4 projectionMatrix;
        } uniforms;
        uniforms.modelMatrix = matrix_identity_float4x4;
        uniforms.viewMatrix = self.camera.viewMatrix;
        uniforms.projectionMatrix = self.camera.projectionMatrix;
        
        [enc setVertexBytes:&uniforms length:sizeof(uniforms) atIndex:0];
        [mesh renderWithRenderEncoder:enc];
        
        [enc endEncoding];
        [cmdBuf presentDrawable:drawable];
        
        // Throttle CPU to avoid drawable contention
        dispatch_semaphore_wait(_inFlightSemaphore, DISPATCH_TIME_FOREVER);
        [cmdBuf addCompletedHandler:^(id<MTLCommandBuffer> _Nonnull buf) {
            dispatch_semaphore_signal(self->_inFlightSemaphore);
        }];
        [cmdBuf commit];
    }
}

@end
