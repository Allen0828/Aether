//
//  AEBasicGeometry.m
//  Aether-swift
//
//  Created by Allen on 2025/2/20.
//

#import "AEEngine.h"
#import "AEBasicGeometry.h"
#import "AEMaterial.h"
#import "AEMesh.h"
#import <MetalKit/MetalKit.h>

@interface AEGeometry ()

@property (nonatomic,strong) AEMaterial *mat;
//@property (nonatomic,strong) AEMesh *mesh;

@property (nonatomic,strong) NSArray<MTKMeshBuffer *> *vertexBuffers;
@property (nonatomic,strong) NSArray<MTKSubmesh *> *submeshes;
@property (nonatomic,assign) NSUInteger vertexCount;

//@property (nonatomic,strong) NSArray<MTKMesh *> *meshes;

@end

@implementation AEGeometry

- (EComponent_ClassType)classType {
    return BoxGeometry;
}

- (AEMaterial*)getMaterial {
    return self.mat;
}
- (void)SetMaterial:(AEMaterial*)mat {
    self.mat = mat;
}

- (AEMesh*)getMeshData {
    return nil; //self.mesh;
}
- (void)SetMeshData:(AEMesh*)mesh {
    //self.mesh = mesh;
}

- (void)render:(id<MTLRenderCommandEncoder>)encoder {
    for (int i = 0; i < self.vertexBuffers.count; i++) {
        id<MTLBuffer> buffer = self.vertexBuffers[i].buffer;
        [encoder setVertexBuffer:buffer offset:0 atIndex:i];
    }
    
    for (MTKSubmesh *submesh in self.submeshes) {
        [encoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle indexCount:submesh.indexCount indexType:submesh.indexType indexBuffer:submesh.indexBuffer.buffer indexBufferOffset:submesh.indexBuffer.offset];
    }
}

@end


@implementation AEPlaneGeometry : AEGeometry

- (instancetype)initWithExtent:(vector_float3)extent segments:(vector_uint2)segments {
    if (self = [super init]) {
        NSError *error;
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:AEEngine.device];
        MDLMesh *mdlMesh = [[MDLMesh alloc] initPlaneWithExtent:extent segments:segments geometryType:MDLGeometryTypeTriangles allocator:allocator];
        
        MTKMesh *mtkMesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:AEEngine.device error:&error];
        if (error != nil) {
            NSLog(@"create box geometry error %@", error);
        } else {
            self.vertexBuffers = mtkMesh.vertexBuffers;
            self.submeshes = mtkMesh.submeshes;
            self.vertexCount = mtkMesh.vertexCount;
        }
    }
    return self;
}
- (void)resize:(vector_float3)extent segments:(vector_uint2)segments {
    
}

@end

@implementation AEBoxGeometry : AEGeometry

- (instancetype)initWithExtent:(vector_float3)extent segments:(vector_uint3)segments normals:(BOOL)inwardNormals {
    if (self = [super init]) {
        NSError *error;
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:AEEngine.device];
        MDLMesh *mdlMesh = [[MDLMesh alloc] initBoxWithExtent:extent segments:segments inwardNormals:inwardNormals geometryType:MDLGeometryTypeTriangles allocator:allocator];
        
        MTKMesh *mtkMesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:AEEngine.device error:&error];
        if (error != nil) {
            NSLog(@"create box geometry error %@", error);
        } else {
            self.vertexBuffers = mtkMesh.vertexBuffers;
            self.submeshes = mtkMesh.submeshes;
            self.vertexCount = mtkMesh.vertexCount;
        }
    }
    return self;
}


@end

@implementation AESphereGeometry : AEGeometry

- (instancetype)initWithStacks:(int)stacks slices:(int)slices radius:(float)radius {
    if (self = [super init]) {
        NSError *error;
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:AEEngine.device];
        MDLMesh *mdlMesh = [[MDLMesh alloc] initSphereWithExtent:simd_make_float3(radius, radius, radius) segments:simd_make_uint2(stacks, slices) inwardNormals:false geometryType:MDLGeometryTypeTriangles allocator:allocator];
        
        MTKMesh *mtkMesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:AEEngine.device error:&error];
        if (error != nil) {
            NSLog(@"create box geometry error %@", error);
        } else {
            self.vertexBuffers = mtkMesh.vertexBuffers;
            self.submeshes = mtkMesh.submeshes;
            self.vertexCount = mtkMesh.vertexCount;
        }
    }
    return self;
}
- (void)resize:(int)stacks slices:(int)slices radius:(float)radius {
    
}

@end

@implementation AECylinderGeometry : AEGeometry

- (instancetype)initWithExtent:(vector_float3)extent segments:(vector_uint2)segments normals:(BOOL)inwardNormals topCap:(BOOL)tCap bottomCap:(BOOL)bCap {
    if (self = [super init]) {
        NSError *error;
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:AEEngine.device];
        MDLMesh *mdlMesh = [[MDLMesh alloc] initCylinderWithExtent:extent segments:segments inwardNormals:inwardNormals topCap:tCap bottomCap:bCap geometryType:MDLGeometryTypeTriangles allocator:allocator];
        
        MTKMesh *mtkMesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:AEEngine.device error:&error];
        if (error != nil) {
            NSLog(@"create box geometry error %@", error);
        } else {
            self.vertexBuffers = mtkMesh.vertexBuffers;
            self.submeshes = mtkMesh.submeshes;
            self.vertexCount = mtkMesh.vertexCount;
        }
    }
    return self;
}

@end

@implementation AEConeGeometry : AEGeometry

- (instancetype)initWithExtent:(vector_float3)extent segments:(vector_uint2)segments normals:(BOOL)inwardNormals cap:(BOOL)cap {
    if (self = [super init]) {
        NSError *error;
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:AEEngine.device];
        MDLMesh *mdlMesh = [[MDLMesh alloc] initConeWithExtent:extent segments:segments inwardNormals:inwardNormals cap:cap geometryType:MDLGeometryTypeTriangles allocator:allocator];
        
        MTKMesh *mtkMesh = [[MTKMesh alloc] initWithMesh:mdlMesh device:AEEngine.device error:&error];
        if (error != nil) {
            NSLog(@"create box geometry error %@", error);
        } else {
            self.vertexBuffers = mtkMesh.vertexBuffers;
            self.submeshes = mtkMesh.submeshes;
            self.vertexCount = mtkMesh.vertexCount;
        }
    }
    return self;
}


@end
