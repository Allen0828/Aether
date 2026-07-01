//
//  AECamera.m
//  Aether
//

#import "AECamera.h"
#import "../Math/AEMath.h"

@interface AECamera ()
- (void)_updateMatrices;

@property (nonatomic, readwrite) matrix_float4x4 viewMatrix;
@property (nonatomic, readwrite) matrix_float4x4 projectionMatrix;
@end

@implementation AECamera

- (instancetype)init {
    return [self initWithPosition:simd_make_float3(3, 2, 5) target:simd_make_float3(0, 0, 0)];
}

- (instancetype)initWithPosition:(simd_float3)position target:(simd_float3)target {
    if (self = [super init]) {
        _position = position;
        _target = target;
        _upDirection = simd_make_float3(0, 1, 0);
        _fov = 70.0 * M_PI / 180.0;
        _aspectRatio = 1.0;
        _nearZ = 0.1;
        _farZ = 500.0;
        [self _updateMatrices];
    }
    return self;
}

- (void)updateProjectionWithSize:(CGSize)size {
    self.aspectRatio = (size.height > 0) ? (size.width / size.height) : 1.0;
    [self _updateMatrices];
}

- (void)orbitWithDelta:(CGSize)delta {
    simd_float3 dir = simd_normalize(self.target - self.position);
    double radius = simd_length(self.target - self.position);
    double theta = atan2(dir.z, dir.x) + delta.width * 0.005;
    double phi = asin(dir.y) + delta.height * 0.005;
    phi = fmax(-M_PI_2 + 0.01, fmin(M_PI_2 - 0.01, phi));
    self.position = self.target + simd_make_float3(
        radius * cos(phi) * cos(theta),
        radius * sin(phi),
        radius * cos(phi) * sin(theta)
    );
    [self _updateMatrices];
}

- (void)zoomWithDelta:(CGFloat)delta {
    simd_float3 dir = simd_normalize(self.target - self.position);
    double dist = simd_length(self.target - self.position);
    dist = fmax(0.5, fmin(200.0, dist * (1.0 + delta * 0.01)));
    self.position = self.target - dir * dist;
    [self _updateMatrices];
}

- (void)panWithDelta:(CGSize)delta {
    simd_float3 dir = simd_normalize(self.target - self.position);
    simd_float3 right = simd_normalize(simd_cross(dir, self.upDirection));
    simd_float3 up = simd_normalize(simd_cross(right, dir));
    float speed = simd_length(self.target - self.position) * 0.002;
    simd_float3 offset = right * delta.width * speed + up * delta.height * speed;
    self.position += offset;
    self.target += offset;
    [self _updateMatrices];
}

- (void)_updateMatrices {
    _viewMatrix = matrix_look_at_right_hand(self.position, self.target, self.upDirection);
    _projectionMatrix = matrix_perspective_right_hand_metal(self.fov, self.aspectRatio, self.nearZ, self.farZ);
}

@end
