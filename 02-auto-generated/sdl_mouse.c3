module sdl;


::LINE:: #ifndef SDL_mouse_h_
::LINE:: #define SDL_mouse_h_


/* Set up for C function definitions, even when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: extern "C" {
::LINE:: #endif

typedef SDL_MouseID = uint;

typedef SDL_Cursor = void;

enum SDL_SystemCursor : const CInt
{
    DEFAULT,  /**< Default cursor. Usually an arrow. */
    TEXT,  /**< Text selection. Usually an I-beam. */
    WAIT,  /**< Wait. Usually an hourglass or watch or spinning ball. */
    CROSSHAIR,  /**< Crosshair. */
    PROGRESS,  /**< Program is busy but still interactive. Usually it's WAIT with an arrow. */
    NWSE_RESIZE,  /**< Double arrow pointing northwest and southeast. */
    NESW_RESIZE,  /**< Double arrow pointing northeast and southwest. */
    EW_RESIZE,  /**< Double arrow pointing west and east. */
    NS_RESIZE,  /**< Double arrow pointing north and south. */
    MOVE,  /**< Four pointed arrow pointing north, south, east, and west. */
    NOT_ALLOWED,  /**< Not permitted. Usually a slashed circle or crossbones. */
    POINTER,  /**< Pointer that indicates a link. Usually a pointing hand. */
    NW_RESIZE,  /**< Window resize top-left. This may be a single arrow or a double arrow like NWSE_RESIZE. */
    N_RESIZE,  /**< Window resize top. May be NS_RESIZE. */
    NE_RESIZE,  /**< Window resize top-right. May be NESW_RESIZE. */
    E_RESIZE,  /**< Window resize right. May be EW_RESIZE. */
    SE_RESIZE,  /**< Window resize bottom-right. May be NWSE_RESIZE. */
    S_RESIZE,  /**< Window resize bottom. May be NS_RESIZE. */
    SW_RESIZE,  /**< Window resize bottom-left. May be NESW_RESIZE. */
    W_RESIZE,  /**< Window resize left. May be EW_RESIZE. */
    COUNT,
}

enum SDL_MouseWheelDirection : const CInt
{
    NORMAL,  /**< The scroll direction is normal */
    FLIPPED,  /**< The scroll direction is flipped / natural */
}

struct SDL_CursorFrameInfo
{
    SDL_Surface* surface;  /**< The surface data for this frame */
    uint duration;  /**< The frame duration in milliseconds (a duration of 0 is infinite) */
}

enum SDL_MouseButtonFlags : const uint
{
    LEFT      = 1,
    MIDDLE    = 2,
    RIGHT     = 3,
    X1        = 4,
    X2        = 5,
}

::LINE:: #define SDL_BUTTON_MASK(X)  (1u << ((X)-1))
::LINE:: #define SDL_BUTTON_LMASK    SDL_BUTTON_MASK(SDL_BUTTON_LEFT)
::LINE:: #define SDL_BUTTON_MMASK    SDL_BUTTON_MASK(SDL_BUTTON_MIDDLE)
::LINE:: #define SDL_BUTTON_RMASK    SDL_BUTTON_MASK(SDL_BUTTON_RIGHT)
::LINE:: #define SDL_BUTTON_X1MASK   SDL_BUTTON_MASK(SDL_BUTTON_X1)
::LINE:: #define SDL_BUTTON_X2MASK   SDL_BUTTON_MASK(SDL_BUTTON_X2)

::LINE:: typedef void (SDLCALL *SDL_MouseMotionTransformCallback)(
::LINE::     void *userdata, 
::LINE::     Uint64 timestamp, 
::LINE::     SDL_Window *window, 
::LINE::     SDL_MouseID mouseID, 
::LINE::     float *x, float *y
::LINE:: );

/* Function prototypes */

extern fn bool has_mouse() @extern("SDL_HasMouse");

extern fn SDL_MouseID* get_mice(CInt* count) @extern("SDL_GetMice");

extern fn ZString get_mouse_name_for_id(SDL_MouseID instance_id) @extern("SDL_GetMouseNameForID");

extern fn SDL_Window* get_mouse_focus() @extern("SDL_GetMouseFocus");

extern fn SDL_MouseButtonFlags get_mouse_state(float* x, float* y) @extern("SDL_GetMouseState");

extern fn SDL_MouseButtonFlags get_global_mouse_state(float* x, float* y) @extern("SDL_GetGlobalMouseState");

extern fn SDL_MouseButtonFlags get_relative_mouse_state(float* x, float* y) @extern("SDL_GetRelativeMouseState");

extern fn void warp_mouse_in_window(SDL_Window* window,
                                    float x, float y) @extern("SDL_WarpMouseInWindow");

extern fn bool warp_mouse_global(float x, float y) @extern("SDL_WarpMouseGlobal");

extern fn bool set_relative_mouse_transform(SDL_MouseMotionTransformCallback callback, void* userdata) @extern("SDL_SetRelativeMouseTransform");

extern fn bool set_window_relative_mouse_mode(SDL_Window* window, bool enabled) @extern("SDL_SetWindowRelativeMouseMode");

extern fn bool get_window_relative_mouse_mode(SDL_Window* window) @extern("SDL_GetWindowRelativeMouseMode");

extern fn bool capture_mouse(bool enabled) @extern("SDL_CaptureMouse");

extern fn SDL_Cursor* create_cursor(char* data,
                                    char* mask,
                                    CInt w, CInt h, CInt hot_x,
                                    CInt hot_y) @extern("SDL_CreateCursor");

extern fn SDL_Cursor* create_color_cursor(SDL_Surface* surface,
                                          CInt hot_x,
                                          CInt hot_y) @extern("SDL_CreateColorCursor");

extern fn SDL_Cursor* create_animated_cursor(SDL_CursorFrameInfo* frames,
                                             CInt frame_count,
                                             CInt hot_x,
                                             CInt hot_y) @extern("SDL_CreateAnimatedCursor");

extern fn SDL_Cursor* create_system_cursor(SDL_SystemCursor id) @extern("SDL_CreateSystemCursor");

extern fn bool set_cursor(SDL_Cursor* cursor) @extern("SDL_SetCursor");

extern fn SDL_Cursor* get_cursor() @extern("SDL_GetCursor");

extern fn SDL_Cursor* get_default_cursor() @extern("SDL_GetDefaultCursor");

extern fn void destroy_cursor(SDL_Cursor* cursor) @extern("SDL_DestroyCursor");

extern fn bool show_cursor() @extern("SDL_ShowCursor");

extern fn bool hide_cursor() @extern("SDL_HideCursor");

extern fn bool cursor_visible() @extern("SDL_CursorVisible");

/* Ends C function definitions when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: }
::LINE:: #endif

::LINE:: #endif /* SDL_mouse_h_ */
