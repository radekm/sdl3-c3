struct VertexInput
{
    float3 position : TEXCOORD0;
    float2 tex_coord : TEXCOORD1;
};

struct VertexOutput
{
    float2 tex_coord : TEXCOORD0;
    float4 position : SV_Position;
};

[shader("vertex")]
VertexOutput vertexMain(VertexInput in)
{
    VertexOutput out;

    out.tex_coord = in.tex_coord;
    out.position = float4(in.position, 1);

    return out;
}

Texture2DArray<float4> texture;
SamplerState sampler;

[shader("fragment")]
float4 fragmentMain(float2 tex_coord : TEXCOORD0) : SV_Target
{
    uint array_index = uint(int(tex_coord.y > 0.5f));
    return texture.Sample(sampler, float3(tex_coord, float(array_index)));
}
