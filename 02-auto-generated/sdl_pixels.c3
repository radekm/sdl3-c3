module sdl;


::LINE:: #ifndef SDL_pixels_h_
::LINE:: #define SDL_pixels_h_


/* Set up for C function definitions, even when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: extern "C" {
::LINE:: #endif

::LINE:: #define SDL_ALPHA_OPAQUE 255

::LINE:: #define SDL_ALPHA_OPAQUE_FLOAT 1.0f

::LINE:: #define SDL_ALPHA_TRANSPARENT 0

::LINE:: #define SDL_ALPHA_TRANSPARENT_FLOAT 0.0f

enum SDL_PixelType : const CInt
{
    UNKNOWN,
    INDEX1,
    INDEX4,
    INDEX8,
    PACKED8,
    PACKED16,
    PACKED32,
    ARRAYU8,
    ARRAYU16,
    ARRAYU32,
    ARRAYF16,
    ARRAYF32,
    /* appended at the end for compatibility with sdl2-compat:  */
    INDEX2,
}

enum SDL_BitmapOrder : const CInt
{
    ORDER_NONE,
    ORDER_4321,
    ORDER_1234,
}

enum SDL_PackedOrder : const CInt
{
    NONE,
    XRGB,
    RGBX,
    ARGB,
    RGBA,
    XBGR,
    BGRX,
    ABGR,
    BGRA,
}

enum SDL_ArrayOrder : const CInt
{
    NONE,
    RGB,
    RGBA,
    ARGB,
    BGR,
    BGRA,
    ABGR,
}

enum SDL_PackedLayout : const CInt
{
    LAYOUT_NONE,
    LAYOUT_332,
    LAYOUT_4444,
    LAYOUT_1555,
    LAYOUT_5551,
    LAYOUT_565,
    LAYOUT_8888,
    LAYOUT_2101010,
    LAYOUT_1010102,
}

::LINE:: #define SDL_DEFINE_PIXELFOURCC(A, B, C, D) SDL_FOURCC(A, B, C, D)

::LINE:: #define SDL_DEFINE_PIXELFORMAT(type, order, layout, bits, bytes) \
::LINE::     ((1 << 28) | ((type) << 24) | ((order) << 20) | ((layout) << 16) | \
::LINE::      ((bits) << 8) | ((bytes) << 0))

::LINE:: #define SDL_PIXELFLAG(format)    (((format) >> 28) & 0x0F)

::LINE:: #define SDL_PIXELTYPE(format)    (((format) >> 24) & 0x0F)

::LINE:: #define SDL_PIXELORDER(format)   (((format) >> 20) & 0x0F)

::LINE:: #define SDL_PIXELLAYOUT(format)  (((format) >> 16) & 0x0F)

::LINE:: #define SDL_BITSPERPIXEL(format) \
::LINE::     (SDL_ISPIXELFORMAT_FOURCC(format) ? 0 : (((format) >> 8) & 0xFF))

::LINE:: #define SDL_BYTESPERPIXEL(format) \
::LINE::     (SDL_ISPIXELFORMAT_FOURCC(format) ? \
::LINE::         ((((format) == SDL_PIXELFORMAT_YUY2) || \
::LINE::           ((format) == SDL_PIXELFORMAT_UYVY) || \
::LINE::           ((format) == SDL_PIXELFORMAT_YVYU) || \
::LINE::           ((format) == SDL_PIXELFORMAT_P010)) ? 2 : 1) : (((format) >> 0) & 0xFF))


::LINE:: #define SDL_ISPIXELFORMAT_INDEXED(format)   \
::LINE::     (!SDL_ISPIXELFORMAT_FOURCC(format) && \
::LINE::      ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX1) || \
::LINE::       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX2) || \
::LINE::       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX4) || \
::LINE::       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_INDEX8)))

::LINE:: #define SDL_ISPIXELFORMAT_PACKED(format) \
::LINE::     (!SDL_ISPIXELFORMAT_FOURCC(format) && \
::LINE::      ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_PACKED8) || \
::LINE::       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_PACKED16) || \
::LINE::       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_PACKED32)))

::LINE:: #define SDL_ISPIXELFORMAT_ARRAY(format) \
::LINE::     (!SDL_ISPIXELFORMAT_FOURCC(format) && \
::LINE::      ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYU8) || \
::LINE::       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYU16) || \
::LINE::       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYU32) || \
::LINE::       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYF16) || \
::LINE::       (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYF32)))

::LINE:: #define SDL_ISPIXELFORMAT_10BIT(format)    \
::LINE::       (!SDL_ISPIXELFORMAT_FOURCC(format) && \
::LINE::        ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_PACKED32) && \
::LINE::         (SDL_PIXELLAYOUT(format) == SDL_PACKEDLAYOUT_2101010)))

::LINE:: #define SDL_ISPIXELFORMAT_FLOAT(format)    \
::LINE::       (!SDL_ISPIXELFORMAT_FOURCC(format) && \
::LINE::        ((SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYF16) || \
::LINE::         (SDL_PIXELTYPE(format) == SDL_PIXELTYPE_ARRAYF32)))

::LINE:: #define SDL_ISPIXELFORMAT_ALPHA(format)   \
::LINE::     ((SDL_ISPIXELFORMAT_PACKED(format) && \
::LINE::       ((SDL_PIXELORDER(format) == SDL_PACKEDORDER_ARGB) || \
::LINE::        (SDL_PIXELORDER(format) == SDL_PACKEDORDER_RGBA) || \
::LINE::        (SDL_PIXELORDER(format) == SDL_PACKEDORDER_ABGR) || \
::LINE::        (SDL_PIXELORDER(format) == SDL_PACKEDORDER_BGRA))) || \
::LINE::      (SDL_ISPIXELFORMAT_ARRAY(format) && \
::LINE::       ((SDL_PIXELORDER(format) == SDL_ARRAYORDER_ARGB) || \
::LINE::        (SDL_PIXELORDER(format) == SDL_ARRAYORDER_RGBA) || \
::LINE::        (SDL_PIXELORDER(format) == SDL_ARRAYORDER_ABGR) || \
::LINE::        (SDL_PIXELORDER(format) == SDL_ARRAYORDER_BGRA))))


::LINE:: #define SDL_ISPIXELFORMAT_FOURCC(format)  /* The flag is set to 1 because 0x1? is not in the printable ASCII range */ \
::LINE::     ((format) && (SDL_PIXELFLAG(format) != 1))

/* Note: If you modify this enum, update SDL_GetPixelFormatName() */

enum SDL_PixelFormat : const CInt
{
    UNKNOWN = 0,
    INDEX1LSB = 0x11100100u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX1, SDL_BITMAPORDER_4321, 0, 1, 0), */
    INDEX1MSB = 0x11200100u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX1, SDL_BITMAPORDER_1234, 0, 1, 0), */
    INDEX2LSB = 0x1c100200u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX2, SDL_BITMAPORDER_4321, 0, 2, 0), */
    INDEX2MSB = 0x1c200200u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX2, SDL_BITMAPORDER_1234, 0, 2, 0), */
    INDEX4LSB = 0x12100400u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX4, SDL_BITMAPORDER_4321, 0, 4, 0), */
    INDEX4MSB = 0x12200400u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX4, SDL_BITMAPORDER_1234, 0, 4, 0), */
    INDEX8 = 0x13000801u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX8, 0, 0, 8, 1), */
    RGB332 = 0x14110801u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED8, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_332, 8, 1), */
    XRGB4444 = 0x15120c02u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_4444, 12, 2), */
    XBGR4444 = 0x15520c02u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_4444, 12, 2), */
    XRGB1555 = 0x15130f02u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_1555, 15, 2), */
    XBGR1555 = 0x15530f02u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_1555, 15, 2), */
    ARGB4444 = 0x15321002u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_4444, 16, 2), */
    RGBA4444 = 0x15421002u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_RGBA, SDL_PACKEDLAYOUT_4444, 16, 2), */
    ABGR4444 = 0x15721002u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_4444, 16, 2), */
    BGRA4444 = 0x15821002u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_BGRA, SDL_PACKEDLAYOUT_4444, 16, 2), */
    ARGB1555 = 0x15331002u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_1555, 16, 2), */
    RGBA5551 = 0x15441002u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_RGBA, SDL_PACKEDLAYOUT_5551, 16, 2), */
    ABGR1555 = 0x15731002u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_1555, 16, 2), */
    BGRA5551 = 0x15841002u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_BGRA, SDL_PACKEDLAYOUT_5551, 16, 2), */
    RGB565 = 0x15151002u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_565, 16, 2), */
    BGR565 = 0x15551002u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_565, 16, 2), */
    RGB24 = 0x17101803u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU8, SDL_ARRAYORDER_RGB, 0, 24, 3), */
    BGR24 = 0x17401803u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU8, SDL_ARRAYORDER_BGR, 0, 24, 3), */
    XRGB8888 = 0x16161804u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_8888, 24, 4), */
    RGBX8888 = 0x16261804u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_RGBX, SDL_PACKEDLAYOUT_8888, 24, 4), */
    XBGR8888 = 0x16561804u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_8888, 24, 4), */
    BGRX8888 = 0x16661804u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_BGRX, SDL_PACKEDLAYOUT_8888, 24, 4), */
    ARGB8888 = 0x16362004u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_8888, 32, 4), */
    RGBA8888 = 0x16462004u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_RGBA, SDL_PACKEDLAYOUT_8888, 32, 4), */
    ABGR8888 = 0x16762004u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_8888, 32, 4), */
    BGRA8888 = 0x16862004u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_BGRA, SDL_PACKEDLAYOUT_8888, 32, 4), */
    XRGB2101010 = 0x16172004u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_2101010, 32, 4), */
    XBGR2101010 = 0x16572004u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_2101010, 32, 4), */
    ARGB2101010 = 0x16372004u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_2101010, 32, 4), */
    ABGR2101010 = 0x16772004u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_2101010, 32, 4), */
    RGB48 = 0x18103006u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_RGB, 0, 48, 6), */
    BGR48 = 0x18403006u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_BGR, 0, 48, 6), */
    RGBA64 = 0x18204008u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_RGBA, 0, 64, 8), */
    ARGB64 = 0x18304008u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_ARGB, 0, 64, 8), */
    BGRA64 = 0x18504008u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_BGRA, 0, 64, 8), */
    ABGR64 = 0x18604008u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_ABGR, 0, 64, 8), */
    RGB48_FLOAT = 0x1a103006u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_RGB, 0, 48, 6), */
    BGR48_FLOAT = 0x1a403006u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_BGR, 0, 48, 6), */
    RGBA64_FLOAT = 0x1a204008u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_RGBA, 0, 64, 8), */
    ARGB64_FLOAT = 0x1a304008u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_ARGB, 0, 64, 8), */
    BGRA64_FLOAT = 0x1a504008u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_BGRA, 0, 64, 8), */
    ABGR64_FLOAT = 0x1a604008u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_ABGR, 0, 64, 8), */
    RGB96_FLOAT = 0x1b10600cu,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_RGB, 0, 96, 12), */
    BGR96_FLOAT = 0x1b40600cu,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_BGR, 0, 96, 12), */
    RGBA128_FLOAT = 0x1b208010u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_RGBA, 0, 128, 16), */
    ARGB128_FLOAT = 0x1b308010u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_ARGB, 0, 128, 16), */
    BGRA128_FLOAT = 0x1b508010u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_BGRA, 0, 128, 16), */
    ABGR128_FLOAT = 0x1b608010u,
        /* SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_ABGR, 0, 128, 16), */

    YV12 = 0x32315659u,  /**< Planar mode: Y + V + U  (3 planes) */
        /* SDL_DEFINE_PIXELFOURCC('Y', 'V', '1', '2'), */
    IYUV = 0x56555949u,  /**< Planar mode: Y + U + V  (3 planes) */
        /* SDL_DEFINE_PIXELFOURCC('I', 'Y', 'U', 'V'), */
    YUY2 = 0x32595559u,  /**< Packed mode: Y0+U0+Y1+V0 (1 plane) */
        /* SDL_DEFINE_PIXELFOURCC('Y', 'U', 'Y', '2'), */
    UYVY = 0x59565955u,  /**< Packed mode: U0+Y0+V0+Y1 (1 plane) */
        /* SDL_DEFINE_PIXELFOURCC('U', 'Y', 'V', 'Y'), */
    YVYU = 0x55595659u,  /**< Packed mode: Y0+V0+Y1+U0 (1 plane) */
        /* SDL_DEFINE_PIXELFOURCC('Y', 'V', 'Y', 'U'), */
    NV12 = 0x3231564eu,  /**< Planar mode: Y + U/V interleaved  (2 planes) */
        /* SDL_DEFINE_PIXELFOURCC('N', 'V', '1', '2'), */
    NV21 = 0x3132564eu,  /**< Planar mode: Y + V/U interleaved  (2 planes) */
        /* SDL_DEFINE_PIXELFOURCC('N', 'V', '2', '1'), */
    P010 = 0x30313050u,  /**< Planar mode: Y + U/V interleaved  (2 planes) */
        /* SDL_DEFINE_PIXELFOURCC('P', '0', '1', '0'), */
    EXTERNAL_OES = 0x2053454fu,  /**< Android video texture format */
        /* SDL_DEFINE_PIXELFOURCC('O', 'E', 'S', ' ') */

    MJPG = 0x47504a4du,  /**< Motion JPEG */
        /* SDL_DEFINE_PIXELFOURCC('M', 'J', 'P', 'G') */

    /* Aliases for RGBA byte arrays of color data, for the current platform */
::LINE::     #if SDL_BYTEORDER == SDL_BIG_ENDIAN
::LINE::     SDL_PIXELFORMAT_RGBA32 = SDL_PIXELFORMAT_RGBA8888,
::LINE::     SDL_PIXELFORMAT_ARGB32 = SDL_PIXELFORMAT_ARGB8888,
::LINE::     SDL_PIXELFORMAT_BGRA32 = SDL_PIXELFORMAT_BGRA8888,
::LINE::     SDL_PIXELFORMAT_ABGR32 = SDL_PIXELFORMAT_ABGR8888,
::LINE::     SDL_PIXELFORMAT_RGBX32 = SDL_PIXELFORMAT_RGBX8888,
::LINE::     SDL_PIXELFORMAT_XRGB32 = SDL_PIXELFORMAT_XRGB8888,
::LINE::     SDL_PIXELFORMAT_BGRX32 = SDL_PIXELFORMAT_BGRX8888,
::LINE::     SDL_PIXELFORMAT_XBGR32 = SDL_PIXELFORMAT_XBGR8888
::LINE::     #else
::LINE::     SDL_PIXELFORMAT_RGBA32 = SDL_PIXELFORMAT_ABGR8888,
::LINE::     SDL_PIXELFORMAT_ARGB32 = SDL_PIXELFORMAT_BGRA8888,
::LINE::     SDL_PIXELFORMAT_BGRA32 = SDL_PIXELFORMAT_ARGB8888,
::LINE::     SDL_PIXELFORMAT_ABGR32 = SDL_PIXELFORMAT_RGBA8888,
::LINE::     SDL_PIXELFORMAT_RGBX32 = SDL_PIXELFORMAT_XBGR8888,
::LINE::     SDL_PIXELFORMAT_XRGB32 = SDL_PIXELFORMAT_BGRX8888,
::LINE::     SDL_PIXELFORMAT_BGRX32 = SDL_PIXELFORMAT_XRGB8888,
::LINE::     SDL_PIXELFORMAT_XBGR32 = SDL_PIXELFORMAT_RGBX8888
::LINE::     #endif
}

enum SDL_ColorType : const CInt
{
    UNKNOWN = 0,
    RGB = 1,
    YCBCR = 2,
}

enum SDL_ColorRange : const CInt
{
    UNKNOWN = 0,
    LIMITED = 1,  /**< Narrow range, e.g. 16-235 for 8-bit RGB and luma, and 16-240 for 8-bit chroma */
    FULL = 2,  /**< Full range, e.g. 0-255 for 8-bit RGB and luma, and 1-255 for 8-bit chroma */
}

enum SDL_ColorPrimaries : const CInt
{
    UNKNOWN = 0,
    BT709 = 1,  /**< ITU-R BT.709-6 */
    UNSPECIFIED = 2,
    BT470M = 4,  /**< ITU-R BT.470-6 System M */
    BT470BG = 5,  /**< ITU-R BT.470-6 System B, G / ITU-R BT.601-7 625 */
    BT601 = 6,  /**< ITU-R BT.601-7 525, SMPTE 170M */
    SMPTE240 = 7,  /**< SMPTE 240M, functionally the same as SDL_COLOR_PRIMARIES_BT601 */
    GENERIC_FILM = 8,  /**< Generic film (color filters using Illuminant C) */
    BT2020 = 9,  /**< ITU-R BT.2020-2 / ITU-R BT.2100-0 */
    XYZ = 10,  /**< SMPTE ST 428-1 */
    SMPTE431 = 11,  /**< SMPTE RP 431-2 */
    SMPTE432 = 12,  /**< SMPTE EG 432-1 / DCI P3 */
    EBU3213 = 22,  /**< EBU Tech. 3213-E */
    CUSTOM = 31,
}

enum SDL_TransferCharacteristics : const CInt
{
    UNKNOWN = 0,
    BT709 = 1,  /**< Rec. ITU-R BT.709-6 / ITU-R BT1361 */
    UNSPECIFIED = 2,
    GAMMA22 = 4,  /**< ITU-R BT.470-6 System M / ITU-R BT1700 625 PAL & SECAM */
    GAMMA28 = 5,  /**< ITU-R BT.470-6 System B, G */
    BT601 = 6,  /**< SMPTE ST 170M / ITU-R BT.601-7 525 or 625 */
    SMPTE240 = 7,  /**< SMPTE ST 240M */
    LINEAR = 8,
    LOG100 = 9,
    LOG100_SQRT10 = 10,
    IEC61966 = 11,  /**< IEC 61966-2-4 */
    BT1361 = 12,  /**< ITU-R BT1361 Extended Colour Gamut */
    SRGB = 13,  /**< IEC 61966-2-1 (sRGB or sYCC) */
    BT2020_10BIT = 14,  /**< ITU-R BT2020 for 10-bit system */
    BT2020_12BIT = 15,  /**< ITU-R BT2020 for 12-bit system */
    PQ = 16,  /**< SMPTE ST 2084 for 10-, 12-, 14- and 16-bit systems */
    SMPTE428 = 17,  /**< SMPTE ST 428-1 */
    HLG = 18,  /**< ARIB STD-B67, known as "hybrid log-gamma" (HLG) */
    CUSTOM = 31,
}

enum SDL_MatrixCoefficients : const CInt
{
    IDENTITY = 0,
    BT709 = 1,  /**< ITU-R BT.709-6 */
    UNSPECIFIED = 2,
    FCC = 4,  /**< US FCC Title 47 */
    BT470BG = 5,  /**< ITU-R BT.470-6 System B, G / ITU-R BT.601-7 625, functionally the same as SDL_MATRIX_COEFFICIENTS_BT601 */
    BT601 = 6,  /**< ITU-R BT.601-7 525 */
    SMPTE240 = 7,  /**< SMPTE 240M */
    YCGCO = 8,
    BT2020_NCL = 9,  /**< ITU-R BT.2020-2 non-constant luminance */
    BT2020_CL = 10,  /**< ITU-R BT.2020-2 constant luminance */
    SMPTE2085 = 11,  /**< SMPTE ST 2085 */
    CHROMA_DERIVED_NCL = 12,
    CHROMA_DERIVED_CL = 13,
    ICTCP = 14,  /**< ITU-R BT.2100-0 ICTCP */
    CUSTOM = 31,
}

enum SDL_ChromaLocation : const CInt
{
    NONE = 0,  /**< RGB, no chroma sampling */
    LEFT = 1,  /**< In MPEG-2, MPEG-4, and AVC, Cb and Cr are taken on midpoint of the left-edge of the 2x2 square. In other words, they have the same horizontal location as the top-left pixel, but is shifted one-half pixel down vertically. */
    CENTER = 2,  /**< In JPEG/JFIF, H.261, and MPEG-1, Cb and Cr are taken at the center of the 2x2 square. In other words, they are offset one-half pixel to the right and one-half pixel down compared to the top-left pixel. */
    TOPLEFT = 3,  /**< In HEVC for BT.2020 and BT.2100 content (in particular on Blu-rays), Cb and Cr are sampled at the same location as the group's top-left Y pixel ("co-sited", "co-located"). */
}


/* Colorspace definition */

::LINE:: #define SDL_DEFINE_COLORSPACE(type, range, primaries, transfer, matrix, chroma) \
::LINE::     (((Uint32)(type) << 28) | ((Uint32)(range) << 24) | ((Uint32)(chroma) << 20) | \
::LINE::     ((Uint32)(primaries) << 10) | ((Uint32)(transfer) << 5) | ((Uint32)(matrix) << 0))

::LINE:: #define SDL_COLORSPACETYPE(cspace)       (SDL_ColorType)(((cspace) >> 28) & 0x0F)

::LINE:: #define SDL_COLORSPACERANGE(cspace)      (SDL_ColorRange)(((cspace) >> 24) & 0x0F)

::LINE:: #define SDL_COLORSPACECHROMA(cspace)     (SDL_ChromaLocation)(((cspace) >> 20) & 0x0F)

::LINE:: #define SDL_COLORSPACEPRIMARIES(cspace)  (SDL_ColorPrimaries)(((cspace) >> 10) & 0x1F)

::LINE:: #define SDL_COLORSPACETRANSFER(cspace)   (SDL_TransferCharacteristics)(((cspace) >> 5) & 0x1F)

::LINE:: #define SDL_COLORSPACEMATRIX(cspace)     (SDL_MatrixCoefficients)((cspace) & 0x1F)

::LINE:: #define SDL_ISCOLORSPACE_MATRIX_BT601(cspace)        (SDL_COLORSPACEMATRIX(cspace) == SDL_MATRIX_COEFFICIENTS_BT601 || SDL_COLORSPACEMATRIX(cspace) == SDL_MATRIX_COEFFICIENTS_BT470BG)

::LINE:: #define SDL_ISCOLORSPACE_MATRIX_BT709(cspace)        (SDL_COLORSPACEMATRIX(cspace) == SDL_MATRIX_COEFFICIENTS_BT709)

::LINE:: #define SDL_ISCOLORSPACE_MATRIX_BT2020_NCL(cspace)   (SDL_COLORSPACEMATRIX(cspace) == SDL_MATRIX_COEFFICIENTS_BT2020_NCL)

::LINE:: #define SDL_ISCOLORSPACE_LIMITED_RANGE(cspace)       (SDL_COLORSPACERANGE(cspace) != SDL_COLOR_RANGE_FULL)

::LINE:: #define SDL_ISCOLORSPACE_FULL_RANGE(cspace)          (SDL_COLORSPACERANGE(cspace) == SDL_COLOR_RANGE_FULL)

enum SDL_Colorspace : const CInt
{
    UNKNOWN = 0,

    /* sRGB is a gamma corrected colorspace, and the default colorspace for SDL rendering and 8-bit RGB surfaces */
    SRGB = 0x120005a0u,  /**< Equivalent to DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709 */
        /* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_RGB,
                                 SDL_COLOR_RANGE_FULL,
                                 SDL_COLOR_PRIMARIES_BT709,
                                 SDL_TRANSFER_CHARACTERISTICS_SRGB,
                                 SDL_MATRIX_COEFFICIENTS_IDENTITY,
                                 SDL_CHROMA_LOCATION_NONE), */

    /* This is a linear colorspace and the default colorspace for floating point surfaces. On Windows this is the scRGB colorspace, and on Apple platforms this is kCGColorSpaceExtendedLinearSRGB for EDR content */
    SRGB_LINEAR = 0x12000500u,  /**< Equivalent to DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709  */
        /* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_RGB,
                                 SDL_COLOR_RANGE_FULL,
                                 SDL_COLOR_PRIMARIES_BT709,
                                 SDL_TRANSFER_CHARACTERISTICS_LINEAR,
                                 SDL_MATRIX_COEFFICIENTS_IDENTITY,
                                 SDL_CHROMA_LOCATION_NONE), */

    /* HDR10 is a non-linear HDR colorspace and the default colorspace for 10-bit surfaces */
    HDR10 = 0x12002600u,  /**< Equivalent to DXGI_COLOR_SPACE_RGB_FULL_G2084_NONE_P2020  */
        /* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_RGB,
                                 SDL_COLOR_RANGE_FULL,
                                 SDL_COLOR_PRIMARIES_BT2020,
                                 SDL_TRANSFER_CHARACTERISTICS_PQ,
                                 SDL_MATRIX_COEFFICIENTS_IDENTITY,
                                 SDL_CHROMA_LOCATION_NONE), */

    JPEG = 0x220004c6u,  /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_FULL_G22_NONE_P709_X601 */
        /* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_YCBCR,
                                 SDL_COLOR_RANGE_FULL,
                                 SDL_COLOR_PRIMARIES_BT709,
                                 SDL_TRANSFER_CHARACTERISTICS_BT601,
                                 SDL_MATRIX_COEFFICIENTS_BT601,
                                 SDL_CHROMA_LOCATION_NONE), */

    BT601_LIMITED = 0x211018c6u,  /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601 */
        /* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_YCBCR,
                                 SDL_COLOR_RANGE_LIMITED,
                                 SDL_COLOR_PRIMARIES_BT601,
                                 SDL_TRANSFER_CHARACTERISTICS_BT601,
                                 SDL_MATRIX_COEFFICIENTS_BT601,
                                 SDL_CHROMA_LOCATION_LEFT), */

    BT601_FULL = 0x221018c6u,  /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601 */
        /* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_YCBCR,
                                 SDL_COLOR_RANGE_FULL,
                                 SDL_COLOR_PRIMARIES_BT601,
                                 SDL_TRANSFER_CHARACTERISTICS_BT601,
                                 SDL_MATRIX_COEFFICIENTS_BT601,
                                 SDL_CHROMA_LOCATION_LEFT), */

    BT709_LIMITED = 0x21100421u,  /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709 */
        /* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_YCBCR,
                                 SDL_COLOR_RANGE_LIMITED,
                                 SDL_COLOR_PRIMARIES_BT709,
                                 SDL_TRANSFER_CHARACTERISTICS_BT709,
                                 SDL_MATRIX_COEFFICIENTS_BT709,
                                 SDL_CHROMA_LOCATION_LEFT), */

    BT709_FULL = 0x22100421u,  /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709 */
        /* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_YCBCR,
                                 SDL_COLOR_RANGE_FULL,
                                 SDL_COLOR_PRIMARIES_BT709,
                                 SDL_TRANSFER_CHARACTERISTICS_BT709,
                                 SDL_MATRIX_COEFFICIENTS_BT709,
                                 SDL_CHROMA_LOCATION_LEFT), */

    BT2020_LIMITED = 0x21102609u,  /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P2020 */
        /* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_YCBCR,
                                 SDL_COLOR_RANGE_LIMITED,
                                 SDL_COLOR_PRIMARIES_BT2020,
                                 SDL_TRANSFER_CHARACTERISTICS_PQ,
                                 SDL_MATRIX_COEFFICIENTS_BT2020_NCL,
                                 SDL_CHROMA_LOCATION_LEFT), */

    BT2020_FULL = 0x22102609u,  /**< Equivalent to DXGI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P2020 */
        /* SDL_DEFINE_COLORSPACE(SDL_COLOR_TYPE_YCBCR,
                                 SDL_COLOR_RANGE_FULL,
                                 SDL_COLOR_PRIMARIES_BT2020,
                                 SDL_TRANSFER_CHARACTERISTICS_PQ,
                                 SDL_MATRIX_COEFFICIENTS_BT2020_NCL,
                                 SDL_CHROMA_LOCATION_LEFT), */

    RGB_DEFAULT = SDL_COLORSPACE_SRGB,  /**< The default colorspace for RGB surfaces if no colorspace is specified */
    YUV_DEFAULT = SDL_COLORSPACE_BT601_LIMITED,  /**< The default colorspace for YUV surfaces if no colorspace is specified */
}

struct SDL_Color
{
    char r;
    char g;
    char b;
    char a;
}

struct SDL_FColor
{
    float r;
    float g;
    float b;
    float a;
}

struct SDL_Palette
{
    CInt ncolors;  /**< number of elements in `colors`. */
    SDL_Color* colors;  /**< an array of colors, `ncolors` long. */
    uint version;  /**< internal use only, do not touch. */
    CInt refcount;  /**< internal use only, do not touch. */
}

struct SDL_PixelFormatDetails
{
    SDL_PixelFormat format;
    char bits_per_pixel;
    char bytes_per_pixel;
    char[2] padding;
    uint Rmask;
    uint Gmask;
    uint Bmask;
    uint Amask;
    char Rbits;
    char Gbits;
    char Bbits;
    char Abits;
    char Rshift;
    char Gshift;
    char Bshift;
    char Ashift;
}

extern fn ZString get_pixel_format_name(SDL_PixelFormat format) @extern("SDL_GetPixelFormatName");

extern fn bool get_masks_for_pixel_format(SDL_PixelFormat format, CInt* bpp, uint* Rmask, uint* Gmask, uint* Bmask, uint* Amask) @extern("SDL_GetMasksForPixelFormat");

extern fn SDL_PixelFormat get_pixel_format_for_masks(CInt bpp, uint Rmask, uint Gmask, uint Bmask, uint Amask) @extern("SDL_GetPixelFormatForMasks");

extern fn SDL_PixelFormatDetails* get_pixel_format_details(SDL_PixelFormat format) @extern("SDL_GetPixelFormatDetails");

extern fn SDL_Palette* create_palette(CInt ncolors) @extern("SDL_CreatePalette");

extern fn bool set_palette_colors(SDL_Palette* palette, SDL_Color* colors, CInt firstcolor, CInt ncolors) @extern("SDL_SetPaletteColors");

extern fn void destroy_palette(SDL_Palette* palette) @extern("SDL_DestroyPalette");

extern fn uint map_rgb(SDL_PixelFormatDetails* format, SDL_Palette* palette, char r, char g, char b) @extern("SDL_MapRGB");

extern fn uint map_rgba(SDL_PixelFormatDetails* format, SDL_Palette* palette, char r, char g, char b, char a) @extern("SDL_MapRGBA");

extern fn void get_rgb(uint pixelvalue, SDL_PixelFormatDetails* format, SDL_Palette* palette, char* r, char* g, char* b) @extern("SDL_GetRGB");

extern fn void get_rgba(uint pixelvalue, SDL_PixelFormatDetails* format, SDL_Palette* palette, char* r, char* g, char* b, char* a) @extern("SDL_GetRGBA");


/* Ends C function definitions when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: }
::LINE:: #endif

::LINE:: #endif /* SDL_pixels_h_ */
