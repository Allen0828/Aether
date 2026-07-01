//
//  AEMesh.h
//  testAether
//
//  Created by Allen on 2025/1/5.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <simd/simd.h>

typedef struct
{
    vector_float3 position;
    vector_float3 normal;
    vector_float2 uv;
  
} Vertex;

@interface AEMesh : NSObject

@property (nonatomic, strong) id<MTLBuffer> vertexBuffer;
@property (nonatomic, strong) id<MTLBuffer> indexBuffer;
@property (nonatomic, assign) NSUInteger vertexCount;
@property (nonatomic, assign) NSUInteger indexCount;
@property (nonatomic, strong) MTLVertexDescriptor *vertexDescriptor;

- (instancetype)initWithDevice:(id<MTLDevice>)device
                     vertices:(const Vertex *)vertices
                     vertexCount:(NSUInteger)vertexCount
                     indices:(const uint16_t *)indices
                     indexCount:(NSUInteger)indexCount;


- (void)setMaterialFromFile:(NSString*)path;

- (void)renderWithRenderEncoder:(id<MTLRenderCommandEncoder>)renderEncoder;

@end

