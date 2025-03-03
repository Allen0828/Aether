//
//  fs_unlit_textured.metal
//  Aether-swift
//
//  Created by Allen on 2025/3/2.
//

#include <metal_stdlib>
using namespace metal;

struct _Global
{
#if defined(DIFFUSE_MAP)
    float4 s_texColor_ST;
#endif
#if defined(VIRTUAL_OCCLUSION_TOF)
    float4 u_thresholdForTofViewportSize;
    float3x3 u_uvTransformMatrix;
#endif
    float4 u_tintColor;
};

struct _fragment_in
{
    float2 uv;
#if defined(DIFFUSE_MAP)
    float2 v_texcoord0  [[user(tc0)]];
#endif
#if defined(VIRTUAL_OCCLUSION_TOF)
    float3 v_vpos       [[user(vp)]];
#endif
};

struct _fragment_out
{
    float4 gl_FragColor0 [[color(0)]];
#ifdef OIT
    float4 gl_FragColor1 [[color(1)]];
#endif
};


#include "viewSettings.metal"
//#include "tonemapping.metal"


//// Transforms 2D UV by scale/bias property
//#define TRANSFORM_TEX(tex, name) (tex.xy * name.xy + name.zw)
//
fragment _fragment_out xlatMtlMain(_fragment_in in [[stage_in]], constant _Global& _mtl_u,
                                   constant _ubo_view_settings& ubo_viewSettings
                                   ,texture2d<float> baseColorTexture [[texture(1)]]
#ifdef DIFFUSE_MAP
                                   ,texture2d<float> s_texColor
                                   ,sampler s_texColorSampler
#endif
#ifdef VIRTUAL_OCCLUSION_TOF
                                   ,texture2d<float> s_tofMap
                                   ,sampler s_tofMapSampler
                                   ,texture2d<float> s_tofMaskMap
                                   ,sampler s_tofMaskMapSampler
                                   ,texture2d<float> s_cameraTexture
                                   ,sampler s_cameraTextureSampler
                                   ,float4 fragCoord [[position]]
#endif
                                   )
{
//#if defined(VIRTUAL_OCCLUSION_TOF)
//    float2 tsize = float2(s_tofMap.get_width(), s_tofMap.get_height());
//    float2 screenSpaceUV = GetTofTextureScreenUv(_mtl_u, fragCoord, tsize);
//    if (OccludedByTofFilter(s_tofMaskMap, s_tofMaskMapSampler, screenSpaceUV, _mtl_u))
//    {
//        discard_fragment();
//    }
//#endif
//
//    float4 outColor = _mtl_u.u_tintColor;
//  
//#if defined(DIFFUSE_MAP)
//    
//    float2 uv = in.v_texcoord0;
//    uv = TRANSFORM_TEX(uv, _mtl_u.s_texColor_ST);
//    outColor *= s_texColor.sample(s_texColorSampler, uv);
//#endif
//
//    if (!HdrEnabled(ubo_viewSettings))
//    { 
//        // for HDR pipeline
//        outColor.rgb = ACESFilm(outColor.rgb, GetExposure(ubo_viewSettings));
//    }
//
    _fragment_out out = {};
//    out.gl_FragColor0 = outColor;
//#ifdef OIT
//    out.gl_FragColor1 = float4(1.0);
//#endif
    if (!is_null_texture(baseColorTexture)) {
        constexpr sampler textureSampler(filter::linear, mip_filter::linear, max_anisotropy(8), address::repeat);
        float3 baseColor = baseColorTexture.sample(textureSampler, in.uv*1).rgb;
        out.gl_FragColor0 = float4(baseColor, 1);
    }
    else
    {
        out.gl_FragColor0 = float4(1,1,1,1);
    }
    return out;
}
