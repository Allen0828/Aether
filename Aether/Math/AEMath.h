//
//  AEMath.h
//  testAether
//
//  Created by Allen on 2025/1/9.
//

#import <Foundation/Foundation.h>
#import <simd/simd.h>


#define radiansToDegrees(radians) ((radians / M_PI) * 180.0)
#define degreesToRadians(degrees) ((degrees / 180.0) * M_PI)

simd_float4x4 matrix_look_at_right_hand(simd_float3 eye, simd_float3 target, simd_float3 up);
simd_float4x4 matrix_perspective_right_hand(float fov, float aspectRatio, float near, float far);
simd_float4x4 matrix_orthographic_right_hand(float left, float right, float bottom, float top, float near, float far);


simd_float4x4 Translation_float4x4(simd_float3 pos);
simd_float4x4 Translation(float x, float y, float z);

simd_float4x4 Rotation_float4x4(simd_float3 rot);
simd_float4x4 rotation(float angle_x, float angle_y, float angle_z);

simd_float4x4 Scale_float4x4(simd_float3 scale);
simd_float4x4 scaling(float x, float y, float z);


simd_float3x3 getUpperLeft(simd_float4x4 matrix);
simd_float3x3 normalFrom4x4(simd_float4x4 matrix);
simd_float4x4 identity(void);


simd_float4x4 rotationMatrix_x(float angle);
simd_float4x4 rotationMatrix_z(float angle);
simd_float4x4 rotationMatrix_y(float angle);
simd_float4x4 rotation(float angle_x, float angle_y, float angle_z);
simd_float4x4 rotationYXZ(float angle_x, float angle_y, float angle_z);


simd_float4x4 projectionMatrix(float fov, float near, float far, float aspect);
simd_float4x4 leftHandedLook(simd_float3 eye, simd_float3 center, simd_float3 up);
simd_float4x4 orthographic(CGRect rect, float near, float far);


