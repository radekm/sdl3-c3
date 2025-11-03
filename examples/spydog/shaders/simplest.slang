struct VertexInput
{
    float3 position : POSITION;
    float4 color : COLOR;
};

struct VertexOutput
{
    float4 position : SV_Position;
    float4 color : COLOR;
};

[shader("vertex")]
VertexOutput vertexMain(VertexInput in)
{
    VertexOutput out;

    out.position = float4(in.position, 1);
    out.color = in.color;

    return out;
}

[shader("fragment")]
float4 fragmentMain(VertexOutput in) : SV_Target
{
    return in.color;
}
