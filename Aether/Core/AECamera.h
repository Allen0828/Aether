//
//  AECamera.h
//  Aether
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface AECamera : NSObject

@property (nonatomic) simd_float3 position;
@property (nonatomic) simd_float3 target;
@property (nonatomic) simd_float3 upDirection;
@property (nonatomic) float fov; // radians
@property (nonatomic) float aspectRatio;
@property (nonatomic) float nearZ;
@property (nonatomic) float farZ;

@property (nonatomic, readonly) matrix_float4x4 viewMatrix;
@property (nonatomic, readonly) matrix_float4x4 projectionMatrix;

- (instancetype)initWithPosition:(simd_float3)position target:(simd_float3)target;
- (void)updateProjectionWithSize:(CGSize)size;
- (void)orbitWithDelta:(CGSize)delta;
- (void)zoomWithDelta:(CGFloat)delta;
- (void)panWithDelta:(CGSize)delta;

@end

NS_ASSUME_NONNULL_END
