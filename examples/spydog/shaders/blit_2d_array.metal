#include <metal_stdlib>
#include <metal_math>
#include <metal_texture>
using namespace metal;

#line 90 "core"
struct pixelOutput_0
{
    float4 output_0 [[color(0)]];
};


#line 2305 "core.meta.slang"
struct pixelInput_0
{
    float2 tex_coord_0 [[user(TEXCOORD)]];
};


#line 2305
struct KernelContext_0
{
    texture2d_array<float, access::sample> texture_0;
    sampler sampler_0;
};


#line 28 "examples/spydog/shaders/blit_2d_array.slang"
[[fragment]] pixelOutput_0 fragmentMain(pixelInput_0 _S1 [[stage_in]], texture2d_array<float, access::sample> texture_1 [[texture(0)]], sampler sampler_1 [[sampler(0)]])
{

#line 28
    KernelContext_0 kernelContext_0;

#line 28
    (&kernelContext_0)->texture_0 = texture_1;

#line 28
    (&kernelContext_0)->sampler_0 = sampler_1;


    float3 _S2 = float3(_S1.tex_coord_0, float(uint(int((_S1.tex_coord_0.y) > 0.5))));

#line 31
    pixelOutput_0 _S3 = { (((&kernelContext_0)->texture_0).sample((sampler_1), ((_S2)).xy, uint(((_S2)).z))) };

#line 31
    return _S3;
}


#line 31
struct vertexMain_Result_0
{
    float2 tex_coord_1 [[user(TEXCOORD)]];
    float4 position_0 [[position]];
};


#line 31
struct vertexInput_0
{
    float3 position_1 [[attribute(0)]];
    float2 tex_coord_2 [[attribute(1)]];
};


#line 7
struct VertexOutput_0
{
    float2 tex_coord_3;
    float4 position_2;
};


#line 7
[[vertex]] vertexMain_Result_0 vertexMain(vertexInput_0 _S4 [[stage_in]], texture2d_array<float, access::sample> texture_2 [[texture(0)]], sampler sampler_2 [[sampler(0)]])
{

#line 7
    KernelContext_0 kernelContext_1;

#line 7
    (&kernelContext_1)->texture_0 = texture_2;

#line 7
    (&kernelContext_1)->sampler_0 = sampler_2;

#line 16
    thread VertexOutput_0 out_0;

    (&out_0)->tex_coord_3 = _S4.tex_coord_2;
    (&out_0)->position_2 = float4(_S4.position_1, 1.0);

#line 19
    thread vertexMain_Result_0 _S5;

#line 19
    (&_S5)->tex_coord_1 = out_0.tex_coord_3;

#line 19
    (&_S5)->position_0 = out_0.position_2;

#line 19
    return _S5;
}

