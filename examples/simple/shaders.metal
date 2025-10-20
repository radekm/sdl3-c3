#include <metal_stdlib>
#include <metal_math>
#include <metal_texture>
using namespace metal;

#line 1 "examples/simple/shaders.slang"
struct pixelOutput_0
{
    float4 output_0 [[color(0)]];
};


#line 1
struct pixelInput_0
{
    float4 color_0 [[user(COLOR)]];
};


#line 25
[[fragment]] pixelOutput_0 fragmentMain(pixelInput_0 _S1 [[stage_in]], float4 position_0 [[position]])
{

#line 25
    pixelOutput_0 _S2 = { _S1.color_0 };

    return _S2;
}


#line 27
struct vertexMain_Result_0
{
    float4 position_1 [[position]];
    float4 color_1 [[user(COLOR)]];
};


#line 1
struct vertexInput_0
{
    float3 position_2 [[attribute(0)]];
    float4 color_2 [[attribute(1)]];
};

struct VertexOutput_0
{
    float4 position_3;
    float4 color_3;
};


#line 7
[[vertex]] vertexMain_Result_0 vertexMain(vertexInput_0 _S3 [[stage_in]])
{

#line 16
    thread VertexOutput_0 out_0;

    (&out_0)->position_3 = float4(_S3.position_2, 1.0);
    (&out_0)->color_3 = _S3.color_2;

#line 19
    thread vertexMain_Result_0 _S4;

#line 19
    (&_S4)->position_1 = out_0.position_3;

#line 19
    (&_S4)->color_1 = out_0.color_3;

#line 19
    return _S4;
}

