//
//  Basic.metal
//  testAether
//
//  Created by Allen on 2025/1/5.
//

#include <metal_stdlib>
using namespace metal;


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

vertex VertexOut main_vertex(const VertexIn vertex_in [[stage_in]], constant Uniforms &uniforms [[buffer(1)]]) {
    VertexOut out;
    
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertex_in.position;
//    out.position = vertex_in.position;
    return out;
}


fragment float4 main_fragment() {
    return float4(1, 0, 0, 1);
}




