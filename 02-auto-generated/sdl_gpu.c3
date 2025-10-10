module sdl;

/* WIKI CATEGORY: GPU */


::LINE:: #ifndef SDL_gpu_h_
::LINE:: #define SDL_gpu_h_


::LINE:: #ifdef __cplusplus
::LINE:: extern "C" {
::LINE:: #endif /* __cplusplus */

/* Type Declarations */














enum SDL_GPUPrimitiveType : const CInt
{
    TRIANGLELIST,  /**< A series of separate triangles. */
    TRIANGLESTRIP, /**< A series of connected triangles. */
    LINELIST,      /**< A series of separate lines. */
    LINESTRIP,     /**< A series of connected lines. */
    POINTLIST      /**< A series of separate points. */
}

enum SDL_GPULoadOp : const CInt
{
    LOAD,      /**< The previous contents of the texture will be preserved. */
    CLEAR,     /**< The contents of the texture will be cleared to a color. */
    DONT_CARE  /**< The previous contents of the texture need not be preserved. The contents will be undefined. */
}

enum SDL_GPUStoreOp : const CInt
{
    STORE,             /**< The contents generated during the render pass will be written to memory. */
    DONT_CARE,         /**< The contents generated during the render pass are not needed and may be discarded. The contents will be undefined. */
    RESOLVE,           /**< The multisample contents generated during the render pass will be resolved to a non-multisample texture. The contents in the multisample texture may then be discarded and will be undefined. */
    RESOLVE_AND_STORE  /**< The multisample contents generated during the render pass will be resolved to a non-multisample texture. The contents in the multisample texture will be written to memory. */
}

enum SDL_GPUIndexElementSize : const CInt
{
    16BIT, /**< The index elements are 16-bit. */
    32BIT  /**< The index elements are 32-bit. */
}

enum SDL_GPUTextureFormat : const CInt
{
    INVALID,

    /* Unsigned Normalized Float Color Formats */
    A8_UNORM,
    R8_UNORM,
    R8G8_UNORM,
    R8G8B8A8_UNORM,
    R16_UNORM,
    R16G16_UNORM,
    R16G16B16A16_UNORM,
    R10G10B10A2_UNORM,
    B5G6R5_UNORM,
    B5G5R5A1_UNORM,
    B4G4R4A4_UNORM,
    B8G8R8A8_UNORM,
    /* Compressed Unsigned Normalized Float Color Formats */
    BC1_RGBA_UNORM,
    BC2_RGBA_UNORM,
    BC3_RGBA_UNORM,
    BC4_R_UNORM,
    BC5_RG_UNORM,
    BC7_RGBA_UNORM,
    /* Compressed Signed Float Color Formats */
    BC6H_RGB_FLOAT,
    /* Compressed Unsigned Float Color Formats */
    BC6H_RGB_UFLOAT,
    /* Signed Normalized Float Color Formats  */
    R8_SNORM,
    R8G8_SNORM,
    R8G8B8A8_SNORM,
    R16_SNORM,
    R16G16_SNORM,
    R16G16B16A16_SNORM,
    /* Signed Float Color Formats */
    R16_FLOAT,
    R16G16_FLOAT,
    R16G16B16A16_FLOAT,
    R32_FLOAT,
    R32G32_FLOAT,
    R32G32B32A32_FLOAT,
    /* Unsigned Float Color Formats */
    R11G11B10_UFLOAT,
    /* Unsigned Integer Color Formats */
    R8_UINT,
    R8G8_UINT,
    R8G8B8A8_UINT,
    R16_UINT,
    R16G16_UINT,
    R16G16B16A16_UINT,
    R32_UINT,
    R32G32_UINT,
    R32G32B32A32_UINT,
    /* Signed Integer Color Formats */
    R8_INT,
    R8G8_INT,
    R8G8B8A8_INT,
    R16_INT,
    R16G16_INT,
    R16G16B16A16_INT,
    R32_INT,
    R32G32_INT,
    R32G32B32A32_INT,
    /* SRGB Unsigned Normalized Color Formats */
    R8G8B8A8_UNORM_SRGB,
    B8G8R8A8_UNORM_SRGB,
    /* Compressed SRGB Unsigned Normalized Color Formats */
    BC1_RGBA_UNORM_SRGB,
    BC2_RGBA_UNORM_SRGB,
    BC3_RGBA_UNORM_SRGB,
    BC7_RGBA_UNORM_SRGB,
    /* Depth Formats */
    D16_UNORM,
    D24_UNORM,
    D32_FLOAT,
    D24_UNORM_S8_UINT,
    D32_FLOAT_S8_UINT,
    /* Compressed ASTC Normalized Float Color Formats*/
    ASTC_4x4_UNORM,
    ASTC_5x4_UNORM,
    ASTC_5x5_UNORM,
    ASTC_6x5_UNORM,
    ASTC_6x6_UNORM,
    ASTC_8x5_UNORM,
    ASTC_8x6_UNORM,
    ASTC_8x8_UNORM,
    ASTC_10x5_UNORM,
    ASTC_10x6_UNORM,
    ASTC_10x8_UNORM,
    ASTC_10x10_UNORM,
    ASTC_12x10_UNORM,
    ASTC_12x12_UNORM,
    /* Compressed SRGB ASTC Normalized Float Color Formats*/
    ASTC_4x4_UNORM_SRGB,
    ASTC_5x4_UNORM_SRGB,
    ASTC_5x5_UNORM_SRGB,
    ASTC_6x5_UNORM_SRGB,
    ASTC_6x6_UNORM_SRGB,
    ASTC_8x5_UNORM_SRGB,
    ASTC_8x6_UNORM_SRGB,
    ASTC_8x8_UNORM_SRGB,
    ASTC_10x5_UNORM_SRGB,
    ASTC_10x6_UNORM_SRGB,
    ASTC_10x8_UNORM_SRGB,
    ASTC_10x10_UNORM_SRGB,
    ASTC_12x10_UNORM_SRGB,
    ASTC_12x12_UNORM_SRGB,
    /* Compressed ASTC Signed Float Color Formats*/
    ASTC_4x4_FLOAT,
    ASTC_5x4_FLOAT,
    ASTC_5x5_FLOAT,
    ASTC_6x5_FLOAT,
    ASTC_6x6_FLOAT,
    ASTC_8x5_FLOAT,
    ASTC_8x6_FLOAT,
    ASTC_8x8_FLOAT,
    ASTC_10x5_FLOAT,
    ASTC_10x6_FLOAT,
    ASTC_10x8_FLOAT,
    ASTC_10x10_FLOAT,
    ASTC_12x10_FLOAT,
    ASTC_12x12_FLOAT
}

enum SDL_GPUTextureUsageFlags : const uint
{
    SAMPLER                                  = 1u << 0, /**< Texture supports sampling. */
    COLOR_TARGET                             = 1u << 1, /**< Texture is a color render target. */
    DEPTH_STENCIL_TARGET                     = 1u << 2, /**< Texture is a depth stencil target. */
    GRAPHICS_STORAGE_READ                    = 1u << 3, /**< Texture supports storage reads in graphics stages. */
    COMPUTE_STORAGE_READ                     = 1u << 4, /**< Texture supports storage reads in the compute stage. */
    COMPUTE_STORAGE_WRITE                    = 1u << 5, /**< Texture supports storage writes in the compute stage. */
    COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE  = 1u << 6, /**< Texture supports reads and writes in the same compute shader. This is NOT equivalent to READ | WRITE. */
}

enum SDL_GPUTextureType : const CInt
{
    2D,         /**< The texture is a 2-dimensional image. */
    2D_ARRAY,   /**< The texture is a 2-dimensional array image. */
    3D,         /**< The texture is a 3-dimensional image. */
    CUBE,       /**< The texture is a cube image. */
    CUBE_ARRAY  /**< The texture is a cube array image. */
}

enum SDL_GPUSampleCount : const CInt
{
    1,  /**< No multisampling. */
    2,  /**< MSAA 2x */
    4,  /**< MSAA 4x */
    8   /**< MSAA 8x */
}


enum SDL_GPUCubeMapFace : const CInt
{
    POSITIVEX,
    NEGATIVEX,
    POSITIVEY,
    NEGATIVEY,
    POSITIVEZ,
    NEGATIVEZ
}

enum SDL_GPUBufferUsageFlags : const uint
{
    VERTEX                                   = 1u << 0, /**< Buffer is a vertex buffer. */
    INDEX                                    = 1u << 1, /**< Buffer is an index buffer. */
    INDIRECT                                 = 1u << 2, /**< Buffer is an indirect buffer. */
    GRAPHICS_STORAGE_READ                    = 1u << 3, /**< Buffer supports storage reads in graphics stages. */
    COMPUTE_STORAGE_READ                     = 1u << 4, /**< Buffer supports storage reads in the compute stage. */
    COMPUTE_STORAGE_WRITE                    = 1u << 5, /**< Buffer supports storage writes in the compute stage. */
}

enum SDL_GPUTransferBufferUsage : const CInt
{
    UPLOAD,
    DOWNLOAD
}

enum SDL_GPUShaderStage : const CInt
{
    VERTEX,
    FRAGMENT
}

enum SDL_GPUShaderFormat : const uint
{
    INVALID   = 0,
    PRIVATE   = 1u << 0, /**< Shaders for NDA'd platforms. */
    SPIRV     = 1u << 1, /**< SPIR-V shaders for Vulkan. */
    DXBC      = 1u << 2, /**< DXBC SM5_1 shaders for D3D12. */
    DXIL      = 1u << 3, /**< DXIL SM6_0 shaders for D3D12. */
    MSL       = 1u << 4, /**< MSL shaders for Metal. */
    METALLIB  = 1u << 5, /**< Precompiled metallib shaders for Metal. */
}

enum SDL_GPUVertexElementFormat : const CInt
{
    INVALID,

    /* 32-bit Signed Integers */
    INT,
    INT2,
    INT3,
    INT4,

    /* 32-bit Unsigned Integers */
    UINT,
    UINT2,
    UINT3,
    UINT4,

    /* 32-bit Floats */
    FLOAT,
    FLOAT2,
    FLOAT3,
    FLOAT4,

    /* 8-bit Signed Integers */
    BYTE2,
    BYTE4,

    /* 8-bit Unsigned Integers */
    UBYTE2,
    UBYTE4,

    /* 8-bit Signed Normalized */
    BYTE2_NORM,
    BYTE4_NORM,

    /* 8-bit Unsigned Normalized */
    UBYTE2_NORM,
    UBYTE4_NORM,

    /* 16-bit Signed Integers */
    SHORT2,
    SHORT4,

    /* 16-bit Unsigned Integers */
    USHORT2,
    USHORT4,

    /* 16-bit Signed Normalized */
    SHORT2_NORM,
    SHORT4_NORM,

    /* 16-bit Unsigned Normalized */
    USHORT2_NORM,
    USHORT4_NORM,

    /* 16-bit Floats */
    HALF2,
    HALF4
}

enum SDL_GPUVertexInputRate : const CInt
{
    VERTEX,   /**< Attribute addressing is a function of the vertex index. */
    INSTANCE  /**< Attribute addressing is a function of the instance index. */
}

enum SDL_GPUFillMode : const CInt
{
    FILL,  /**< Polygons will be rendered via rasterization. */
    LINE   /**< Polygon edges will be drawn as line segments. */
}

enum SDL_GPUCullMode : const CInt
{
    NONE,   /**< No triangles are culled. */
    FRONT,  /**< Front-facing triangles are culled. */
    BACK    /**< Back-facing triangles are culled. */
}

enum SDL_GPUFrontFace : const CInt
{
    OUNTER_CLOCKWISE,  /**< A triangle with counter-clockwise vertex winding will be considered front-facing. */
    LOCKWISE           /**< A triangle with clockwise vertex winding will be considered front-facing. */
}

enum SDL_GPUCompareOp : const CInt
{
    INVALID,
    NEVER,             /**< The comparison always evaluates false. */
    LESS,              /**< The comparison evaluates reference < test. */
    EQUAL,             /**< The comparison evaluates reference == test. */
    LESS_OR_EQUAL,     /**< The comparison evaluates reference <= test. */
    GREATER,           /**< The comparison evaluates reference > test. */
    NOT_EQUAL,         /**< The comparison evaluates reference != test. */
    GREATER_OR_EQUAL,  /**< The comparison evaluates reference >= test. */
    ALWAYS             /**< The comparison always evaluates true. */
}

enum SDL_GPUStencilOp : const CInt
{
    INVALID,
    KEEP,                 /**< Keeps the current value. */
    ZERO,                 /**< Sets the value to 0. */
    REPLACE,              /**< Sets the value to reference. */
    INCREMENT_AND_CLAMP,  /**< Increments the current value and clamps to the maximum value. */
    DECREMENT_AND_CLAMP,  /**< Decrements the current value and clamps to 0. */
    INVERT,               /**< Bitwise-inverts the current value. */
    INCREMENT_AND_WRAP,   /**< Increments the current value and wraps back to 0. */
    DECREMENT_AND_WRAP    /**< Decrements the current value and wraps to the maximum value. */
}

enum SDL_GPUBlendOp : const CInt
{
    INVALID,
    ADD,               /**< (source * source_factor) + (destination * destination_factor) */
    SUBTRACT,          /**< (source * source_factor) - (destination * destination_factor) */
    REVERSE_SUBTRACT,  /**< (destination * destination_factor) - (source * source_factor) */
    MIN,               /**< min(source, destination) */
    MAX                /**< max(source, destination) */
}

enum SDL_GPUBlendFactor : const CInt
{
    INVALID,
    ZERO,                      /**< 0 */
    ONE,                       /**< 1 */
    SRC_COLOR,                 /**< source color */
    ONE_MINUS_SRC_COLOR,       /**< 1 - source color */
    DST_COLOR,                 /**< destination color */
    ONE_MINUS_DST_COLOR,       /**< 1 - destination color */
    SRC_ALPHA,                 /**< source alpha */
    ONE_MINUS_SRC_ALPHA,       /**< 1 - source alpha */
    DST_ALPHA,                 /**< destination alpha */
    ONE_MINUS_DST_ALPHA,       /**< 1 - destination alpha */
    CONSTANT_COLOR,            /**< blend constant */
    ONE_MINUS_CONSTANT_COLOR,  /**< 1 - blend constant */
    SRC_ALPHA_SATURATE         /**< min(source alpha, 1 - destination alpha) */
}

enum SDL_GPUColorComponentFlags : const char
{
    R  = 1u << 0, /**< the red component */
    G  = 1u << 1, /**< the green component */
    B  = 1u << 2, /**< the blue component */
    A  = 1u << 3, /**< the alpha component */
}

enum SDL_GPUFilter : const CInt
{
    NEAREST,  /**< Point filtering. */
    LINEAR    /**< Linear filtering. */
}

enum SDL_GPUSamplerMipmapMode : const CInt
{
    NEAREST,  /**< Point filtering. */
    LINEAR    /**< Linear filtering. */
}

enum SDL_GPUSamplerAddressMode : const CInt
{
    REPEAT,           /**< Specifies that the coordinates will wrap around. */
    MIRRORED_REPEAT,  /**< Specifies that the coordinates will wrap around mirrored. */
    CLAMP_TO_EDGE     /**< Specifies that the coordinates will clamp to the 0-1 range. */
}

enum SDL_GPUPresentMode : const CInt
{
    VSYNC,
    IMMEDIATE,
    MAILBOX
}

enum SDL_GPUSwapchainComposition : const CInt
{
    SDR,
    SDR_LINEAR,
    HDR_EXTENDED_LINEAR,
    HDR10_ST2084
}

/* Structures */

struct SDL_GPUViewport
{
    float x;          /**< The left offset of the viewport. */
    float y;          /**< The top offset of the viewport. */
    float w;          /**< The width of the viewport. */
    float h;          /**< The height of the viewport. */
    float min_depth;  /**< The minimum depth of the viewport. */
    float max_depth;  /**< The maximum depth of the viewport. */
}

struct SDL_GPUTextureTransferInfo
{
    SDL_GPUTransferBuffer* transfer_buffer;  /**< The transfer buffer used in the transfer operation. */
    uint offset;                             /**< The starting byte of the image data in the transfer buffer. */
    uint pixels_per_row;                     /**< The number of pixels from one row to the next. */
    uint rows_per_layer;                     /**< The number of rows from one layer/depth-slice to the next. */
}

struct SDL_GPUTransferBufferLocation
{
    SDL_GPUTransferBuffer* transfer_buffer;  /**< The transfer buffer used in the transfer operation. */
    uint offset;                             /**< The starting byte of the buffer data in the transfer buffer. */
}

struct SDL_GPUTextureLocation
{
    SDL_GPUTexture* texture;  /**< The texture used in the copy operation. */
    uint mip_level;           /**< The mip level index of the location. */
    uint layer;               /**< The layer index of the location. */
    uint x;                   /**< The left offset of the location. */
    uint y;                   /**< The top offset of the location. */
    uint z;                   /**< The front offset of the location. */
}

struct SDL_GPUTextureRegion
{
    SDL_GPUTexture* texture;  /**< The texture used in the copy operation. */
    uint mip_level;           /**< The mip level index to transfer. */
    uint layer;               /**< The layer index to transfer. */
    uint x;                   /**< The left offset of the region. */
    uint y;                   /**< The top offset of the region. */
    uint z;                   /**< The front offset of the region. */
    uint w;                   /**< The width of the region. */
    uint h;                   /**< The height of the region. */
    uint d;                   /**< The depth of the region. */
}

struct SDL_GPUBlitRegion
{
    SDL_GPUTexture* texture;      /**< The texture. */
    uint mip_level;               /**< The mip level index of the region. */
    uint layer_or_depth_plane;    /**< The layer index or depth plane of the region. This value is treated as a layer index on 2D array and cube textures, and as a depth plane on 3D textures. */
    uint x;                       /**< The left offset of the region. */
    uint y;                       /**< The top offset of the region.  */
    uint w;                       /**< The width of the region. */
    uint h;                       /**< The height of the region. */
}

struct SDL_GPUBufferLocation
{
    SDL_GPUBuffer* buffer;  /**< The buffer. */
    uint offset;            /**< The starting byte within the buffer. */
}

struct SDL_GPUBufferRegion
{
    SDL_GPUBuffer* buffer;  /**< The buffer. */
    uint offset;            /**< The starting byte within the buffer. */
    uint size;              /**< The size in bytes of the region. */
}

struct SDL_GPUIndirectDrawCommand
{
    uint num_vertices;     /**< The number of vertices to draw. */
    uint num_instances;    /**< The number of instances to draw. */
    uint first_vertex;     /**< The index of the first vertex to draw. */
    uint first_instance;   /**< The ID of the first instance to draw. */
}

struct SDL_GPUIndexedIndirectDrawCommand
{
    uint num_indices;      /**< The number of indices to draw per instance. */
    uint num_instances;    /**< The number of instances to draw. */
    uint first_index;      /**< The base index within the index buffer. */
    int vertex_offset;     /**< The value added to the vertex index before indexing into the vertex buffer. */
    uint first_instance;   /**< The ID of the first instance to draw. */
}

struct SDL_GPUIndirectDispatchCommand
{
    uint groupcount_x;    /**< The number of local workgroups to dispatch in the X dimension. */
    uint groupcount_y;    /**< The number of local workgroups to dispatch in the Y dimension. */
    uint groupcount_z;    /**< The number of local workgroups to dispatch in the Z dimension. */
}

/* State structures */

struct SDL_GPUSamplerCreateInfo
{
    SDL_GPUFilter min_filter;                  /**< The minification filter to apply to lookups. */
    SDL_GPUFilter mag_filter;                  /**< The magnification filter to apply to lookups. */
    SDL_GPUSamplerMipmapMode mipmap_mode;      /**< The mipmap filter to apply to lookups. */
    SDL_GPUSamplerAddressMode address_mode_u;  /**< The addressing mode for U coordinates outside [0, 1). */
    SDL_GPUSamplerAddressMode address_mode_v;  /**< The addressing mode for V coordinates outside [0, 1). */
    SDL_GPUSamplerAddressMode address_mode_w;  /**< The addressing mode for W coordinates outside [0, 1). */
    float mip_lod_bias;                        /**< The bias to be added to mipmap LOD calculation. */
    float max_anisotropy;                      /**< The anisotropy value clamp used by the sampler. If enable_anisotropy is false, this is ignored. */
    SDL_GPUCompareOp compare_op;               /**< The comparison operator to apply to fetched data before filtering. */
    float min_lod;                             /**< Clamps the minimum of the computed LOD value. */
    float max_lod;                             /**< Clamps the maximum of the computed LOD value. */
    bool enable_anisotropy;                    /**< true to enable anisotropic filtering. */
    bool enable_compare;                       /**< true to enable comparison against a reference value during lookups. */
    char padding1;
    char padding2;

    SDL_PropertiesID props;                    /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
}

struct SDL_GPUVertexBufferDescription
{
    uint slot;                          /**< The binding slot of the vertex buffer. */
    uint pitch;                         /**< The size of a single element + the offset between elements. */
    SDL_GPUVertexInputRate input_rate;  /**< Whether attribute addressing is a function of the vertex index or instance index. */
    uint instance_step_rate;            /**< Reserved for future use. Must be set to 0. */
}

struct SDL_GPUVertexAttribute
{
    uint location;                      /**< The shader input location index. */
    uint buffer_slot;                   /**< The binding slot of the associated vertex buffer. */
    SDL_GPUVertexElementFormat format;  /**< The size and type of the attribute data. */
    uint offset;                        /**< The byte offset of this attribute relative to the start of the vertex element. */
}

struct SDL_GPUVertexInputState
{
    SDL_GPUVertexBufferDescription* vertex_buffer_descriptions;       /**< A pointer to an array of vertex buffer descriptions. */
    uint num_vertex_buffers;                                          /**< The number of vertex buffer descriptions in the above array. */
    SDL_GPUVertexAttribute* vertex_attributes;                        /**< A pointer to an array of vertex attribute descriptions. */
    uint num_vertex_attributes;                                       /**< The number of vertex attribute descriptions in the above array. */
}

struct SDL_GPUStencilOpState
{
    SDL_GPUStencilOp fail_op;        /**< The action performed on samples that fail the stencil test. */
    SDL_GPUStencilOp pass_op;        /**< The action performed on samples that pass the depth and stencil tests. */
    SDL_GPUStencilOp depth_fail_op;  /**< The action performed on samples that pass the stencil test and fail the depth test. */
    SDL_GPUCompareOp compare_op;     /**< The comparison operator used in the stencil test. */
}

struct SDL_GPUColorTargetBlendState
{
    SDL_GPUBlendFactor src_color_blendfactor;     /**< The value to be multiplied by the source RGB value. */
    SDL_GPUBlendFactor dst_color_blendfactor;     /**< The value to be multiplied by the destination RGB value. */
    SDL_GPUBlendOp color_blend_op;                /**< The blend operation for the RGB components. */
    SDL_GPUBlendFactor src_alpha_blendfactor;     /**< The value to be multiplied by the source alpha. */
    SDL_GPUBlendFactor dst_alpha_blendfactor;     /**< The value to be multiplied by the destination alpha. */
    SDL_GPUBlendOp alpha_blend_op;                /**< The blend operation for the alpha component. */
    SDL_GPUColorComponentFlags color_write_mask;  /**< A bitmask specifying which of the RGBA components are enabled for writing. Writes to all channels if enable_color_write_mask is false. */
    bool enable_blend;                            /**< Whether blending is enabled for the color target. */
    bool enable_color_write_mask;                 /**< Whether the color write mask is enabled. */
    char padding1;
    char padding2;
}


struct SDL_GPUShaderCreateInfo
{
    usz code_size;                /**< The size in bytes of the code pointed to. */
    char* code;                   /**< A pointer to shader code. */
    ZString entrypoint;           /**< A pointer to a null-terminated UTF-8 string specifying the entry point function name for the shader. */
    SDL_GPUShaderFormat format;   /**< The format of the shader code. */
    SDL_GPUShaderStage stage;     /**< The stage the shader program corresponds to. */
    uint num_samplers;            /**< The number of samplers defined in the shader. */
    uint num_storage_textures;    /**< The number of storage textures defined in the shader. */
    uint num_storage_buffers;     /**< The number of storage buffers defined in the shader. */
    uint num_uniform_buffers;     /**< The number of uniform buffers defined in the shader. */

    SDL_PropertiesID props;       /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
}

struct SDL_GPUTextureCreateInfo
{
    SDL_GPUTextureType type;          /**< The base dimensionality of the texture. */
    SDL_GPUTextureFormat format;      /**< The pixel format of the texture. */
    SDL_GPUTextureUsageFlags usage;   /**< How the texture is intended to be used by the client. */
    uint width;                       /**< The width of the texture. */
    uint height;                      /**< The height of the texture. */
    uint layer_count_or_depth;        /**< The layer count or depth of the texture. This value is treated as a layer count on 2D array textures, and as a depth value on 3D textures. */
    uint num_levels;                  /**< The number of mip levels in the texture. */
    SDL_GPUSampleCount sample_count;  /**< The number of samples per texel. Only applies if the texture is used as a render target. */

    SDL_PropertiesID props;           /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
}

struct SDL_GPUBufferCreateInfo
{
    SDL_GPUBufferUsageFlags usage;  /**< How the buffer is intended to be used by the client. */
    uint size;                      /**< The size in bytes of the buffer. */

    SDL_PropertiesID props;         /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
}

struct SDL_GPUTransferBufferCreateInfo
{
    SDL_GPUTransferBufferUsage usage;  /**< How the transfer buffer is intended to be used by the client. */
    uint size;                         /**< The size in bytes of the transfer buffer. */

    SDL_PropertiesID props;            /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
}

/* Pipeline state structures */

struct SDL_GPURasterizerState
{
    SDL_GPUFillMode fill_mode;         /**< Whether polygons will be filled in or drawn as lines. */
    SDL_GPUCullMode cull_mode;         /**< The facing direction in which triangles will be culled. */
    SDL_GPUFrontFace front_face;       /**< The vertex winding that will cause a triangle to be determined as front-facing. */
    float depth_bias_constant_factor;  /**< A scalar factor controlling the depth value added to each fragment. */
    float depth_bias_clamp;            /**< The maximum depth bias of a fragment. */
    float depth_bias_slope_factor;     /**< A scalar factor applied to a fragment's slope in depth calculations. */
    bool enable_depth_bias;            /**< true to bias fragment depth values. */
    bool enable_depth_clip;            /**< true to enable depth clip, false to enable depth clamp. */
    char padding1;
    char padding2;
}

struct SDL_GPUMultisampleState
{
    SDL_GPUSampleCount sample_count;  /**< The number of samples to be used in rasterization. */
    uint sample_mask;                 /**< Reserved for future use. Must be set to 0. */
    bool enable_mask;                 /**< Reserved for future use. Must be set to false. */
    bool enable_alpha_to_coverage;    /**< true enables the alpha-to-coverage feature. */
    char padding2;
    char padding3;
}

struct SDL_GPUDepthStencilState
{
    SDL_GPUCompareOp compare_op;                /**< The comparison operator used for depth testing. */
    SDL_GPUStencilOpState back_stencil_state;   /**< The stencil op state for back-facing triangles. */
    SDL_GPUStencilOpState front_stencil_state;  /**< The stencil op state for front-facing triangles. */
    char compare_mask;                          /**< Selects the bits of the stencil values participating in the stencil test. */
    char write_mask;                            /**< Selects the bits of the stencil values updated by the stencil test. */
    bool enable_depth_test;                     /**< true enables the depth test. */
    bool enable_depth_write;                    /**< true enables depth writes. Depth writes are always disabled when enable_depth_test is false. */
    bool enable_stencil_test;                   /**< true enables the stencil test. */
    char padding1;
    char padding2;
    char padding3;
}

struct SDL_GPUColorTargetDescription
{
    SDL_GPUTextureFormat format;               /**< The pixel format of the texture to be used as a color target. */
    SDL_GPUColorTargetBlendState blend_state;  /**< The blend state to be used for the color target. */
}

struct SDL_GPUGraphicsPipelineTargetInfo
{
    SDL_GPUColorTargetDescription* color_target_descriptions;        /**< A pointer to an array of color target descriptions. */
    uint num_color_targets;                                          /**< The number of color target descriptions in the above array. */
    SDL_GPUTextureFormat depth_stencil_format;                       /**< The pixel format of the depth-stencil target. Ignored if has_depth_stencil_target is false. */
    bool has_depth_stencil_target;                                   /**< true specifies that the pipeline uses a depth-stencil target. */
    char padding1;
    char padding2;
    char padding3;
}

struct SDL_GPUGraphicsPipelineCreateInfo
{
    SDL_GPUShader* vertex_shader;                   /**< The vertex shader used by the graphics pipeline. */
    SDL_GPUShader* fragment_shader;                 /**< The fragment shader used by the graphics pipeline. */
    SDL_GPUVertexInputState vertex_input_state;     /**< The vertex layout of the graphics pipeline. */
    SDL_GPUPrimitiveType primitive_type;            /**< The primitive topology of the graphics pipeline. */
    SDL_GPURasterizerState rasterizer_state;        /**< The rasterizer state of the graphics pipeline. */
    SDL_GPUMultisampleState multisample_state;      /**< The multisample state of the graphics pipeline. */
    SDL_GPUDepthStencilState depth_stencil_state;   /**< The depth-stencil state of the graphics pipeline. */
    SDL_GPUGraphicsPipelineTargetInfo target_info;  /**< Formats and blend modes for the render targets of the graphics pipeline. */

    SDL_PropertiesID props;                         /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
}

struct SDL_GPUComputePipelineCreateInfo
{
    usz code_size;                          /**< The size in bytes of the compute shader code pointed to. */
    char* code;                             /**< A pointer to compute shader code. */
    ZString entrypoint;                     /**< A pointer to a null-terminated UTF-8 string specifying the entry point function name for the shader. */
    SDL_GPUShaderFormat format;             /**< The format of the compute shader code. */
    uint num_samplers;                      /**< The number of samplers defined in the shader. */
    uint num_readonly_storage_textures;     /**< The number of readonly storage textures defined in the shader. */
    uint num_readonly_storage_buffers;      /**< The number of readonly storage buffers defined in the shader. */
    uint num_readwrite_storage_textures;    /**< The number of read-write storage textures defined in the shader. */
    uint num_readwrite_storage_buffers;     /**< The number of read-write storage buffers defined in the shader. */
    uint num_uniform_buffers;               /**< The number of uniform buffers defined in the shader. */
    uint threadcount_x;                     /**< The number of threads in the X dimension. This should match the value in the shader. */
    uint threadcount_y;                     /**< The number of threads in the Y dimension. This should match the value in the shader. */
    uint threadcount_z;                     /**< The number of threads in the Z dimension. This should match the value in the shader. */

    SDL_PropertiesID props;                 /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
}

struct SDL_GPUColorTargetInfo
{
    SDL_GPUTexture* texture;         /**< The texture that will be used as a color target by a render pass. */
    uint mip_level;                  /**< The mip level to use as a color target. */
    uint layer_or_depth_plane;       /**< The layer index or depth plane to use as a color target. This value is treated as a layer index on 2D array and cube textures, and as a depth plane on 3D textures. */
    SDL_FColor clear_color;          /**< The color to clear the color target to at the start of the render pass. Ignored if SDL_GPU_LOADOP_CLEAR is not used. */
    SDL_GPULoadOp load_op;           /**< What is done with the contents of the color target at the beginning of the render pass. */
    SDL_GPUStoreOp store_op;         /**< What is done with the results of the render pass. */
    SDL_GPUTexture* resolve_texture; /**< The texture that will receive the results of a multisample resolve operation. Ignored if a RESOLVE* store_op is not used. */
    uint resolve_mip_level;          /**< The mip level of the resolve texture to use for the resolve operation. Ignored if a RESOLVE* store_op is not used. */
    uint resolve_layer;              /**< The layer index of the resolve texture to use for the resolve operation. Ignored if a RESOLVE* store_op is not used. */
    bool cycle;                      /**< true cycles the texture if the texture is bound and load_op is not LOAD */
    bool cycle_resolve_texture;      /**< true cycles the resolve texture if the resolve texture is bound. Ignored if a RESOLVE* store_op is not used. */
    char padding1;
    char padding2;
}

struct SDL_GPUDepthStencilTargetInfo
{
    SDL_GPUTexture* texture;               /**< The texture that will be used as the depth stencil target by the render pass. */
    float clear_depth;                     /**< The value to clear the depth component to at the beginning of the render pass. Ignored if SDL_GPU_LOADOP_CLEAR is not used. */
    SDL_GPULoadOp load_op;                 /**< What is done with the depth contents at the beginning of the render pass. */
    SDL_GPUStoreOp store_op;               /**< What is done with the depth results of the render pass. */
    SDL_GPULoadOp stencil_load_op;         /**< What is done with the stencil contents at the beginning of the render pass. */
    SDL_GPUStoreOp stencil_store_op;       /**< What is done with the stencil results of the render pass. */
    bool cycle;                            /**< true cycles the texture if the texture is bound and any load ops are not LOAD */
    char clear_stencil;                    /**< The value to clear the stencil component to at the beginning of the render pass. Ignored if SDL_GPU_LOADOP_CLEAR is not used. */
    char mip_level;                        /**< The mip level to use as the depth stencil target. */
    char layer;                            /**< The layer index to use as the depth stencil target. */
}

struct SDL_GPUBlitInfo
{
    SDL_GPUBlitRegion source;       /**< The source region for the blit. */
    SDL_GPUBlitRegion destination;  /**< The destination region for the blit. */
    SDL_GPULoadOp load_op;          /**< What is done with the contents of the destination before the blit. */
    SDL_FColor clear_color;         /**< The color to clear the destination region to before the blit. Ignored if load_op is not SDL_GPU_LOADOP_CLEAR. */
    SDL_FlipMode flip_mode;         /**< The flip mode for the source region. */
    SDL_GPUFilter filter;           /**< The filter mode used when blitting. */
    bool cycle;                     /**< true cycles the destination texture if it is already bound. */
    char padding1;
    char padding2;
    char padding3;
}

/* Binding structs */

struct SDL_GPUBufferBinding
{
    SDL_GPUBuffer* buffer;  /**< The buffer to bind. Must have been created with SDL_GPU_BUFFERUSAGE_VERTEX for SDL_BindGPUVertexBuffers, or SDL_GPU_BUFFERUSAGE_INDEX for SDL_BindGPUIndexBuffer. */
    uint offset;            /**< The starting byte of the data to bind in the buffer. */
}

struct SDL_GPUTextureSamplerBinding
{
    SDL_GPUTexture* texture;  /**< The texture to bind. Must have been created with SDL_GPU_TEXTUREUSAGE_SAMPLER. */
    SDL_GPUSampler* sampler;  /**< The sampler to bind. */
}

struct SDL_GPUStorageBufferReadWriteBinding
{
    SDL_GPUBuffer* buffer;  /**< The buffer to bind. Must have been created with SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_WRITE. */
    bool cycle;             /**< true cycles the buffer if it is already bound. */
    char padding1;
    char padding2;
    char padding3;
}

struct SDL_GPUStorageTextureReadWriteBinding
{
    SDL_GPUTexture* texture;  /**< The texture to bind. Must have been created with SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_WRITE or SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE. */
    uint mip_level;           /**< The mip level index to bind. */
    uint layer;               /**< The layer index to bind. */
    bool cycle;               /**< true cycles the texture if it is already bound. */
    char padding1;
    char padding2;
    char padding3;
}

/* Functions */

/* Device */

extern fn bool gpusupports_shader_formats(
    SDL_GPUShaderFormat format_flags,
    ZString name) @extern("SDL_GPUSupportsShaderFormats");

extern fn bool gpusupports_properties(
    SDL_PropertiesID props) @extern("SDL_GPUSupportsProperties");

extern fn SDL_GPUDevice* create_gpudevice(
    SDL_GPUShaderFormat format_flags,
    bool debug_mode,
    ZString name) @extern("SDL_CreateGPUDevice");

extern fn SDL_GPUDevice* create_gpudevice_with_properties(
    SDL_PropertiesID props) @extern("SDL_CreateGPUDeviceWithProperties");

const PROP_GPU_DEVICE_CREATE_DEBUGMODE_BOOLEAN                             = "SDL.gpu.device.create.debugmode";
const PROP_GPU_DEVICE_CREATE_PREFERLOWPOWER_BOOLEAN                        = "SDL.gpu.device.create.preferlowpower";
const PROP_GPU_DEVICE_CREATE_VERBOSE_BOOLEAN                               = "SDL.gpu.device.create.verbose";
const PROP_GPU_DEVICE_CREATE_NAME_STRING                                   = "SDL.gpu.device.create.name";
const PROP_GPU_DEVICE_CREATE_FEATURE_CLIP_DISTANCE_BOOLEAN                 = "SDL.gpu.device.create.feature.clip_distance";
const PROP_GPU_DEVICE_CREATE_FEATURE_DEPTH_CLAMPING_BOOLEAN                = "SDL.gpu.device.create.feature.depth_clamping";
const PROP_GPU_DEVICE_CREATE_FEATURE_INDIRECT_DRAW_FIRST_INSTANCE_BOOLEAN  = "SDL.gpu.device.create.feature.indirect_draw_first_instance";
const PROP_GPU_DEVICE_CREATE_FEATURE_ANISOTROPY_BOOLEAN                    = "SDL.gpu.device.create.feature.anisotropy";
const PROP_GPU_DEVICE_CREATE_SHADERS_PRIVATE_BOOLEAN                       = "SDL.gpu.device.create.shaders.private";
const PROP_GPU_DEVICE_CREATE_SHADERS_SPIRV_BOOLEAN                         = "SDL.gpu.device.create.shaders.spirv";
const PROP_GPU_DEVICE_CREATE_SHADERS_DXBC_BOOLEAN                          = "SDL.gpu.device.create.shaders.dxbc";
const PROP_GPU_DEVICE_CREATE_SHADERS_DXIL_BOOLEAN                          = "SDL.gpu.device.create.shaders.dxil";
const PROP_GPU_DEVICE_CREATE_SHADERS_MSL_BOOLEAN                           = "SDL.gpu.device.create.shaders.msl";
const PROP_GPU_DEVICE_CREATE_SHADERS_METALLIB_BOOLEAN                      = "SDL.gpu.device.create.shaders.metallib";
const PROP_GPU_DEVICE_CREATE_D3D12_ALLOW_FEWER_RESOURCE_SLOTS_BOOLEAN      = "SDL.gpu.device.create.d3d12.allowtier1resourcebinding";
const PROP_GPU_DEVICE_CREATE_D3D12_SEMANTIC_NAME_STRING                    = "SDL.gpu.device.create.d3d12.semantic";

extern fn void destroy_gpudevice(SDL_GPUDevice* device) @extern("SDL_DestroyGPUDevice");

extern fn CInt get_num_gpudrivers() @extern("SDL_GetNumGPUDrivers");

extern fn ZString get_gpudriver(CInt index) @extern("SDL_GetGPUDriver");

extern fn ZString get_gpudevice_driver(SDL_GPUDevice* device) @extern("SDL_GetGPUDeviceDriver");

extern fn SDL_GPUShaderFormat get_gpushader_formats(SDL_GPUDevice* device) @extern("SDL_GetGPUShaderFormats");

extern fn SDL_PropertiesID get_gpudevice_properties(SDL_GPUDevice* device) @extern("SDL_GetGPUDeviceProperties");

const PROP_GPU_DEVICE_NAME_STRING                = "SDL.gpu.device.name";
const PROP_GPU_DEVICE_DRIVER_NAME_STRING         = "SDL.gpu.device.driver_name";
const PROP_GPU_DEVICE_DRIVER_VERSION_STRING      = "SDL.gpu.device.driver_version";
const PROP_GPU_DEVICE_DRIVER_INFO_STRING         = "SDL.gpu.device.driver_info";


/* State Creation */

extern fn SDL_GPUComputePipeline* create_gpucompute_pipeline(
    SDL_GPUDevice* device,
    SDL_GPUComputePipelineCreateInfo* createinfo) @extern("SDL_CreateGPUComputePipeline");

const PROP_GPU_COMPUTEPIPELINE_CREATE_NAME_STRING  = "SDL.gpu.computepipeline.create.name";

extern fn SDL_GPUGraphicsPipeline* create_gpugraphics_pipeline(
    SDL_GPUDevice* device,
    SDL_GPUGraphicsPipelineCreateInfo* createinfo) @extern("SDL_CreateGPUGraphicsPipeline");

const PROP_GPU_GRAPHICSPIPELINE_CREATE_NAME_STRING  = "SDL.gpu.graphicspipeline.create.name";

extern fn SDL_GPUSampler* create_gpusampler(
    SDL_GPUDevice* device,
    SDL_GPUSamplerCreateInfo* createinfo) @extern("SDL_CreateGPUSampler");

const PROP_GPU_SAMPLER_CREATE_NAME_STRING  = "SDL.gpu.sampler.create.name";

extern fn SDL_GPUShader* create_gpushader(
    SDL_GPUDevice* device,
    SDL_GPUShaderCreateInfo* createinfo) @extern("SDL_CreateGPUShader");

const PROP_GPU_SHADER_CREATE_NAME_STRING  = "SDL.gpu.shader.create.name";

extern fn SDL_GPUTexture* create_gputexture(
    SDL_GPUDevice* device,
    SDL_GPUTextureCreateInfo* createinfo) @extern("SDL_CreateGPUTexture");

const PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_R_FLOAT          = "SDL.gpu.texture.create.d3d12.clear.r";
const PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_G_FLOAT          = "SDL.gpu.texture.create.d3d12.clear.g";
const PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_B_FLOAT          = "SDL.gpu.texture.create.d3d12.clear.b";
const PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_A_FLOAT          = "SDL.gpu.texture.create.d3d12.clear.a";
const PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_DEPTH_FLOAT      = "SDL.gpu.texture.create.d3d12.clear.depth";
const PROP_GPU_TEXTURE_CREATE_D3D12_CLEAR_STENCIL_NUMBER   = "SDL.gpu.texture.create.d3d12.clear.stencil";
const PROP_GPU_TEXTURE_CREATE_NAME_STRING                  = "SDL.gpu.texture.create.name";

extern fn SDL_GPUBuffer* create_gpubuffer(
    SDL_GPUDevice* device,
    SDL_GPUBufferCreateInfo* createinfo) @extern("SDL_CreateGPUBuffer");

const PROP_GPU_BUFFER_CREATE_NAME_STRING  = "SDL.gpu.buffer.create.name";

extern fn SDL_GPUTransferBuffer* create_gputransfer_buffer(
    SDL_GPUDevice* device,
    SDL_GPUTransferBufferCreateInfo* createinfo) @extern("SDL_CreateGPUTransferBuffer");

const PROP_GPU_TRANSFERBUFFER_CREATE_NAME_STRING  = "SDL.gpu.transferbuffer.create.name";

/* Debug Naming */

extern fn void set_gpubuffer_name(
    SDL_GPUDevice* device,
    SDL_GPUBuffer* buffer,
    ZString text) @extern("SDL_SetGPUBufferName");

extern fn void set_gputexture_name(
    SDL_GPUDevice* device,
    SDL_GPUTexture* texture,
    ZString text) @extern("SDL_SetGPUTextureName");

extern fn void insert_gpudebug_label(
    SDL_GPUCommandBuffer* command_buffer,
    ZString text) @extern("SDL_InsertGPUDebugLabel");

extern fn void push_gpudebug_group(
    SDL_GPUCommandBuffer* command_buffer,
    ZString name) @extern("SDL_PushGPUDebugGroup");

extern fn void pop_gpudebug_group(
    SDL_GPUCommandBuffer* command_buffer) @extern("SDL_PopGPUDebugGroup");

/* Disposal */

extern fn void release_gputexture(
    SDL_GPUDevice* device,
    SDL_GPUTexture* texture) @extern("SDL_ReleaseGPUTexture");

extern fn void release_gpusampler(
    SDL_GPUDevice* device,
    SDL_GPUSampler* sampler) @extern("SDL_ReleaseGPUSampler");

extern fn void release_gpubuffer(
    SDL_GPUDevice* device,
    SDL_GPUBuffer* buffer) @extern("SDL_ReleaseGPUBuffer");

extern fn void release_gputransfer_buffer(
    SDL_GPUDevice* device,
    SDL_GPUTransferBuffer* transfer_buffer) @extern("SDL_ReleaseGPUTransferBuffer");

extern fn void release_gpucompute_pipeline(
    SDL_GPUDevice* device,
    SDL_GPUComputePipeline* compute_pipeline) @extern("SDL_ReleaseGPUComputePipeline");

extern fn void release_gpushader(
    SDL_GPUDevice* device,
    SDL_GPUShader* shader) @extern("SDL_ReleaseGPUShader");

extern fn void release_gpugraphics_pipeline(
    SDL_GPUDevice* device,
    SDL_GPUGraphicsPipeline* graphics_pipeline) @extern("SDL_ReleaseGPUGraphicsPipeline");

extern fn SDL_GPUCommandBuffer* acquire_gpucommand_buffer(
    SDL_GPUDevice* device) @extern("SDL_AcquireGPUCommandBuffer");

/* Uniform Data */

extern fn void push_gpuvertex_uniform_data(
    SDL_GPUCommandBuffer* command_buffer,
    uint slot_index,
    void* data,
    uint length) @extern("SDL_PushGPUVertexUniformData");

extern fn void push_gpufragment_uniform_data(
    SDL_GPUCommandBuffer* command_buffer,
    uint slot_index,
    void* data,
    uint length) @extern("SDL_PushGPUFragmentUniformData");

extern fn void push_gpucompute_uniform_data(
    SDL_GPUCommandBuffer* command_buffer,
    uint slot_index,
    void* data,
    uint length) @extern("SDL_PushGPUComputeUniformData");

/* Graphics State */

extern fn SDL_GPURenderPass* begin_gpurender_pass(
    SDL_GPUCommandBuffer* command_buffer,
    SDL_GPUColorTargetInfo* color_target_infos,
    uint num_color_targets,
    SDL_GPUDepthStencilTargetInfo* depth_stencil_target_info) @extern("SDL_BeginGPURenderPass");

extern fn void bind_gpugraphics_pipeline(
    SDL_GPURenderPass* render_pass,
    SDL_GPUGraphicsPipeline* graphics_pipeline) @extern("SDL_BindGPUGraphicsPipeline");

extern fn void set_gpuviewport(
    SDL_GPURenderPass* render_pass,
    SDL_GPUViewport* viewport) @extern("SDL_SetGPUViewport");

extern fn void set_gpuscissor(
    SDL_GPURenderPass* render_pass,
    SDL_Rect* scissor) @extern("SDL_SetGPUScissor");

extern fn void set_gpublend_constants(
    SDL_GPURenderPass* render_pass,
    SDL_FColor blend_constants) @extern("SDL_SetGPUBlendConstants");

extern fn void set_gpustencil_reference(
    SDL_GPURenderPass* render_pass,
    char reference) @extern("SDL_SetGPUStencilReference");

extern fn void bind_gpuvertex_buffers(
    SDL_GPURenderPass* render_pass,
    uint first_slot,
    SDL_GPUBufferBinding* bindings,
    uint num_bindings) @extern("SDL_BindGPUVertexBuffers");

extern fn void bind_gpuindex_buffer(
    SDL_GPURenderPass* render_pass,
    SDL_GPUBufferBinding* binding,
    SDL_GPUIndexElementSize index_element_size) @extern("SDL_BindGPUIndexBuffer");

extern fn void bind_gpuvertex_samplers(
    SDL_GPURenderPass* render_pass,
    uint first_slot,
    SDL_GPUTextureSamplerBinding* texture_sampler_bindings,
    uint num_bindings) @extern("SDL_BindGPUVertexSamplers");

extern fn void bind_gpuvertex_storage_textures(
    SDL_GPURenderPass* render_pass,
    uint first_slot,
    SDL_GPUTexture** storage_textures,
    uint num_bindings) @extern("SDL_BindGPUVertexStorageTextures");

extern fn void bind_gpuvertex_storage_buffers(
    SDL_GPURenderPass* render_pass,
    uint first_slot,
    SDL_GPUBuffer** storage_buffers,
    uint num_bindings) @extern("SDL_BindGPUVertexStorageBuffers");

extern fn void bind_gpufragment_samplers(
    SDL_GPURenderPass* render_pass,
    uint first_slot,
    SDL_GPUTextureSamplerBinding* texture_sampler_bindings,
    uint num_bindings) @extern("SDL_BindGPUFragmentSamplers");

extern fn void bind_gpufragment_storage_textures(
    SDL_GPURenderPass* render_pass,
    uint first_slot,
    SDL_GPUTexture** storage_textures,
    uint num_bindings) @extern("SDL_BindGPUFragmentStorageTextures");

extern fn void bind_gpufragment_storage_buffers(
    SDL_GPURenderPass* render_pass,
    uint first_slot,
    SDL_GPUBuffer** storage_buffers,
    uint num_bindings) @extern("SDL_BindGPUFragmentStorageBuffers");

/* Drawing */

extern fn void draw_gpuindexed_primitives(
    SDL_GPURenderPass* render_pass,
    uint num_indices,
    uint num_instances,
    uint first_index,
    int vertex_offset,
    uint first_instance) @extern("SDL_DrawGPUIndexedPrimitives");

extern fn void draw_gpuprimitives(
    SDL_GPURenderPass* render_pass,
    uint num_vertices,
    uint num_instances,
    uint first_vertex,
    uint first_instance) @extern("SDL_DrawGPUPrimitives");

extern fn void draw_gpuprimitives_indirect(
    SDL_GPURenderPass* render_pass,
    SDL_GPUBuffer* buffer,
    uint offset,
    uint draw_count) @extern("SDL_DrawGPUPrimitivesIndirect");

extern fn void draw_gpuindexed_primitives_indirect(
    SDL_GPURenderPass* render_pass,
    SDL_GPUBuffer* buffer,
    uint offset,
    uint draw_count) @extern("SDL_DrawGPUIndexedPrimitivesIndirect");

extern fn void end_gpurender_pass(
    SDL_GPURenderPass* render_pass) @extern("SDL_EndGPURenderPass");

/* Compute Pass */

extern fn SDL_GPUComputePass* begin_gpucompute_pass(
    SDL_GPUCommandBuffer* command_buffer,
    SDL_GPUStorageTextureReadWriteBinding* storage_texture_bindings,
    uint num_storage_texture_bindings,
    SDL_GPUStorageBufferReadWriteBinding* storage_buffer_bindings,
    uint num_storage_buffer_bindings) @extern("SDL_BeginGPUComputePass");

extern fn void bind_gpucompute_pipeline(
    SDL_GPUComputePass* compute_pass,
    SDL_GPUComputePipeline* compute_pipeline) @extern("SDL_BindGPUComputePipeline");

extern fn void bind_gpucompute_samplers(
    SDL_GPUComputePass* compute_pass,
    uint first_slot,
    SDL_GPUTextureSamplerBinding* texture_sampler_bindings,
    uint num_bindings) @extern("SDL_BindGPUComputeSamplers");

extern fn void bind_gpucompute_storage_textures(
    SDL_GPUComputePass* compute_pass,
    uint first_slot,
    SDL_GPUTexture** storage_textures,
    uint num_bindings) @extern("SDL_BindGPUComputeStorageTextures");

extern fn void bind_gpucompute_storage_buffers(
    SDL_GPUComputePass* compute_pass,
    uint first_slot,
    SDL_GPUBuffer** storage_buffers,
    uint num_bindings) @extern("SDL_BindGPUComputeStorageBuffers");

extern fn void dispatch_gpucompute(
    SDL_GPUComputePass* compute_pass,
    uint groupcount_x,
    uint groupcount_y,
    uint groupcount_z) @extern("SDL_DispatchGPUCompute");

extern fn void dispatch_gpucompute_indirect(
    SDL_GPUComputePass* compute_pass,
    SDL_GPUBuffer* buffer,
    uint offset) @extern("SDL_DispatchGPUComputeIndirect");

extern fn void end_gpucompute_pass(
    SDL_GPUComputePass* compute_pass) @extern("SDL_EndGPUComputePass");

/* TransferBuffer Data */

extern fn void* map_gputransfer_buffer(
    SDL_GPUDevice* device,
    SDL_GPUTransferBuffer* transfer_buffer,
    bool cycle) @extern("SDL_MapGPUTransferBuffer");

extern fn void unmap_gputransfer_buffer(
    SDL_GPUDevice* device,
    SDL_GPUTransferBuffer* transfer_buffer) @extern("SDL_UnmapGPUTransferBuffer");

/* Copy Pass */

extern fn SDL_GPUCopyPass* begin_gpucopy_pass(
    SDL_GPUCommandBuffer* command_buffer) @extern("SDL_BeginGPUCopyPass");

extern fn void upload_to_gputexture(
    SDL_GPUCopyPass* copy_pass,
    SDL_GPUTextureTransferInfo* source,
    SDL_GPUTextureRegion* destination,
    bool cycle) @extern("SDL_UploadToGPUTexture");

extern fn void upload_to_gpubuffer(
    SDL_GPUCopyPass* copy_pass,
    SDL_GPUTransferBufferLocation* source,
    SDL_GPUBufferRegion* destination,
    bool cycle) @extern("SDL_UploadToGPUBuffer");

extern fn void copy_gputexture_to_texture(
    SDL_GPUCopyPass* copy_pass,
    SDL_GPUTextureLocation* source,
    SDL_GPUTextureLocation* destination,
    uint w,
    uint h,
    uint d,
    bool cycle) @extern("SDL_CopyGPUTextureToTexture");

extern fn void copy_gpubuffer_to_buffer(
    SDL_GPUCopyPass* copy_pass,
    SDL_GPUBufferLocation* source,
    SDL_GPUBufferLocation* destination,
    uint size,
    bool cycle) @extern("SDL_CopyGPUBufferToBuffer");

extern fn void download_from_gputexture(
    SDL_GPUCopyPass* copy_pass,
    SDL_GPUTextureRegion* source,
    SDL_GPUTextureTransferInfo* destination) @extern("SDL_DownloadFromGPUTexture");

extern fn void download_from_gpubuffer(
    SDL_GPUCopyPass* copy_pass,
    SDL_GPUBufferRegion* source,
    SDL_GPUTransferBufferLocation* destination) @extern("SDL_DownloadFromGPUBuffer");

extern fn void end_gpucopy_pass(
    SDL_GPUCopyPass* copy_pass) @extern("SDL_EndGPUCopyPass");

extern fn void generate_mipmaps_for_gputexture(
    SDL_GPUCommandBuffer* command_buffer,
    SDL_GPUTexture* texture) @extern("SDL_GenerateMipmapsForGPUTexture");

extern fn void blit_gputexture(
    SDL_GPUCommandBuffer* command_buffer,
    SDL_GPUBlitInfo* info) @extern("SDL_BlitGPUTexture");

/* Submission/Presentation */

extern fn bool window_supports_gpuswapchain_composition(
    SDL_GPUDevice* device,
    SDL_Window* window,
    SDL_GPUSwapchainComposition swapchain_composition) @extern("SDL_WindowSupportsGPUSwapchainComposition");

extern fn bool window_supports_gpupresent_mode(
    SDL_GPUDevice* device,
    SDL_Window* window,
    SDL_GPUPresentMode present_mode) @extern("SDL_WindowSupportsGPUPresentMode");

extern fn bool claim_window_for_gpudevice(
    SDL_GPUDevice* device,
    SDL_Window* window) @extern("SDL_ClaimWindowForGPUDevice");

extern fn void release_window_from_gpudevice(
    SDL_GPUDevice* device,
    SDL_Window* window) @extern("SDL_ReleaseWindowFromGPUDevice");

extern fn bool set_gpuswapchain_parameters(
    SDL_GPUDevice* device,
    SDL_Window* window,
    SDL_GPUSwapchainComposition swapchain_composition,
    SDL_GPUPresentMode present_mode) @extern("SDL_SetGPUSwapchainParameters");

extern fn bool set_gpuallowed_frames_in_flight(
    SDL_GPUDevice* device,
    uint allowed_frames_in_flight) @extern("SDL_SetGPUAllowedFramesInFlight");

extern fn SDL_GPUTextureFormat get_gpuswapchain_texture_format(
    SDL_GPUDevice* device,
    SDL_Window* window) @extern("SDL_GetGPUSwapchainTextureFormat");

extern fn bool acquire_gpuswapchain_texture(
    SDL_GPUCommandBuffer* command_buffer,
    SDL_Window* window,
    SDL_GPUTexture** swapchain_texture,
    uint* swapchain_texture_width,
    uint* swapchain_texture_height) @extern("SDL_AcquireGPUSwapchainTexture");

extern fn bool wait_for_gpuswapchain(
    SDL_GPUDevice* device,
    SDL_Window* window) @extern("SDL_WaitForGPUSwapchain");

extern fn bool wait_and_acquire_gpuswapchain_texture(
    SDL_GPUCommandBuffer* command_buffer,
    SDL_Window* window,
    SDL_GPUTexture** swapchain_texture,
    uint* swapchain_texture_width,
    uint* swapchain_texture_height) @extern("SDL_WaitAndAcquireGPUSwapchainTexture");

extern fn bool submit_gpucommand_buffer(
    SDL_GPUCommandBuffer* command_buffer) @extern("SDL_SubmitGPUCommandBuffer");

extern fn SDL_GPUFence* submit_gpucommand_buffer_and_acquire_fence(
    SDL_GPUCommandBuffer* command_buffer) @extern("SDL_SubmitGPUCommandBufferAndAcquireFence");

extern fn bool cancel_gpucommand_buffer(
    SDL_GPUCommandBuffer* command_buffer) @extern("SDL_CancelGPUCommandBuffer");

extern fn bool wait_for_gpuidle(
    SDL_GPUDevice* device) @extern("SDL_WaitForGPUIdle");

extern fn bool wait_for_gpufences(
    SDL_GPUDevice* device,
    bool wait_all,
    SDL_GPUFence** fences,
    uint num_fences) @extern("SDL_WaitForGPUFences");

extern fn bool query_gpufence(
    SDL_GPUDevice* device,
    SDL_GPUFence* fence) @extern("SDL_QueryGPUFence");

extern fn void release_gpufence(
    SDL_GPUDevice* device,
    SDL_GPUFence* fence) @extern("SDL_ReleaseGPUFence");

/* Format Info */

extern fn uint gputexture_format_texel_block_size(
    SDL_GPUTextureFormat format) @extern("SDL_GPUTextureFormatTexelBlockSize");

extern fn bool gputexture_supports_format(
    SDL_GPUDevice* device,
    SDL_GPUTextureFormat format,
    SDL_GPUTextureType type,
    SDL_GPUTextureUsageFlags usage) @extern("SDL_GPUTextureSupportsFormat");

extern fn bool gputexture_supports_sample_count(
    SDL_GPUDevice* device,
    SDL_GPUTextureFormat format,
    SDL_GPUSampleCount sample_count) @extern("SDL_GPUTextureSupportsSampleCount");

extern fn uint calculate_gputexture_format_size(
    SDL_GPUTextureFormat format,
    uint width,
    uint height,
    uint depth_or_layer_count) @extern("SDL_CalculateGPUTextureFormatSize");

extern fn SDL_PixelFormat get_pixel_format_from_gputexture_format(SDL_GPUTextureFormat format) @extern("SDL_GetPixelFormatFromGPUTextureFormat");

extern fn SDL_GPUTextureFormat get_gputexture_format_from_pixel_format(SDL_PixelFormat format) @extern("SDL_GetGPUTextureFormatFromPixelFormat");

::LINE:: #ifdef SDL_PLATFORM_GDK

extern fn void gdksuspend_gpu(SDL_GPUDevice* device) @extern("SDL_GDKSuspendGPU");

extern fn void gdkresume_gpu(SDL_GPUDevice* device) @extern("SDL_GDKResumeGPU");

::LINE:: #endif /* SDL_PLATFORM_GDK */

::LINE:: #ifdef __cplusplus
::LINE:: }
::LINE:: #endif /* __cplusplus */

::LINE:: #endif /* SDL_gpu_h_ */
