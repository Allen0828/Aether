//
//  AEBasicGeometry.h
//  Aether-swift
//
//  Created by Allen on 2025/2/20.
//

#import "AEComponent.h"
#import <simd/simd.h>

@class AEMaterial;
@class AEMesh;

@interface AEGeometry : AEComponent

- (AEMaterial*)getMaterial;
- (void)SetMaterial:(AEMaterial*)mat;

- (AEMesh*)getMeshData;
- (void)SetMeshData:(AEMesh*)mesh;

- (void)render:(id<MTLRenderCommandEncoder>)encoder;

@end


@interface AEPlaneGeometry : AEGeometry

- (instancetype)initWithExtent:(vector_float3)extent segments:(vector_uint2)segments;
- (void)resize:(vector_float3)extent segments:(vector_uint2)segments;

@end

@interface AEBoxGeometry : AEGeometry

- (instancetype)initWithExtent:(vector_float3)extent segments:(vector_uint3)segments normals:(BOOL)inwardNormals;


@end

@interface AESphereGeometry : AEGeometry

- (instancetype)initWithStacks:(int)stacks slices:(int)slices radius:(float)radius;
- (void)resize:(int)stacks slices:(int)slices radius:(float)radius;

@end

@interface AECylinderGeometry : AEGeometry

- (instancetype)initWithExtent:(vector_float3)extent segments:(vector_uint2)segments normals:(BOOL)inwardNormals topCap:(BOOL)tCap bottomCap:(BOOL)bCap;

@end

@interface AEConeGeometry : AEGeometry

- (instancetype)initWithExtent:(vector_float3)extent segments:(vector_uint2)segments normals:(BOOL)inwardNormals cap:(BOOL)cap;


@end
