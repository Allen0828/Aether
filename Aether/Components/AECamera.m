//
//  AECamera.m
//  Aether
//
//  Created by Allen on 2024/12/31.
//

#import "AECamera.h"
#import "AEMath.h"




@implementation AECamera

- (instancetype)init {
    if (self=[super init]) {
        _aspectRatio = 1.0;
        _fov = degreesToRadians(70);
        _near = 0.1;
        _far = 500;
       
        
        _position = simd_make_float3(10, 6, -6);
        _target = simd_make_float3(0, 0, 0);
        _upDirection = simd_make_float3(0, 1, 0);
        
//        self.cameraControl = true;
        
        [self updateViewMatrix];
        [self updateProjectionMatrix];
    }
    return self;
}

- (instancetype)initWithPosition:(simd_float3)position target:(simd_float3)target upDirection:(simd_float3)upDirection {
    return [self init];
}

//- (instancetype)initWithPosition:(simd_float3)position
//                           target:(simd_float3)target
//                       upDirection:(simd_float3)upDirection {
//    self = [super init];
//    if (self) {
//        _position = position;
//        _target = target;
//        _upDirection = upDirection;
//        _fov = 60.0; // Default field of view
//        _aspectRatio = 1.0; // Default aspect ratio
//        _nearPlane = 0.1;
//        _farPlane = 100.0;
//        
//    }
//    return self;
//}

- (void)updateViewMatrix {
    // Calculate the view matrix based on the camera's position, target, and up direction
    _viewMatrix = matrix_look_at_right_hand(self.position, self.target, self.upDirection);
    // Store the view matrix
}

- (void)updateProjectionMatrix {
    // Calculate the projection matrix based on the projection mode
    if (self.projectionMode == Perspective) {
        _projectionMatrix = matrix_perspective_right_hand(self.fov, self.aspectRatio, self.near, self.far);
    } else {
        // Orthographic projection
        CGFloat orthoScale = 1.0; // Default orthographic scale
        _projectionMatrix = matrix_orthographic_right_hand(-orthoScale * self.aspectRatio, orthoScale * self.aspectRatio, -orthoScale, orthoScale, self.near, self.far);
    }
}

- (matrix_float4x4)getViewMatrix {
    return _viewMatrix;
}

- (matrix_float4x4)getProjectionMatrix {
    return _projectionMatrix;
}



@end
