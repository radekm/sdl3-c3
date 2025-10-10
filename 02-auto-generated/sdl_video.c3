module sdl;


::LINE:: #ifndef SDL_video_h_
::LINE:: #define SDL_video_h_


/* Set up for C function definitions, even when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: extern "C" {
::LINE:: #endif

typedef SDL_DisplayID = uint;

typedef SDL_WindowID = uint;

/* Global video properties... */

const PROP_GLOBAL_VIDEO_WAYLAND_WL_DISPLAY_POINTER  = "SDL.video.wayland.wl_display";

enum SDL_SystemTheme : const CInt
{
    UNKNOWN,   /**< Unknown system theme */
    LIGHT,     /**< Light colored system theme */
    DARK       /**< Dark colored system theme */
}


struct SDL_DisplayMode
{
    SDL_DisplayID displayID;         /**< the display this mode is associated with */
    SDL_PixelFormat format;          /**< pixel format */
    CInt w;                          /**< width */
    CInt h;                          /**< height */
    float pixel_density;             /**< scale converting size to pixels (e.g. a 1920x1080 mode with 2.0 scale would have 3840x2160 pixels) */
    float refresh_rate;              /**< refresh rate (or 0.0f for unspecified) */
    CInt refresh_rate_numerator;     /**< precise refresh rate numerator (or 0 for unspecified) */
    CInt refresh_rate_denominator;   /**< precise refresh rate denominator */
 
    SDL_DisplayModeData* internal;   /**< Private */
 
}

enum SDL_DisplayOrientation : const CInt
{
    UNKNOWN,            /**< The display orientation can't be determined */
    LANDSCAPE,          /**< The display is in landscape mode, with the right side up, relative to portrait mode */
    LANDSCAPE_FLIPPED,  /**< The display is in landscape mode, with the left side up, relative to portrait mode */
    PORTRAIT,           /**< The display is in portrait mode */
    PORTRAIT_FLIPPED    /**< The display is in portrait mode, upside down */
}


enum SDL_WindowFlags : const ulong
{
    FULLSCREEN            = 0x0000000000000001,    /**< window is in fullscreen mode */
    OPENGL                = 0x0000000000000002,    /**< window usable with OpenGL context */
    OCCLUDED              = 0x0000000000000004,    /**< window is occluded */
    HIDDEN                = 0x0000000000000008,    /**< window is neither mapped onto the desktop nor shown in the taskbar/dock/window list; SDL_ShowWindow() is required for it to become visible */
    BORDERLESS            = 0x0000000000000010,    /**< no window decoration */
    RESIZABLE             = 0x0000000000000020,    /**< window can be resized */
    MINIMIZED             = 0x0000000000000040,    /**< window is minimized */
    MAXIMIZED             = 0x0000000000000080,    /**< window is maximized */
    MOUSE_GRABBED         = 0x0000000000000100,    /**< window has grabbed mouse input */
    INPUT_FOCUS           = 0x0000000000000200,    /**< window has input focus */
    MOUSE_FOCUS           = 0x0000000000000400,    /**< window has mouse focus */
    EXTERNAL              = 0x0000000000000800,    /**< window not created by SDL */
    MODAL                 = 0x0000000000001000,    /**< window is modal */
    HIGH_PIXEL_DENSITY    = 0x0000000000002000,    /**< window uses high pixel density back buffer if possible */
    MOUSE_CAPTURE         = 0x0000000000004000,    /**< window has mouse captured (unrelated to MOUSE_GRABBED) */
    MOUSE_RELATIVE_MODE   = 0x0000000000008000,    /**< window has relative mode enabled */
    ALWAYS_ON_TOP         = 0x0000000000010000,    /**< window should always be above others */
    UTILITY               = 0x0000000000020000,    /**< window should be treated as a utility window, not showing in the task bar and window list */
    TOOLTIP               = 0x0000000000040000,    /**< window should be treated as a tooltip and does not get mouse or keyboard focus, requires a parent window */
    POPUP_MENU            = 0x0000000000080000,    /**< window should be treated as a popup menu, requires a parent window */
    KEYBOARD_GRABBED      = 0x0000000000100000,    /**< window has grabbed keyboard input */
    VULKAN                = 0x0000000010000000,    /**< window usable for Vulkan surface */
    METAL                 = 0x0000000020000000,    /**< window usable for Metal view */
    TRANSPARENT           = 0x0000000040000000,    /**< window with transparent buffer */
    NOT_FOCUSABLE         = 0x0000000080000000,    /**< window should not be focusable */
}


::LINE:: #define SDL_WINDOWPOS_UNDEFINED_MASK    0x1FFF0000u

::LINE:: #define SDL_WINDOWPOS_UNDEFINED_DISPLAY(X)  (SDL_WINDOWPOS_UNDEFINED_MASK|(X))

::LINE:: #define SDL_WINDOWPOS_UNDEFINED         SDL_WINDOWPOS_UNDEFINED_DISPLAY(0)

::LINE:: #define SDL_WINDOWPOS_ISUNDEFINED(X)    (((X)&0xFFFF0000) == SDL_WINDOWPOS_UNDEFINED_MASK)

::LINE:: #define SDL_WINDOWPOS_CENTERED_MASK    0x2FFF0000u

::LINE:: #define SDL_WINDOWPOS_CENTERED_DISPLAY(X)  (SDL_WINDOWPOS_CENTERED_MASK|(X))

::LINE:: #define SDL_WINDOWPOS_CENTERED         SDL_WINDOWPOS_CENTERED_DISPLAY(0)

::LINE:: #define SDL_WINDOWPOS_ISCENTERED(X)    \
::LINE::             (((X)&0xFFFF0000) == SDL_WINDOWPOS_CENTERED_MASK)


enum SDL_FlashOperation : const CInt
{
    CANCEL,                   /**< Cancel any window flash state */
    BRIEFLY,                  /**< Flash the window briefly to get attention */
    UNTIL_FOCUSED             /**< Flash the window until it gets focus */
}

enum SDL_ProgressState : const CInt
{
    INVALID = -1,    /**< An invalid progress state indicating an error; check SDL_GetError() */
    NONE,            /**< No progress bar is shown */
    INDETERMINATE,   /**< The progress bar is shown in a indeterminate state */
    NORMAL,          /**< The progress bar is shown in a normal state */
    PAUSED,          /**< The progress bar is shown in a paused state */
    ERROR            /**< The progress bar is shown in a state indicating the application had an error */
}

::LINE:: typedef struct SDL_GLContextState *SDL_GLContext;

typedef SDL_EGLDisplay = void*;

typedef SDL_EGLConfig = void*;

typedef SDL_EGLSurface = void*;

typedef SDL_EGLAttrib = iptr;

typedef SDL_EGLint = CInt;

::LINE:: typedef SDL_EGLAttrib *(SDLCALL *SDL_EGLAttribArrayCallback)(void *userdata);

::LINE:: typedef SDL_EGLint *(SDLCALL *SDL_EGLIntArrayCallback)(void *userdata, SDL_EGLDisplay display, SDL_EGLConfig config);

enum SDL_GLAttr : const CInt
{
    RED_SIZE,                    /**< the minimum number of bits for the red channel of the color buffer; defaults to 8. */
    GREEN_SIZE,                  /**< the minimum number of bits for the green channel of the color buffer; defaults to 8. */
    BLUE_SIZE,                   /**< the minimum number of bits for the blue channel of the color buffer; defaults to 8. */
    ALPHA_SIZE,                  /**< the minimum number of bits for the alpha channel of the color buffer; defaults to 8. */
    BUFFER_SIZE,                 /**< the minimum number of bits for frame buffer size; defaults to 0. */
    DOUBLEBUFFER,                /**< whether the output is single or double buffered; defaults to double buffering on. */
    DEPTH_SIZE,                  /**< the minimum number of bits in the depth buffer; defaults to 16. */
    STENCIL_SIZE,                /**< the minimum number of bits in the stencil buffer; defaults to 0. */
    ACCUM_RED_SIZE,              /**< the minimum number of bits for the red channel of the accumulation buffer; defaults to 0. */
    ACCUM_GREEN_SIZE,            /**< the minimum number of bits for the green channel of the accumulation buffer; defaults to 0. */
    ACCUM_BLUE_SIZE,             /**< the minimum number of bits for the blue channel of the accumulation buffer; defaults to 0. */
    ACCUM_ALPHA_SIZE,            /**< the minimum number of bits for the alpha channel of the accumulation buffer; defaults to 0. */
    STEREO,                      /**< whether the output is stereo 3D; defaults to off. */
    MULTISAMPLEBUFFERS,          /**< the number of buffers used for multisample anti-aliasing; defaults to 0. */
    MULTISAMPLESAMPLES,          /**< the number of samples used around the current pixel used for multisample anti-aliasing. */
    ACCELERATED_VISUAL,          /**< set to 1 to require hardware acceleration, set to 0 to force software rendering; defaults to allow either. */
    RETAINED_BACKING,            /**< not used (deprecated). */
    CONTEXT_MAJOR_VERSION,       /**< OpenGL context major version. */
    CONTEXT_MINOR_VERSION,       /**< OpenGL context minor version. */
    CONTEXT_FLAGS,               /**< some combination of 0 or more of elements of the SDL_GLContextFlag enumeration; defaults to 0. */
    CONTEXT_PROFILE_MASK,        /**< type of GL context (Core, Compatibility, ES). See SDL_GLProfile; default value depends on platform. */
    SHARE_WITH_CURRENT_CONTEXT,  /**< OpenGL context sharing; defaults to 0. */
    FRAMEBUFFER_SRGB_CAPABLE,    /**< requests sRGB capable visual; defaults to 0. */
    CONTEXT_RELEASE_BEHAVIOR,    /**< sets context the release behavior. See SDL_GLContextReleaseFlag; defaults to FLUSH. */
    CONTEXT_RESET_NOTIFICATION,  /**< set context reset notification. See SDL_GLContextResetNotification; defaults to NO_NOTIFICATION. */
    CONTEXT_NO_ERROR,
    FLOATBUFFERS,
    EGL_PLATFORM
}

enum SDL_GLProfile : const uint
{
    CORE            = 0x0001,  /**< OpenGL Core Profile context */
    COMPATIBILITY   = 0x0002,  /**< OpenGL Compatibility Profile context */
    ES              = 0x0004,  /**< GLX_CONTEXT_ES2_PROFILE_BIT_EXT */
}


enum SDL_GLContextFlag : const uint
{
    DEBUG_FLAG               = 0x0001,
    FORWARD_COMPATIBLE_FLAG  = 0x0002,
    ROBUST_ACCESS_FLAG       = 0x0004,
    RESET_ISOLATION_FLAG     = 0x0008,
}


enum SDL_GLContextReleaseFlag : const uint
{
    BEHAVIOR_NONE    = 0x0000,
    BEHAVIOR_FLUSH   = 0x0001,
}


enum SDL_GLContextResetNotification : const uint
{
    NO_NOTIFICATION   = 0x0000,
    LOSE_CONTEXT      = 0x0001,
}


/* Function prototypes */

extern fn CInt get_num_video_drivers() @extern("SDL_GetNumVideoDrivers");

extern fn ZString get_video_driver(CInt index) @extern("SDL_GetVideoDriver");

extern fn ZString get_current_video_driver() @extern("SDL_GetCurrentVideoDriver");

extern fn SDL_SystemTheme get_system_theme() @extern("SDL_GetSystemTheme");

extern fn SDL_DisplayID* get_displays(CInt* count) @extern("SDL_GetDisplays");

extern fn SDL_DisplayID get_primary_display() @extern("SDL_GetPrimaryDisplay");

extern fn SDL_PropertiesID get_display_properties(SDL_DisplayID displayID) @extern("SDL_GetDisplayProperties");

const PROP_DISPLAY_HDR_ENABLED_BOOLEAN              = "SDL.display.HDR_enabled";
const PROP_DISPLAY_KMSDRM_PANEL_ORIENTATION_NUMBER  = "SDL.display.KMSDRM.panel_orientation";
const PROP_DISPLAY_WAYLAND_WL_OUTPUT_POINTER        = "SDL.display.wayland.wl_output";

extern fn ZString get_display_name(SDL_DisplayID displayID) @extern("SDL_GetDisplayName");

extern fn bool get_display_bounds(SDL_DisplayID displayID, SDL_Rect* rect) @extern("SDL_GetDisplayBounds");

extern fn bool get_display_usable_bounds(SDL_DisplayID displayID, SDL_Rect* rect) @extern("SDL_GetDisplayUsableBounds");

extern fn SDL_DisplayOrientation get_natural_display_orientation(SDL_DisplayID displayID) @extern("SDL_GetNaturalDisplayOrientation");

extern fn SDL_DisplayOrientation get_current_display_orientation(SDL_DisplayID displayID) @extern("SDL_GetCurrentDisplayOrientation");

extern fn float get_display_content_scale(SDL_DisplayID displayID) @extern("SDL_GetDisplayContentScale");

extern fn SDL_DisplayMode** get_fullscreen_display_modes(SDL_DisplayID displayID, CInt* count) @extern("SDL_GetFullscreenDisplayModes");

extern fn bool get_closest_fullscreen_display_mode(SDL_DisplayID displayID, CInt w, CInt h, float refresh_rate, bool include_high_density_modes, SDL_DisplayMode* closest) @extern("SDL_GetClosestFullscreenDisplayMode");

extern fn SDL_DisplayMode* get_desktop_display_mode(SDL_DisplayID displayID) @extern("SDL_GetDesktopDisplayMode");

extern fn SDL_DisplayMode* get_current_display_mode(SDL_DisplayID displayID) @extern("SDL_GetCurrentDisplayMode");

extern fn SDL_DisplayID get_display_for_point(SDL_Point* point) @extern("SDL_GetDisplayForPoint");

extern fn SDL_DisplayID get_display_for_rect(SDL_Rect* rect) @extern("SDL_GetDisplayForRect");

extern fn SDL_DisplayID get_display_for_window(SDL_Window* window) @extern("SDL_GetDisplayForWindow");

extern fn float get_window_pixel_density(SDL_Window* window) @extern("SDL_GetWindowPixelDensity");

extern fn float get_window_display_scale(SDL_Window* window) @extern("SDL_GetWindowDisplayScale");

extern fn bool set_window_fullscreen_mode(SDL_Window* window, SDL_DisplayMode* mode) @extern("SDL_SetWindowFullscreenMode");

extern fn SDL_DisplayMode* get_window_fullscreen_mode(SDL_Window* window) @extern("SDL_GetWindowFullscreenMode");

extern fn void* get_window_iccprofile(SDL_Window* window, usz* size) @extern("SDL_GetWindowICCProfile");

extern fn SDL_PixelFormat get_window_pixel_format(SDL_Window* window) @extern("SDL_GetWindowPixelFormat");

extern fn SDL_Window** get_windows(CInt* count) @extern("SDL_GetWindows");

extern fn SDL_Window* create_window(ZString title, CInt w, CInt h, SDL_WindowFlags flags) @extern("SDL_CreateWindow");

extern fn SDL_Window* create_popup_window(SDL_Window* parent, CInt offset_x, CInt offset_y, CInt w, CInt h, SDL_WindowFlags flags) @extern("SDL_CreatePopupWindow");

extern fn SDL_Window* create_window_with_properties(SDL_PropertiesID props) @extern("SDL_CreateWindowWithProperties");

const PROP_WINDOW_CREATE_ALWAYS_ON_TOP_BOOLEAN                = "SDL.window.create.always_on_top";
const PROP_WINDOW_CREATE_BORDERLESS_BOOLEAN                   = "SDL.window.create.borderless";
const PROP_WINDOW_CREATE_CONSTRAIN_POPUP_BOOLEAN              = "SDL.window.create.constrain_popup";
const PROP_WINDOW_CREATE_FOCUSABLE_BOOLEAN                    = "SDL.window.create.focusable";
const PROP_WINDOW_CREATE_EXTERNAL_GRAPHICS_CONTEXT_BOOLEAN    = "SDL.window.create.external_graphics_context";
const PROP_WINDOW_CREATE_FLAGS_NUMBER                         = "SDL.window.create.flags";
const PROP_WINDOW_CREATE_FULLSCREEN_BOOLEAN                   = "SDL.window.create.fullscreen";
const PROP_WINDOW_CREATE_HEIGHT_NUMBER                        = "SDL.window.create.height";
const PROP_WINDOW_CREATE_HIDDEN_BOOLEAN                       = "SDL.window.create.hidden";
const PROP_WINDOW_CREATE_HIGH_PIXEL_DENSITY_BOOLEAN           = "SDL.window.create.high_pixel_density";
const PROP_WINDOW_CREATE_MAXIMIZED_BOOLEAN                    = "SDL.window.create.maximized";
const PROP_WINDOW_CREATE_MENU_BOOLEAN                         = "SDL.window.create.menu";
const PROP_WINDOW_CREATE_METAL_BOOLEAN                        = "SDL.window.create.metal";
const PROP_WINDOW_CREATE_MINIMIZED_BOOLEAN                    = "SDL.window.create.minimized";
const PROP_WINDOW_CREATE_MODAL_BOOLEAN                        = "SDL.window.create.modal";
const PROP_WINDOW_CREATE_MOUSE_GRABBED_BOOLEAN                = "SDL.window.create.mouse_grabbed";
const PROP_WINDOW_CREATE_OPENGL_BOOLEAN                       = "SDL.window.create.opengl";
const PROP_WINDOW_CREATE_PARENT_POINTER                       = "SDL.window.create.parent";
const PROP_WINDOW_CREATE_RESIZABLE_BOOLEAN                    = "SDL.window.create.resizable";
const PROP_WINDOW_CREATE_TITLE_STRING                         = "SDL.window.create.title";
const PROP_WINDOW_CREATE_TRANSPARENT_BOOLEAN                  = "SDL.window.create.transparent";
const PROP_WINDOW_CREATE_TOOLTIP_BOOLEAN                      = "SDL.window.create.tooltip";
const PROP_WINDOW_CREATE_UTILITY_BOOLEAN                      = "SDL.window.create.utility";
const PROP_WINDOW_CREATE_VULKAN_BOOLEAN                       = "SDL.window.create.vulkan";
const PROP_WINDOW_CREATE_WIDTH_NUMBER                         = "SDL.window.create.width";
const PROP_WINDOW_CREATE_X_NUMBER                             = "SDL.window.create.x";
const PROP_WINDOW_CREATE_Y_NUMBER                             = "SDL.window.create.y";
const PROP_WINDOW_CREATE_COCOA_WINDOW_POINTER                 = "SDL.window.create.cocoa.window";
const PROP_WINDOW_CREATE_COCOA_VIEW_POINTER                   = "SDL.window.create.cocoa.view";
const PROP_WINDOW_CREATE_WAYLAND_SURFACE_ROLE_CUSTOM_BOOLEAN  = "SDL.window.create.wayland.surface_role_custom";
const PROP_WINDOW_CREATE_WAYLAND_CREATE_EGL_WINDOW_BOOLEAN    = "SDL.window.create.wayland.create_egl_window";
const PROP_WINDOW_CREATE_WAYLAND_WL_SURFACE_POINTER           = "SDL.window.create.wayland.wl_surface";
const PROP_WINDOW_CREATE_WIN32_HWND_POINTER                   = "SDL.window.create.win32.hwnd";
const PROP_WINDOW_CREATE_WIN32_PIXEL_FORMAT_HWND_POINTER      = "SDL.window.create.win32.pixel_format_hwnd";
const PROP_WINDOW_CREATE_X11_WINDOW_NUMBER                    = "SDL.window.create.x11.window";
const PROP_WINDOW_CREATE_EMSCRIPTEN_CANVAS_ID_STRING          = "SDL.window.create.emscripten.canvas_id";
const PROP_WINDOW_CREATE_EMSCRIPTEN_FILL_DOCUMENT_BOOLEAN     = "SDL.window.create.emscripten.fill_document";
const PROP_WINDOW_CREATE_EMSCRIPTEN_KEYBOARD_ELEMENT_STRING   = "SDL.window.create.emscripten.keyboard_element";

extern fn SDL_WindowID get_window_id(SDL_Window* window) @extern("SDL_GetWindowID");

extern fn SDL_Window* get_window_from_id(SDL_WindowID id) @extern("SDL_GetWindowFromID");

extern fn SDL_Window* get_window_parent(SDL_Window* window) @extern("SDL_GetWindowParent");

extern fn SDL_PropertiesID get_window_properties(SDL_Window* window) @extern("SDL_GetWindowProperties");

const PROP_WINDOW_SHAPE_POINTER                                = "SDL.window.shape";
const PROP_WINDOW_HDR_ENABLED_BOOLEAN                          = "SDL.window.HDR_enabled";
const PROP_WINDOW_SDR_WHITE_LEVEL_FLOAT                        = "SDL.window.SDR_white_level";
const PROP_WINDOW_HDR_HEADROOM_FLOAT                           = "SDL.window.HDR_headroom";
const PROP_WINDOW_ANDROID_WINDOW_POINTER                       = "SDL.window.android.window";
const PROP_WINDOW_ANDROID_SURFACE_POINTER                      = "SDL.window.android.surface";
const PROP_WINDOW_UIKIT_WINDOW_POINTER                         = "SDL.window.uikit.window";
const PROP_WINDOW_UIKIT_METAL_VIEW_TAG_NUMBER                  = "SDL.window.uikit.metal_view_tag";
const PROP_WINDOW_UIKIT_OPENGL_FRAMEBUFFER_NUMBER              = "SDL.window.uikit.opengl.framebuffer";
const PROP_WINDOW_UIKIT_OPENGL_RENDERBUFFER_NUMBER             = "SDL.window.uikit.opengl.renderbuffer";
const PROP_WINDOW_UIKIT_OPENGL_RESOLVE_FRAMEBUFFER_NUMBER      = "SDL.window.uikit.opengl.resolve_framebuffer";
const PROP_WINDOW_KMSDRM_DEVICE_INDEX_NUMBER                   = "SDL.window.kmsdrm.dev_index";
const PROP_WINDOW_KMSDRM_DRM_FD_NUMBER                         = "SDL.window.kmsdrm.drm_fd";
const PROP_WINDOW_KMSDRM_GBM_DEVICE_POINTER                    = "SDL.window.kmsdrm.gbm_dev";
const PROP_WINDOW_COCOA_WINDOW_POINTER                         = "SDL.window.cocoa.window";
const PROP_WINDOW_COCOA_METAL_VIEW_TAG_NUMBER                  = "SDL.window.cocoa.metal_view_tag";
const PROP_WINDOW_OPENVR_OVERLAY_ID_NUMBER                     = "SDL.window.openvr.overlay_id";
const PROP_WINDOW_VIVANTE_DISPLAY_POINTER                      = "SDL.window.vivante.display";
const PROP_WINDOW_VIVANTE_WINDOW_POINTER                       = "SDL.window.vivante.window";
const PROP_WINDOW_VIVANTE_SURFACE_POINTER                      = "SDL.window.vivante.surface";
const PROP_WINDOW_WIN32_HWND_POINTER                           = "SDL.window.win32.hwnd";
const PROP_WINDOW_WIN32_HDC_POINTER                            = "SDL.window.win32.hdc";
const PROP_WINDOW_WIN32_INSTANCE_POINTER                       = "SDL.window.win32.instance";
const PROP_WINDOW_WAYLAND_DISPLAY_POINTER                      = "SDL.window.wayland.display";
const PROP_WINDOW_WAYLAND_SURFACE_POINTER                      = "SDL.window.wayland.surface";
const PROP_WINDOW_WAYLAND_VIEWPORT_POINTER                     = "SDL.window.wayland.viewport";
const PROP_WINDOW_WAYLAND_EGL_WINDOW_POINTER                   = "SDL.window.wayland.egl_window";
const PROP_WINDOW_WAYLAND_XDG_SURFACE_POINTER                  = "SDL.window.wayland.xdg_surface";
const PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_POINTER                 = "SDL.window.wayland.xdg_toplevel";
const PROP_WINDOW_WAYLAND_XDG_TOPLEVEL_EXPORT_HANDLE_STRING    = "SDL.window.wayland.xdg_toplevel_export_handle";
const PROP_WINDOW_WAYLAND_XDG_POPUP_POINTER                    = "SDL.window.wayland.xdg_popup";
const PROP_WINDOW_WAYLAND_XDG_POSITIONER_POINTER               = "SDL.window.wayland.xdg_positioner";
const PROP_WINDOW_X11_DISPLAY_POINTER                          = "SDL.window.x11.display";
const PROP_WINDOW_X11_SCREEN_NUMBER                            = "SDL.window.x11.screen";
const PROP_WINDOW_X11_WINDOW_NUMBER                            = "SDL.window.x11.window";
const PROP_WINDOW_EMSCRIPTEN_CANVAS_ID_STRING                  = "SDL.window.emscripten.canvas_id";
const PROP_WINDOW_EMSCRIPTEN_FILL_DOCUMENT_BOOLEAN             = "SDL.window.emscripten.fill_document";
const PROP_WINDOW_EMSCRIPTEN_KEYBOARD_ELEMENT_STRING           = "SDL.window.emscripten.keyboard_element";

extern fn SDL_WindowFlags get_window_flags(SDL_Window* window) @extern("SDL_GetWindowFlags");

extern fn bool set_window_title(SDL_Window* window, ZString title) @extern("SDL_SetWindowTitle");

extern fn ZString get_window_title(SDL_Window* window) @extern("SDL_GetWindowTitle");

extern fn bool set_window_icon(SDL_Window* window, SDL_Surface* icon) @extern("SDL_SetWindowIcon");

extern fn bool set_window_position(SDL_Window* window, CInt x, CInt y) @extern("SDL_SetWindowPosition");

extern fn bool get_window_position(SDL_Window* window, CInt* x, CInt* y) @extern("SDL_GetWindowPosition");

extern fn bool set_window_size(SDL_Window* window, CInt w, CInt h) @extern("SDL_SetWindowSize");

extern fn bool get_window_size(SDL_Window* window, CInt* w, CInt* h) @extern("SDL_GetWindowSize");

extern fn bool get_window_safe_area(SDL_Window* window, SDL_Rect* rect) @extern("SDL_GetWindowSafeArea");

extern fn bool set_window_aspect_ratio(SDL_Window* window, float min_aspect, float max_aspect) @extern("SDL_SetWindowAspectRatio");

extern fn bool get_window_aspect_ratio(SDL_Window* window, float* min_aspect, float* max_aspect) @extern("SDL_GetWindowAspectRatio");

extern fn bool get_window_borders_size(SDL_Window* window, CInt* top, CInt* left, CInt* bottom, CInt* right) @extern("SDL_GetWindowBordersSize");

extern fn bool get_window_size_in_pixels(SDL_Window* window, CInt* w, CInt* h) @extern("SDL_GetWindowSizeInPixels");

extern fn bool set_window_minimum_size(SDL_Window* window, CInt min_w, CInt min_h) @extern("SDL_SetWindowMinimumSize");

extern fn bool get_window_minimum_size(SDL_Window* window, CInt* w, CInt* h) @extern("SDL_GetWindowMinimumSize");

extern fn bool set_window_maximum_size(SDL_Window* window, CInt max_w, CInt max_h) @extern("SDL_SetWindowMaximumSize");

extern fn bool get_window_maximum_size(SDL_Window* window, CInt* w, CInt* h) @extern("SDL_GetWindowMaximumSize");

extern fn bool set_window_bordered(SDL_Window* window, bool bordered) @extern("SDL_SetWindowBordered");

extern fn bool set_window_resizable(SDL_Window* window, bool resizable) @extern("SDL_SetWindowResizable");

extern fn bool set_window_always_on_top(SDL_Window* window, bool on_top) @extern("SDL_SetWindowAlwaysOnTop");

extern fn bool show_window(SDL_Window* window) @extern("SDL_ShowWindow");

extern fn bool hide_window(SDL_Window* window) @extern("SDL_HideWindow");

extern fn bool raise_window(SDL_Window* window) @extern("SDL_RaiseWindow");

extern fn bool maximize_window(SDL_Window* window) @extern("SDL_MaximizeWindow");

extern fn bool minimize_window(SDL_Window* window) @extern("SDL_MinimizeWindow");

extern fn bool restore_window(SDL_Window* window) @extern("SDL_RestoreWindow");

extern fn bool set_window_fullscreen(SDL_Window* window, bool fullscreen) @extern("SDL_SetWindowFullscreen");

extern fn bool sync_window(SDL_Window* window) @extern("SDL_SyncWindow");

extern fn bool window_has_surface(SDL_Window* window) @extern("SDL_WindowHasSurface");

extern fn SDL_Surface* get_window_surface(SDL_Window* window) @extern("SDL_GetWindowSurface");

extern fn bool set_window_surface_vsync(SDL_Window* window, CInt vsync) @extern("SDL_SetWindowSurfaceVSync");

::LINE:: #define SDL_WINDOW_SURFACE_VSYNC_DISABLED 0
::LINE:: #define SDL_WINDOW_SURFACE_VSYNC_ADAPTIVE (-1)

extern fn bool get_window_surface_vsync(SDL_Window* window, CInt* vsync) @extern("SDL_GetWindowSurfaceVSync");

extern fn bool update_window_surface(SDL_Window* window) @extern("SDL_UpdateWindowSurface");

extern fn bool update_window_surface_rects(SDL_Window* window, SDL_Rect* rects, CInt numrects) @extern("SDL_UpdateWindowSurfaceRects");

extern fn bool destroy_window_surface(SDL_Window* window) @extern("SDL_DestroyWindowSurface");

extern fn bool set_window_keyboard_grab(SDL_Window* window, bool grabbed) @extern("SDL_SetWindowKeyboardGrab");

extern fn bool set_window_mouse_grab(SDL_Window* window, bool grabbed) @extern("SDL_SetWindowMouseGrab");

extern fn bool get_window_keyboard_grab(SDL_Window* window) @extern("SDL_GetWindowKeyboardGrab");

extern fn bool get_window_mouse_grab(SDL_Window* window) @extern("SDL_GetWindowMouseGrab");

extern fn SDL_Window* get_grabbed_window() @extern("SDL_GetGrabbedWindow");

extern fn bool set_window_mouse_rect(SDL_Window* window, SDL_Rect* rect) @extern("SDL_SetWindowMouseRect");

extern fn SDL_Rect* get_window_mouse_rect(SDL_Window* window) @extern("SDL_GetWindowMouseRect");

extern fn bool set_window_opacity(SDL_Window* window, float opacity) @extern("SDL_SetWindowOpacity");

extern fn float get_window_opacity(SDL_Window* window) @extern("SDL_GetWindowOpacity");

extern fn bool set_window_parent(SDL_Window* window, SDL_Window* parent) @extern("SDL_SetWindowParent");

extern fn bool set_window_modal(SDL_Window* window, bool modal) @extern("SDL_SetWindowModal");

extern fn bool set_window_focusable(SDL_Window* window, bool focusable) @extern("SDL_SetWindowFocusable");


extern fn bool show_window_system_menu(SDL_Window* window, CInt x, CInt y) @extern("SDL_ShowWindowSystemMenu");

enum SDL_HitTestResult : const CInt
{
    NORMAL,             /**< Region is normal. No special properties. */
    DRAGGABLE,          /**< Region can drag entire window. */
    RESIZE_TOPLEFT,     /**< Region is the resizable top-left corner border. */
    RESIZE_TOP,         /**< Region is the resizable top border. */
    RESIZE_TOPRIGHT,    /**< Region is the resizable top-right corner border. */
    RESIZE_RIGHT,       /**< Region is the resizable right border. */
    RESIZE_BOTTOMRIGHT, /**< Region is the resizable bottom-right corner border. */
    RESIZE_BOTTOM,      /**< Region is the resizable bottom border. */
    RESIZE_BOTTOMLEFT,  /**< Region is the resizable bottom-left corner border. */
    RESIZE_LEFT         /**< Region is the resizable left border. */
}

::LINE:: typedef SDL_HitTestResult (SDLCALL *SDL_HitTest)(SDL_Window *win,
::LINE::                                                  const SDL_Point *area,
::LINE::                                                  void *data);

extern fn bool set_window_hit_test(SDL_Window* window, SDL_HitTest callback, void* callback_data) @extern("SDL_SetWindowHitTest");

extern fn bool set_window_shape(SDL_Window* window, SDL_Surface* shape) @extern("SDL_SetWindowShape");

extern fn bool flash_window(SDL_Window* window, SDL_FlashOperation operation) @extern("SDL_FlashWindow");

extern fn bool set_window_progress_state(SDL_Window* window, SDL_ProgressState state) @extern("SDL_SetWindowProgressState");

extern fn SDL_ProgressState get_window_progress_state(SDL_Window* window) @extern("SDL_GetWindowProgressState");

extern fn bool set_window_progress_value(SDL_Window* window, float value) @extern("SDL_SetWindowProgressValue");

extern fn float get_window_progress_value(SDL_Window* window) @extern("SDL_GetWindowProgressValue");

extern fn void destroy_window(SDL_Window* window) @extern("SDL_DestroyWindow");


extern fn bool screen_saver_enabled() @extern("SDL_ScreenSaverEnabled");

extern fn bool enable_screen_saver() @extern("SDL_EnableScreenSaver");

extern fn bool disable_screen_saver() @extern("SDL_DisableScreenSaver");


/* @{ */

extern fn bool gl_load_library(ZString path) @extern("SDL_GL_LoadLibrary");

extern fn SDL_FunctionPointer gl_get_proc_address(ZString proc) @extern("SDL_GL_GetProcAddress");

extern fn SDL_FunctionPointer egl_get_proc_address(ZString proc) @extern("SDL_EGL_GetProcAddress");

extern fn void gl_unload_library() @extern("SDL_GL_UnloadLibrary");

extern fn bool gl_extension_supported(ZString extension) @extern("SDL_GL_ExtensionSupported");

extern fn void gl_reset_attributes() @extern("SDL_GL_ResetAttributes");

extern fn bool gl_set_attribute(SDL_GLAttr attr, CInt value) @extern("SDL_GL_SetAttribute");

extern fn bool gl_get_attribute(SDL_GLAttr attr, CInt* value) @extern("SDL_GL_GetAttribute");

extern fn SDL_GLContext gl_create_context(SDL_Window* window) @extern("SDL_GL_CreateContext");

extern fn bool gl_make_current(SDL_Window* window, SDL_GLContext context) @extern("SDL_GL_MakeCurrent");

extern fn SDL_Window* gl_get_current_window() @extern("SDL_GL_GetCurrentWindow");

extern fn SDL_GLContext gl_get_current_context() @extern("SDL_GL_GetCurrentContext");

extern fn SDL_EGLDisplay egl_get_current_display() @extern("SDL_EGL_GetCurrentDisplay");

extern fn SDL_EGLConfig egl_get_current_config() @extern("SDL_EGL_GetCurrentConfig");

extern fn SDL_EGLSurface egl_get_window_surface(SDL_Window* window) @extern("SDL_EGL_GetWindowSurface");

extern fn void egl_set_attribute_callbacks(SDL_EGLAttribArrayCallback platformAttribCallback,
                                           SDL_EGLIntArrayCallback surfaceAttribCallback,
                                           SDL_EGLIntArrayCallback contextAttribCallback, void* userdata) @extern("SDL_EGL_SetAttributeCallbacks");

extern fn bool gl_set_swap_interval(CInt interval) @extern("SDL_GL_SetSwapInterval");

extern fn bool gl_get_swap_interval(CInt* interval) @extern("SDL_GL_GetSwapInterval");

extern fn bool gl_swap_window(SDL_Window* window) @extern("SDL_GL_SwapWindow");

extern fn bool gl_destroy_context(SDL_GLContext context) @extern("SDL_GL_DestroyContext");

/* @} *//* OpenGL support functions */


/* Ends C function definitions when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: }
::LINE:: #endif

::LINE:: #endif /* SDL_video_h_ */
