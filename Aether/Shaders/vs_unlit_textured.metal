//
//  vs_unlit_textured.metal
//  Aether-swift
//
//  Created by Allen on 2025/3/2.
//


#include <metal_stdlib>
using namespace metal;



struct _Global
{
#ifndef INSTANCES
    float4x4 u_model;
#endif
   
    float4x4 u_viewProj;
    float4 u_pointSize;
    
    // animation
    float4 u_numBones;
};

struct _vertex_in
{
    float3 a_position [[attribute(0)]];
    // DIFFUSE_MAP
    float2 a_texcoord0 [[attribute(2)]];

#ifdef INSTANCES
    float4 i_data0 [[attribute(3)]];
    float4 i_data1 [[attribute(4)]];
    float4 i_data2 [[attribute(5)]];
    float4 i_data3 [[attribute(6)]];
#endif
    // animation
    float4 a_indices [[attribute(8)]];
    float4 a_weight [[attribute(9)]];
};

struct _vertex_out
{
#if defined(DIFFUSE_MAP)
    float2 v_texcoord0  [[user(tc0)]];
#endif
#if defined(VIRTUAL_OCCLUSION_TOF)
    float3 v_vpos       [[user(vp)]];
#endif
    float4 gl_Position  [[position]];
    float gl_PointSize [[point_size]];
};


#include "viewSettings.metal"
#if defined(ANIMATION_MESH)
#include<bonesVertexDeclaration>
#endif
//
vertex _vertex_out xlatMtlMain_v(_vertex_in in [[stage_in]], constant _Global& _mtl_u [[buffer(0)]],
    constant _ubo_view_settings& ubo_viewSettings [[buffer(2)]]
#if defined(ANIMATION_MESH)
                               ,texture2d<float> s_texBoneMatrix
                               ,sampler s_texBoneMatrixSampler
#endif
                               )
{
    _vertex_out out = {};
    float4x4 animationTransform = float4x4(1.0);
    float4x4 modelMatrix;

#if defined(ANIMATION_MESH)
    animationTransform = computeBonesTransform(in, _mtl_u, s_texBoneMatrix, s_texBoneMatrixSampler);
#endif

#if defined(INSTANCES)
    modelMatrix = float4x4(in.i_data0, in.i_data1, in.i_data2, in.i_data3);
#else
    modelMatrix = _mtl_u.u_model;
#endif

    float4 wpos = modelMatrix * animationTransform * float4(in.a_position, 1.0);
    wpos /= wpos.w;

    wpos = float4(GetCameraRelativePositionWS(wpos.xyz, ubo_viewSettings), 1.0);

    out.gl_Position = _mtl_u.u_viewProj * wpos;

#if defined(BUMP_MAP) || defined(VIRTUAL_OCCLUSION_TOF)
    float4 vpos = _mtl_u.u_view * wpos;
    vpos /= vpos.w;
    out.v_vpos = vpos.xyz;
#endif
    out.gl_PointSize = _mtl_u.u_pointSize.x;

#if defined(DIFFUSE_MAP)
    out.v_texcoord0 = in.a_texcoord0;
#endif
    return out;
}



