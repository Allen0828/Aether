//
//  AEMesh.m
//  testAether
//
//  Created by Allen on 2025/1/5.
//

// AEMesh.m
#import "AEMesh.h"
//#import "Vertex.h" // 假设 Vertex 是一个结构体，定义了顶点的数据



@implementation AEMesh

- (instancetype)initWithDevice:(id<MTLDevice>)device
                     vertices:(const Vertex *)vertices
                     vertexCount:(NSUInteger)vertexCount
                     indices:(const uint16_t *)indices
                     indexCount:(NSUInteger)indexCount {
    self = [super init];
    if (self) {
        self.vertexCount = vertexCount;
        self.indexCount = indexCount;
        
        // 创建顶点缓冲区
        self.vertexBuffer = [device newBufferWithBytes:vertices
                                             length:vertexCount * sizeof(Vertex)
                                            options:MTLResourceStorageModeShared];
        
        // 创建索引缓冲区
        self.indexBuffer = [device newBufferWithBytes:indices
                                             length:indexCount * sizeof(uint16_t)
                                            options:MTLResourceStorageModeShared];
        
        // 创建顶点描述符
        self.vertexDescriptor = [self createVertexDescriptor];
    }
    return self;
}

- (MTLVertexDescriptor *)createVertexDescriptor {
    MTLVertexDescriptor *vertexDescriptor = [[MTLVertexDescriptor alloc] init];
    vertexDescriptor.attributes[0].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[0].offset = 0;
    vertexDescriptor.attributes[0].bufferIndex = 0;
    vertexDescriptor.attributes[1].format = MTLVertexFormatFloat3;
    vertexDescriptor.attributes[1].offset = sizeof(vector_float3);
    vertexDescriptor.attributes[1].bufferIndex = 0;
    vertexDescriptor.attributes[2].format = MTLVertexFormatFloat2;
    vertexDescriptor.attributes[2].offset = sizeof(vector_float3) * 2;
    vertexDescriptor.attributes[2].bufferIndex = 0;
    
    vertexDescriptor.layouts[0].stride = sizeof(Vertex);
    return vertexDescriptor;
}

- (void)renderWithRenderEncoder:(id<MTLRenderCommandEncoder>)renderEncoder {
    [renderEncoder setVertexBuffer:self.vertexBuffer offset:0 atIndex:0];
    [renderEncoder setVertexBuffer:self.indexBuffer offset:0 atIndex:1];
    [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                              indexCount:self.indexCount
                                indexType:MTLIndexTypeUInt16
                              indexBuffer:self.indexBuffer
                        indexBufferOffset:0];
}

@end
