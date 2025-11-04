module sdl;

enum SDL_SurfaceFlags : const uint
{
    PREALLOCATED     = 0x00000001u, /**< Surface uses preallocated pixel memory */
    LOCK_NEEDED      = 0x00000002u, /**< Surface needs to be locked to access pixels */
    LOCKED           = 0x00000004u, /**< Surface is currently locked */
    SIMD_ALIGNED     = 0x00000008u, /**< Surface uses pixel memory allocated with SDL_aligned_alloc() */
}

fn bool mustlock(SDL_Surface* s)
{
    return (s.flags & SDL_SurfaceFlags.LOCK_NEEDED) == SDL_SurfaceFlags.LOCK_NEEDED;
}

enum SDL_ScaleMode : const CInt
{
    INVALID = -1,
    NEAREST,  /**< nearest pixel sampling */
    LINEAR,  /**< linear filtering */
    PIXELART,  /**< nearest pixel sampling with improved scaling for pixel art, available since SDL 3.4.0 */
}

enum SDL_FlipMode : const CInt
{
    NONE,  /**< Do not flip */
    HORIZONTAL,  /**< flip horizontally */
    VERTICAL,  /**< flip vertically */
    HORIZONTAL_AND_VERTICAL = SDL_FlipMode.HORIZONTAL | SDL_FlipMode.VERTICAL,  /**< flip horizontally and vertically (not a diagonal flip) */
}

struct SDL_Surface
{
    SDL_SurfaceFlags flags;     /**< The flags of the surface, read-only */
    SDL_PixelFormat format;     /**< The format of the surface, read-only */
    CInt w;                     /**< The width of the surface, read-only. */
    CInt h;                     /**< The height of the surface, read-only. */
    CInt pitch;                 /**< The distance in bytes between rows of pixels, read-only */
    void* pixels;               /**< A pointer to the pixels of the surface, the pixels are writeable if non-NULL */

    CInt refcount;              /**< Application reference count, used when freeing surface */

    void* reserved;             /**< Reserved for internal use */
}

extern fn SDL_Surface* create_surface(CInt width, CInt height, SDL_PixelFormat format) @extern("SDL_CreateSurface");

extern fn SDL_Surface* create_surface_from(CInt width, CInt height, SDL_PixelFormat format, void* pixels, CInt pitch) @extern("SDL_CreateSurfaceFrom");

extern fn void destroy_surface(SDL_Surface* surface) @extern("SDL_DestroySurface");

extern fn SDL_PropertiesID get_surface_properties(SDL_Surface* surface) @extern("SDL_GetSurfaceProperties");

const PROP_SURFACE_SDR_WHITE_POINT_FLOAT               = "SDL.surface.SDR_white_point";
const PROP_SURFACE_HDR_HEADROOM_FLOAT                  = "SDL.surface.HDR_headroom";
const PROP_SURFACE_TONEMAP_OPERATOR_STRING             = "SDL.surface.tonemap";
const PROP_SURFACE_HOTSPOT_X_NUMBER                    = "SDL.surface.hotspot.x";
const PROP_SURFACE_HOTSPOT_Y_NUMBER                    = "SDL.surface.hotspot.y";

extern fn bool set_surface_colorspace(SDL_Surface* surface, SDL_Colorspace colorspace) @extern("SDL_SetSurfaceColorspace");

extern fn SDL_Colorspace get_surface_colorspace(SDL_Surface* surface) @extern("SDL_GetSurfaceColorspace");

extern fn SDL_Palette* create_surface_palette(SDL_Surface* surface) @extern("SDL_CreateSurfacePalette");

extern fn bool set_surface_palette(SDL_Surface* surface, SDL_Palette* palette) @extern("SDL_SetSurfacePalette");

extern fn SDL_Palette* get_surface_palette(SDL_Surface* surface) @extern("SDL_GetSurfacePalette");

extern fn bool add_surface_alternate_image(SDL_Surface* surface, SDL_Surface* image) @extern("SDL_AddSurfaceAlternateImage");

extern fn bool surface_has_alternate_images(SDL_Surface* surface) @extern("SDL_SurfaceHasAlternateImages");

extern fn SDL_Surface** get_surface_images(SDL_Surface* surface, CInt* count) @extern("SDL_GetSurfaceImages");

extern fn void remove_surface_alternate_images(SDL_Surface* surface) @extern("SDL_RemoveSurfaceAlternateImages");

extern fn bool lock_surface(SDL_Surface* surface) @extern("SDL_LockSurface");

extern fn void unlock_surface(SDL_Surface* surface) @extern("SDL_UnlockSurface");

extern fn SDL_Surface* load_bmp_io(SDL_IOStream* src, bool closeio) @extern("SDL_LoadBMP_IO");

extern fn SDL_Surface* load_bmp(ZString file) @extern("SDL_LoadBMP");

extern fn bool save_bmp_io(SDL_Surface* surface, SDL_IOStream* dst, bool closeio) @extern("SDL_SaveBMP_IO");

extern fn bool save_bmp(SDL_Surface* surface, ZString file) @extern("SDL_SaveBMP");

extern fn SDL_Surface* load_png_io(SDL_IOStream* src, bool closeio) @extern("SDL_LoadPNG_IO");

extern fn SDL_Surface* load_png(ZString file) @extern("SDL_LoadPNG");

extern fn bool save_png_io(SDL_Surface* surface, SDL_IOStream* dst, bool closeio) @extern("SDL_SavePNG_IO");

extern fn bool save_png(SDL_Surface* surface, ZString file) @extern("SDL_SavePNG");

extern fn bool set_surface_rle(SDL_Surface* surface, bool enabled) @extern("SDL_SetSurfaceRLE");

extern fn bool surface_has_rle(SDL_Surface* surface) @extern("SDL_SurfaceHasRLE");

extern fn bool set_surface_color_key(SDL_Surface* surface, bool enabled, uint key) @extern("SDL_SetSurfaceColorKey");

extern fn bool surface_has_color_key(SDL_Surface* surface) @extern("SDL_SurfaceHasColorKey");

extern fn bool get_surface_color_key(SDL_Surface* surface, uint* key) @extern("SDL_GetSurfaceColorKey");

extern fn bool set_surface_color_mod(SDL_Surface* surface, char r, char g, char b) @extern("SDL_SetSurfaceColorMod");


extern fn bool get_surface_color_mod(SDL_Surface* surface, char* r, char* g, char* b) @extern("SDL_GetSurfaceColorMod");

extern fn bool set_surface_alpha_mod(SDL_Surface* surface, char alpha) @extern("SDL_SetSurfaceAlphaMod");

extern fn bool get_surface_alpha_mod(SDL_Surface* surface, char* alpha) @extern("SDL_GetSurfaceAlphaMod");

extern fn bool set_surface_blend_mode(SDL_Surface* surface, SDL_BlendMode blendMode) @extern("SDL_SetSurfaceBlendMode");

extern fn bool get_surface_blend_mode(SDL_Surface* surface, SDL_BlendMode* blendMode) @extern("SDL_GetSurfaceBlendMode");

extern fn bool set_surface_clip_rect(SDL_Surface* surface, SDL_Rect* rect) @extern("SDL_SetSurfaceClipRect");

extern fn bool get_surface_clip_rect(SDL_Surface* surface, SDL_Rect* rect) @extern("SDL_GetSurfaceClipRect");

extern fn bool flip_surface(SDL_Surface* surface, SDL_FlipMode flip) @extern("SDL_FlipSurface");

extern fn SDL_Surface* rotate_surface(SDL_Surface* surface, float angle) @extern("SDL_RotateSurface");

extern fn SDL_Surface* duplicate_surface(SDL_Surface* surface) @extern("SDL_DuplicateSurface");

extern fn SDL_Surface* scale_surface(SDL_Surface* surface, CInt width, CInt height, SDL_ScaleMode scaleMode) @extern("SDL_ScaleSurface");

extern fn SDL_Surface* convert_surface(SDL_Surface* surface, SDL_PixelFormat format) @extern("SDL_ConvertSurface");

extern fn SDL_Surface* convert_surface_and_colorspace(SDL_Surface* surface, SDL_PixelFormat format, SDL_Palette* palette, SDL_Colorspace colorspace, SDL_PropertiesID props) @extern("SDL_ConvertSurfaceAndColorspace");

extern fn bool convert_pixels(CInt width, CInt height, SDL_PixelFormat src_format, void* src, CInt src_pitch, SDL_PixelFormat dst_format, void* dst, CInt dst_pitch) @extern("SDL_ConvertPixels");

extern fn bool convert_pixels_and_colorspace(CInt width, CInt height, SDL_PixelFormat src_format, SDL_Colorspace src_colorspace, SDL_PropertiesID src_properties, void* src, CInt src_pitch, SDL_PixelFormat dst_format, SDL_Colorspace dst_colorspace, SDL_PropertiesID dst_properties, void* dst, CInt dst_pitch) @extern("SDL_ConvertPixelsAndColorspace");

extern fn bool premultiply_alpha(CInt width, CInt height, SDL_PixelFormat src_format, void* src, CInt src_pitch, SDL_PixelFormat dst_format, void* dst, CInt dst_pitch, bool linear) @extern("SDL_PremultiplyAlpha");

extern fn bool premultiply_surface_alpha(SDL_Surface* surface, bool linear) @extern("SDL_PremultiplySurfaceAlpha");

extern fn bool clear_surface(SDL_Surface* surface, float r, float g, float b, float a) @extern("SDL_ClearSurface");

extern fn bool fill_surface_rect(SDL_Surface* dst, SDL_Rect* rect, uint color) @extern("SDL_FillSurfaceRect");

extern fn bool fill_surface_rects(SDL_Surface* dst, SDL_Rect* rects, CInt count, uint color) @extern("SDL_FillSurfaceRects");

extern fn bool blit_surface(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect) @extern("SDL_BlitSurface");

extern fn bool blit_surface_unchecked(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect) @extern("SDL_BlitSurfaceUnchecked");

extern fn bool blit_surface_scaled(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect, SDL_ScaleMode scaleMode) @extern("SDL_BlitSurfaceScaled");

extern fn bool blit_surface_unchecked_scaled(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect, SDL_ScaleMode scaleMode) @extern("SDL_BlitSurfaceUncheckedScaled");

extern fn bool stretch_surface(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect, SDL_ScaleMode scaleMode) @extern("SDL_StretchSurface");

extern fn bool blit_surface_tiled(SDL_Surface* src, SDL_Rect* srcrect, SDL_Surface* dst, SDL_Rect* dstrect) @extern("SDL_BlitSurfaceTiled");

extern fn bool blit_surface_tiled_with_scale(SDL_Surface* src, SDL_Rect* srcrect, float scale, SDL_ScaleMode scaleMode, SDL_Surface* dst, SDL_Rect* dstrect) @extern("SDL_BlitSurfaceTiledWithScale");

extern fn bool blit_surface9grid(SDL_Surface* src, SDL_Rect* srcrect, CInt left_width, CInt right_width, CInt top_height, CInt bottom_height, float scale, SDL_ScaleMode scaleMode, SDL_Surface* dst, SDL_Rect* dstrect) @extern("SDL_BlitSurface9Grid");

extern fn uint map_surface_rgb(SDL_Surface* surface, char r, char g, char b) @extern("SDL_MapSurfaceRGB");

extern fn uint map_surface_rgba(SDL_Surface* surface, char r, char g, char b, char a) @extern("SDL_MapSurfaceRGBA");

extern fn bool read_surface_pixel(SDL_Surface* surface, CInt x, CInt y, char* r, char* g, char* b, char* a) @extern("SDL_ReadSurfacePixel");

extern fn bool read_surface_pixel_float(SDL_Surface* surface, CInt x, CInt y, float* r, float* g, float* b, float* a) @extern("SDL_ReadSurfacePixelFloat");

extern fn bool write_surface_pixel(SDL_Surface* surface, CInt x, CInt y, char r, char g, char b, char a) @extern("SDL_WriteSurfacePixel");

extern fn bool write_surface_pixel_float(SDL_Surface* surface, CInt x, CInt y, float r, float g, float b, float a) @extern("SDL_WriteSurfacePixelFloat");
