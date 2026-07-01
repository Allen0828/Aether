//
//  Basic.metal
//  Aether
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position [[attribute(0)]];
    float3 normal   [[attribute(1)]];
    float2 uv       [[attribute(2)]];
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

vertex VertexOut main_vertex(const VertexIn vertex_in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(0)]])
{
    VertexOut out;
    float4 pos4 = float4(vertex_in.position, 1.0);
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * pos4;
    out.uv = vertex_in.uv;
    return out;
}

fragment float4 main_fragment(VertexOut in [[stage_in]],
                              texture2d<float> baseColorTexture [[texture(1)]])
{
    if (!is_null_texture(baseColorTexture)) {
        constexpr sampler s(filter::linear);
        float3 color = baseColorTexture.sample(s, in.uv).rgb;
        return float4(color, 1.0);
    }
    return float4(1.0, 0.5, 0.3, 1.0); // warm orange fallback
}
