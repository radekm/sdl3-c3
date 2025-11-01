struct VertexInput
{
    uint vertexIndex : SV_VertexID;
};

struct VertexOutput
{
    float4	color : TEXCOORD0;
    float4	position : SV_Position;
};

[shader("vertex")]
VertexOutput vertexMain(VertexInput in)
{
    VertexOutput out;
    float2 pos;

    if (in.vertexIndex == 0)
    {
        pos = float2(-1, -1);
        out.color = float4(1, 0, 0, 1);
    }
    else if (in.vertexIndex == 1)
    {
        pos = float2(1, -1);
        out.color = float4(0, 1, 0, 1);
    }
    else if (in.vertexIndex == 2)
    {
        pos = float2(0, 1);
        out.color = float4(0, 0, 1, 1);
    }

    out.position = float4(pos, 0, 1);
    return out;
}

[shader("fragment")]
float4 fragmentMain(float4 color : TEXCOORD0) : SV_Target0
{
    return color;
}
