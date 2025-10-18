module sdl;

enum SDL_BlendMode : const uint
{
    NONE                   = 0x00000000u, /**< no blending: dstRGBA = srcRGBA */
    BLEND                  = 0x00000001u, /**< alpha blending: dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA)), dstA = srcA + (dstA * (1-srcA)) */
    BLEND_PREMULTIPLIED    = 0x00000010u, /**< pre-multiplied alpha blending: dstRGBA = srcRGBA + (dstRGBA * (1-srcA)) */
    ADD                    = 0x00000002u, /**< additive blending: dstRGB = (srcRGB * srcA) + dstRGB, dstA = dstA */
    ADD_PREMULTIPLIED      = 0x00000020u, /**< pre-multiplied additive blending: dstRGB = srcRGB + dstRGB, dstA = dstA */
    MOD                    = 0x00000004u, /**< color modulate: dstRGB = srcRGB * dstRGB, dstA = dstA */
    MUL                    = 0x00000008u, /**< color multiply: dstRGB = (srcRGB * dstRGB) + (dstRGB * (1-srcA)), dstA = dstA */
    INVALID                = 0x7FFFFFFFu,
}

enum SDL_BlendOperation : const CInt
{
    ADD = 0x1,  /**< dst + src: supported by all renderers */
    SUBTRACT = 0x2,  /**< src - dst : supported by D3D, OpenGL, OpenGLES, and Vulkan */
    REV_SUBTRACT = 0x3,  /**< dst - src : supported by D3D, OpenGL, OpenGLES, and Vulkan */
    MINIMUM = 0x4,  /**< min(dst, src) : supported by D3D, OpenGL, OpenGLES, and Vulkan */
    MAXIMUM = 0x5,  /**< max(dst, src) : supported by D3D, OpenGL, OpenGLES, and Vulkan */
}

enum SDL_BlendFactor : const CInt
{
    ZERO = 0x1,  /**< 0, 0, 0, 0 */
    ONE = 0x2,  /**< 1, 1, 1, 1 */
    SRC_COLOR = 0x3,  /**< srcR, srcG, srcB, srcA */
    ONE_MINUS_SRC_COLOR = 0x4,  /**< 1-srcR, 1-srcG, 1-srcB, 1-srcA */
    SRC_ALPHA = 0x5,  /**< srcA, srcA, srcA, srcA */
    ONE_MINUS_SRC_ALPHA = 0x6,  /**< 1-srcA, 1-srcA, 1-srcA, 1-srcA */
    DST_COLOR = 0x7,  /**< dstR, dstG, dstB, dstA */
    ONE_MINUS_DST_COLOR = 0x8,  /**< 1-dstR, 1-dstG, 1-dstB, 1-dstA */
    DST_ALPHA = 0x9,  /**< dstA, dstA, dstA, dstA */
    ONE_MINUS_DST_ALPHA = 0xA,  /**< 1-dstA, 1-dstA, 1-dstA, 1-dstA */
}

extern fn SDL_BlendMode compose_custom_blend_mode(SDL_BlendFactor srcColorFactor,
                                                  SDL_BlendFactor dstColorFactor,
                                                  SDL_BlendOperation colorOperation,
                                                  SDL_BlendFactor srcAlphaFactor,
                                                  SDL_BlendFactor dstAlphaFactor,
                                                  SDL_BlendOperation alphaOperation) @extern("SDL_ComposeCustomBlendMode");
