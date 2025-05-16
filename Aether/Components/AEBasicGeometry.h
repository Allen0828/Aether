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

- (nonnull AEMaterial*)getMaterial;
- (void)SetMaterial:(nonnull AEMaterial*)mat;

- (nullable AEMesh*)getMeshData;
- (void)SetMeshData:(nullable AEMesh*)mesh;

- (void)render:(nullable id<MTLRenderCommandEncoder>)encoder;

@end


@interface AEPlaneGeometry : AEGeometry

- (nonnull instancetype)initWithExtent:(vector_float3)extent segments:(vector_uint2)segments;
- (void)resize:(vector_float3)extent segments:(vector_uint2)segments;

@end

@interface AEBoxGeometry : AEGeometry

- (nonnull instancetype)initWithExtent:(vector_float3)extent segments:(vector_uint3)segments normals:(BOOL)inwardNormals;


@end

@interface AESphereGeometry : AEGeometry

- (nonnull instancetype)initWithStacks:(int)stacks slices:(int)slices radius:(float)radius;
- (void)resize:(int)stacks slices:(int)slices radius:(float)radius;

@end

@interface AECylinderGeometry : AEGeometry

- (nonnull instancetype)initWithExtent:(vector_float3)extent segments:(vector_uint2)segments normals:(BOOL)inwardNormals topCap:(BOOL)tCap bottomCap:(BOOL)bCap;

@end

@interface AEConeGeometry : AEGeometry

- (nonnull instancetype)initWithExtent:(vector_float3)extent segments:(vector_uint2)segments normals:(BOOL)inwardNormals cap:(BOOL)cap;


@end
