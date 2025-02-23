//
//  AEElement.m
//  Aether
//
//  Created by Allen on 2024/12/30.
//

#import "AEModel.h"
#import <MetalKit/MetalKit.h>

/*
 通常有两种方式来处理数据
 1 将MDLMesh 转为MTKMesh 传入渲染
 2 提取MDLMesh 中的数据来创建MTLBuffer 传入渲染
 */

@interface AEModel ()


@property (nonatomic,strong) id<MTLRenderPipelineState> pipelineState;

// 方式1
@property (nonatomic,strong) MTKMesh *mtkMesh;

// 方式2
@property (nonatomic,strong) id<MTLBuffer> vertexBuffer;
@property (nonatomic,strong) id<MTLBuffer> indexBuffer;
@property (nonatomic,assign) MTLIndexType indexType;
@property (nonatomic,assign) NSUInteger indexCount;


@end

@implementation AEModel

- (instancetype)initWithURL:(NSURL *)modelURL device:(id<MTLDevice>)device {
    self = [super init];
    if (self) {
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
        
        // test
        MDLMesh *cube = [[MDLMesh alloc] initBoxWithExtent:simd_make_float3(0.1,0.1,0.1) segments:simd_make_uint3(20,20,20) inwardNormals:true geometryType:MDLGeometryTypeTriangles allocator:allocator];
        // 方式1
        NSError *error;
        self.mtkMesh = [[MTKMesh alloc] initWithMesh:cube device:MTLCreateSystemDefaultDevice() error:&error];
        
        // 方式2
//        id<MDLMeshBuffer> vertexBuffer = cube.vertexBuffers[0];
//        void *vertexData = [[vertexBuffer map] bytes];
//        self.vertexBuffer = [device newBufferWithLength:vertexBuffer.length options:MTLResourceStorageModeShared];
//        memcpy(self.vertexBuffer.contents, vertexData, vertexBuffer.length);
//        
//        MDLSubmesh *submesh = cube.submeshes[0];
//        void *indexData = [submesh.indexBuffer map].bytes;
//        self.indexBuffer = [device newBufferWithLength:submesh.indexBuffer.length options:MTLResourceStorageModeShared];
//        memcpy(self.indexBuffer.contents, indexData, submesh.indexBuffer.length);
//        
//        self.indexType = submesh.indexType == MDLIndexBitDepthUint32 ? MTLIndexTypeUInt32 : MTLIndexTypeUInt16;
//        self.indexCount = submesh.indexCount;
        

        
        // pipeline
        id<MTLLibrary> library = [device newDefaultLibrary];
        id<MTLFunction> vertexFunction = [library newFunctionWithName:@"main_vertex"];
        id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"main_fragment"];
        
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
        

        
        self.pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDes error:&error];
        if (error != nil) {
            NSLog(@"ERROR %@", error);
        }
        
    }
    return self;
}

- (void)renderWithRenderEncoder:(id<MTLRenderCommandEncoder>)renderEncoder {
    
    [renderEncoder setRenderPipelineState:self.pipelineState];
    
    // 方式1
    for (int i = 0; i < self.mtkMesh.vertexBuffers.count; i++) {
        id<MTLBuffer> buffer = self.mtkMesh.vertexBuffers[i].buffer;
        [renderEncoder setVertexBuffer:buffer offset:0 atIndex:i];
    }
    
    for (MTKSubmesh *submesh in self.mtkMesh.submeshes) {
        [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:submesh.indexCount indexType:submesh.indexType indexBuffer:submesh.indexBuffer.buffer indexBufferOffset:submesh.indexBuffer.offset];
    }
    
    // 方式2
    //[renderEncoder setVertexBuffer:self.vertexBuffer offset:0 atIndex:0];
    //[renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:self.indexCount indexType:self.indexType indexBuffer:self.indexBuffer indexBufferOffset:0];
    
}


@end
