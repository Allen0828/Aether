//
//  Basic.metal
//  testAether
//
//  Created by Allen on 2025/1/5.
//

#include <metal_stdlib>
using namespace metal;

constant float pi = 3.1415926535897932384626433832795;

struct VertexIn {
    float4 position [[attribute(0)]];
    float3 normal [[attribute(1)]];
    float2 uv [[attribute(2)]];
};
struct VertexOut {
    float4 position [[position]];
    float2 uv;
};
struct Uniforms {
    float4x4 modelMatrix;
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
};

typedef enum {
    DirectionalLight = 0,
    PointLight,
    SpotLight,
    SizeLight
} ELigheType;

typedef struct {
    simd_float3 position;
    ELigheType lightType;
    simd_float3 diffuse;
    simd_float3 specular;
    float specularScale;
} AELightStruct;

typedef struct {
  vector_float3 baseColor;
  vector_float3 specularColor;
  float roughness;
  float metallic;
  float ambientOcclusion;
  float shininess;
} Material;


struct _fragment_in
{
    float2 uv;
};

vertex VertexOut main_vertex(const VertexIn vertex_in [[stage_in]], constant Uniforms &uniforms [[buffer(1)]])
{
    VertexOut out;
    
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertex_in.position;
    out.uv = vertex_in.uv;
//    out.position = vertex_in.position;
    return out;
}


fragment float4 main_fragment(_fragment_in in [[stage_in]]
                              ,texture2d<float> baseColorTexture [[texture(1)]]
                              ,constant AELightStruct *lights [[buffer(11)]])
{
    
    if (!is_null_texture(baseColorTexture)) {
        constexpr sampler textureSampler(filter::linear, mip_filter::linear, max_anisotropy(8), address::repeat);
        float3 baseColor = baseColorTexture.sample(textureSampler, in.uv*1).rgb;
        
        AELightStruct light = lights[0];
        if (light.lightType == DirectionalLight)
        {
            float3 lightDirection = normalize(light.position);
            float3 F0 = baseColor;
            
            return float4(baseColor + light.specular, 1);
        }
        
        return float4(light.specular, 1);
        //return float4(baseColor*light.diffuse, 1);
    }
    
    return float4(1, 0, 0, 1);
    AELightStruct light = lights[0];
    float3 lightDirection = normalize(light.position);
    if (light.lightType == PointLight)
    {
        return float4(light.specular, 1);
    }
    return float4(1, 0, 0, 1);
}




float G1V(float nDotV, float k) {
  return 1.0f / (nDotV * (1.0f - k) + k);
}
// specular optimized-ggx
// AUTHOR John Hable. Released into the public domain
float3 computeSpecular(float3 normal, float3 viewDirection, float3 lightDirection, float roughness, float3 F0) {
  float alpha = roughness * roughness;
  float3 halfVector = normalize(viewDirection + lightDirection);
  float nDotL = saturate(dot(normal, lightDirection));
  float nDotV = saturate(dot(normal, viewDirection));
  float nDotH = saturate(dot(normal, halfVector));
  float lDotH = saturate(dot(lightDirection, halfVector));
  
  float3 F;
  float D, vis;
  
  // Distribution
  float alphaSqr = alpha * alpha;
  float pi = 3.14159f;
  float denom = nDotH * nDotH * (alphaSqr - 1.0) + 1.0f;
  D = alphaSqr / (pi * denom * denom);

  // Fresnel
  float lDotH5 = pow(1.0 - lDotH, 5);
  F = F0 + (1.0 - F0) * lDotH5;
  
  // V
  float k = alpha / 2.0f;
  vis = G1V(nDotL, k) * G1V(nDotV, k);
  
  float3 specular = nDotL * D * F * vis;
  return specular;
}

float3 computeDiffuse(Material material, float3 normal, float3 lightDirection) {
  float nDotL = saturate(dot(normal, lightDirection));
  float3 diffuse = float3(((1.0/pi) * material.baseColor) * (1.0 - material.metallic));
  diffuse = float3(material.baseColor) * (1.0 - material.metallic);
  return diffuse * nDotL * material.ambientOcclusion;
}








