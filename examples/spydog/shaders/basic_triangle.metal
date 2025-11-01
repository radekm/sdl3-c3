#include <metal_stdlib>
#include <metal_math>
#include <metal_texture>
using namespace metal;

#line 6 "examples/spydog/shaders/basic_triangle.slang"
struct pixelOutput_0
{
    float4 output_0 [[color(0)]];
};


#line 6
struct pixelInput_0
{
    float4 color_0 [[user(TEXCOORD)]];
};


#line 39
[[fragment]] pixelOutput_0 fragmentMain(pixelInput_0 _S1 [[stage_in]])
{

#line 39
    pixelOutput_0 _S2 = { _S1.color_0 };

    return _S2;
}


#line 41
struct vertexMain_Result_0
{
    float4 color_1 [[user(TEXCOORD)]];
    float4 position_0 [[position]];
};


#line 6
struct VertexOutput_0
{
    float4 color_2;
    float4 position_1;
};


#line 16
[[vertex]] vertexMain_Result_0 vertexMain(uint vertexIndex_0 [[vertex_id]])
{

#line 15
    thread VertexOutput_0 out_0;

#line 15
    float2 pos_0;


    if(vertexIndex_0 == 0U)
    {
        float2 _S3 = float2(-1.0, -1.0);
        (&out_0)->color_2 = float4(1.0, 0.0, 0.0, 1.0);

#line 21
        pos_0 = _S3;

#line 18
    }
    else
    {


        if(vertexIndex_0 == 1U)
        {
            float2 _S4 = float2(1.0, -1.0);
            (&out_0)->color_2 = float4(0.0, 1.0, 0.0, 1.0);

#line 26
            pos_0 = _S4;

#line 23
        }
        else
        {


            if(vertexIndex_0 == 2U)
            {
                float2 _S5 = float2(0.0, 1.0);
                (&out_0)->color_2 = float4(0.0, 0.0, 1.0, 1.0);

#line 31
                pos_0 = _S5;

#line 28
            }

#line 23
        }

#line 18
    }

#line 34
    (&out_0)->position_1 = float4(pos_0, 0.0, 1.0);
    VertexOutput_0 _S6 = out_0;

#line 35
    thread vertexMain_Result_0 _S7;

#line 35
    (&_S7)->color_1 = _S6.color_2;

#line 35
    (&_S7)->position_0 = _S6.position_1;

#line 35
    return _S7;
}

