//
//  tonemapping.metal
//  Aether-swift
//
//  Created by Allen on 2025/3/2.
//

#include <metal_stdlib>


// Photographic
float3 photographic(float3 color, float exposure)
{
    return float3(1.0) - metal::exp2(-exposure * color);
}

// Reinhard
float luminance(float3 c)
{
    return metal::dot(c, float3(0.22, 0.707, 0.071));
}

float3 reinhard(float3 color, float exposure)
{
    float lum = luminance(color.rgb);
    float lumTm = lum * exposure;
    float scale = lumTm / (1.0 + lumTm);

    return color * scale / (lum + 0.00001);
}

// Simple filmic
float3 hejidawson(float3 color, float exposure)
{
    float3 finalColor = metal::min(color, 50. / exposure) * exposure;
    float3 x = metal::max(float3(0.), finalColor - float3(0.004));
 finalColor = (x * (6.2 * x + .49)) / (x * (6.175 * x + 1.7) + 0.06);

 return finalColor;
}

// https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve/
float3 ACESFilm(float3 color, float exposure)
{
    float3 x = color * exposure;
    float a = 2.51f;
    float b = 0.03f;
    float c = 2.43f;
    float d = 0.59f;
    float e = 0.14f;
    return metal::clamp((x*(a*x+b))/(x*(c*x+d)+e), float3(0.0), float3(1.0));
}

// https://www.shadertoy.com/view/wlfyWr
float3 inv_ACESFilm(float3 x, float exposure) {
    // Narkowicz 2015, "ACES Filmic Tone Mapping Curve"
    float3 result = (-0.59 * x + 0.03 - metal::sqrt(-1.0127 * x*x + 1.3702 * x + 0.0009)) / (2.0 * (2.43*x - 2.51));
    if (exposure > 0.1)
    {
        result /= exposure;
    }

    return result;
}
