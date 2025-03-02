//
//  view_settings.metal
//  Aether-swift
//
//  Created by Allen on 2025/3/2.
//



struct _ubo_view_settings
{
    float4 u_exposure_tone_hdrEnable;
    float3 u_relativeTranslation;
};

inline bool HdrEnabled(constant _ubo_view_settings& ubo)
{
    return ubo.u_exposure_tone_hdrEnable[1] > 0.1;
}

inline float GetExposure(constant _ubo_view_settings& ubo)
{
    return ubo.u_exposure_tone_hdrEnable[0];
}


inline float3 GetCameraRelativePositionWS(float3 wpos, constant _ubo_view_settings& ubo)
{
    wpos -= ubo.u_relativeTranslation.xyz;
    return wpos;
}
