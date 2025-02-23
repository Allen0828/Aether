//
//  AESkybox.m
//  Aether
//
//  Created by Allen on 2024/12/30.
//

#import "AESkybox.h"
#import "AECamera.h"
#import <MetalKit/MetalKit.h>
#import <Metal/Metal.h>
#import <ModelIO/ModelIO.h>

@interface AESkybox ()


@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;

@end

@implementation AESkybox

- (instancetype)initWithDevice:(id<MTLDevice>)device
                      texture:(id<MTLTexture>)texture {
    self = [super init];
    if (self) {
        _device = device;
        _texture = texture;
        _mesh = [self createSkyboxMeshWithDevice:device];
        _pipelineState = [self createRenderPipelineStateWithDevice:device];
    }
    return self;
}

- (MTKMesh *)createSkyboxMeshWithDevice:(id<MTLDevice>)device {
    // 定义立方体的顶点数据
    struct Vertex {
        vector_float3 position;
        vector_float2 texCoord;
    };
    
    struct Vertex vertices[] = {
        // 定义立方体的顶点数据
        // 请根据实际需求填充顶点数据
    };
    
    uint16_t indices[] = {
        // 定义立方体的索引数据
        // 请根据实际需求填充索引数据
    };
    
    // 创建顶点缓冲区和索引缓冲区
    id<MTLBuffer> vertexBuffer = [device newBufferWithBytes:vertices
                                                      length:sizeof(vertices)
                                                     options:MTLResourceStorageModeShared];
    id<MTLBuffer> indexBuffer = [device newBufferWithBytes:indices
                                                     length:sizeof(indices)
                                                    options:MTLResourceStorageModeShared];
    
    // 创建 MTKMesh
    MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
    
    MTKMesh *mesh;
//    = [MTKMesh newMeshWithDevice:device
//                                      allocator:allocator
//                                      vertexDescriptor:nil
//                                      vertexBuffers:@[vertexBuffer]
//                                      vertexCount:sizeof(vertices) / sizeof(vertices[0])
//                                      indexBuffer:indexBuffer
//                                      indexCount:sizeof(indices) / sizeof(indices[0])
//                                      indexType:MTLIndexTypeUInt16];
    
    return mesh;
}

- (id<MTLRenderPipelineState>)createRenderPipelineStateWithDevice:(id<MTLDevice>)device {
    // 创建渲染管线状态
    MTLRenderPipelineDescriptor *pipelineDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    pipelineDescriptor.vertexFunction = [[device newDefaultLibrary] newFunctionWithName:@"vertexShader"];
    pipelineDescriptor.fragmentFunction = [[device newDefaultLibrary] newFunctionWithName:@"fragmentShader"];
    pipelineDescriptor.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    NSError *error = nil;
    id<MTLRenderPipelineState> pipelineState = [device newRenderPipelineStateWithDescriptor:pipelineDescriptor error:&error];
    if (error) {
        NSLog(@"Error creating render pipeline state: %@", error);
    }
    
    return pipelineState;
}

- (void)renderWithRenderEncoder:(id<MTLRenderCommandEncoder>)renderEncoder
                        camera:(AECamera *)camera {
    // 设置渲染管线状态
    [renderEncoder setRenderPipelineState:self.pipelineState];
    [renderEncoder setFragmentTexture:self.texture atIndex:0];
    
    // 设置视图矩阵和投影矩阵
    matrix_float4x4 viewMatrix = camera.viewMatrix;
    matrix_float4x4 projectionMatrix = camera.projectionMatrix;
    matrix_float4x4 viewProjectionMatrix = matrix_multiply(projectionMatrix, viewMatrix);
    
    // 设置天空盒的变换矩阵
    matrix_float4x4 skyboxTransform = matrix_identity_float4x4;
    skyboxTransform.columns[3] = (simd_make_float4(camera.position, 1));
    matrix_float4x4 modelViewProjectionMatrix = matrix_multiply(viewProjectionMatrix, skyboxTransform);
    
    [renderEncoder setVertexBytes:&modelViewProjectionMatrix length:sizeof(modelViewProjectionMatrix) atIndex:0];
    
    // 绘制天空盒网格
    for (MTKSubmesh *submesh in self.mesh.submeshes) {
        [renderEncoder setVertexBuffer:submesh.indexBuffer offset:0 atIndex:0];
        [renderEncoder drawIndexedPrimitives:submesh.primitiveType
                                  indexCount:submesh.indexCount
                                    indexType:submesh.indexType
                                  indexBuffer:submesh.indexBuffer.buffer
                        indexBufferOffset:submesh.indexBuffer.offset];
    }
}

- (id<MTLTexture>)loadCubeMapTextureWithDevice:(id<MTLDevice>)device
                                        images:(NSArray<CIImage *> *)images {
    // 创建立方体贴图描述符
    //MTLTextureDescriptor *textureDescriptor = [MTLTextureDescriptor textureCubeDescriptorWithPixelFormat:MTLPixelFormatBGRA8Unorm
                                                                                                // width:images[0].size.width
                                                                                                // mipmapped:NO];
    id<MTLTexture> cubeMapTexture; // = [device newTextureWithDescriptor:textureDescriptor];

//    // 将图像数据加载到立方体贴图中
//    for (NSUInteger i = 0; i < images.count; i++) {
//        CGImageRef cgImage = images[i].CGImage;
//        size_t width = CGImageGetWidth(cgImage);
//        size_t height = CGImageGetHeight(cgImage);
//        size_t bytesPerPixel = 4;
//        size_t bytesPerRow = width * bytesPerPixel;
//        size_t bitsPerComponent = 8;
//
//        // 创建颜色空间
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        void *data = malloc(height * bytesPerRow);
//
//        // 创建上下文
//        CGContextRef context = CGBitmapContextCreate(data, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
//        CGColorSpaceRelease(colorSpace);
//
//        // 绘制图像
//        CGContextDrawImage(context, CGRectMake(0, 0, width, height), cgImage);
//        CGContextRelease(context);
//
//        // 将图像数据复制到纹理
//        [cubeMapTexture replaceRegion:MTLRegionMake2D(0, 0, width, height)
//                          mipmapLevel:0
//                            withBytes:data
//                             bytesPerRow:bytesPerRow
//                                face:(MTLCubeMapFace)i];
//
//        free(data);
//    }

    return cubeMapTexture;
}

@end
