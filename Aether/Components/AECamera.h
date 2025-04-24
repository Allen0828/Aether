//
//  AECamera.h
//  Aether
//
//  Created by Allen on 2024/12/31.
//

#import <simd/simd.h>
#import "AEComponent.h"

typedef enum : NSUInteger {
    Perspective,
    Orthographic
} EProjectionMode;

@interface AECamera : AEComponent

@property (nonatomic,assign) EProjectionMode projectionMode;

@property (nonatomic,assign) simd_float3 target;
@property (nonatomic,assign) simd_float3 upDirection;
@property (nonatomic,assign) CGFloat fov; // Field of view (degrees)
@property (nonatomic,assign) CGFloat aspectRatio;
@property (nonatomic,assign) CGFloat near;
@property (nonatomic,assign) CGFloat far;

@property (nonatomic,assign,readonly) matrix_float4x4 projectionMatrix;
@property (nonatomic,assign,readonly) matrix_float4x4 viewMatrix;

- (instancetype)initWithPosition:(simd_float3)position
                           target:(simd_float3)target
                       upDirection:(simd_float3)upDirection;

- (void)updateViewMatrix;
- (void)updateProjectionMatrix;
- (matrix_float4x4)getViewMatrix;
- (matrix_float4x4)getProjectionMatrix;

@end
