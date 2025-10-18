module sdl;

/* As of version 0.5, SDL is loaded dynamically into the application */

enum SDL_InitFlags : const uint
{
    AUDIO       = 0x00000010u, /**< `SDL_INIT_AUDIO` implies `SDL_INIT_EVENTS` */
    VIDEO       = 0x00000020u, /**< `SDL_INIT_VIDEO` implies `SDL_INIT_EVENTS`, should be initialized on the main thread */
    JOYSTICK    = 0x00000200u, /**< `SDL_INIT_JOYSTICK` implies `SDL_INIT_EVENTS` */
    HAPTIC      = 0x00001000u,
    GAMEPAD     = 0x00002000u, /**< `SDL_INIT_GAMEPAD` implies `SDL_INIT_JOYSTICK` */
    EVENTS      = 0x00004000u,
    SENSOR      = 0x00008000u, /**< `SDL_INIT_SENSOR` implies `SDL_INIT_EVENTS` */
    CAMERA      = 0x00010000u, /**< `SDL_INIT_CAMERA` implies `SDL_INIT_EVENTS` */
}

enum SDL_AppResult : const CInt
{
    CONTINUE,  /**< Value that requests that the app continue from the main callbacks. */
    SUCCESS,  /**< Value that requests termination with success from the main callbacks. */
    FAILURE,  /**< Value that requests termination with error from the main callbacks. */
}

alias SDL_AppInit_func = fn SDL_AppResult(void** appstate, int argc, char** argv);

alias SDL_AppIterate_func = fn SDL_AppResult(void* appstate);

alias SDL_AppEvent_func = fn SDL_AppResult(void* appstate, SDL_Event* event);

alias SDL_AppQuit_func = fn void(void** appstate, SDL_AppResult result);


extern fn bool init(SDL_InitFlags flags) @extern("SDL_Init");

extern fn bool init_sub_system(SDL_InitFlags flags) @extern("SDL_InitSubSystem");

extern fn void quit_sub_system(SDL_InitFlags flags) @extern("SDL_QuitSubSystem");

extern fn SDL_InitFlags was_init(SDL_InitFlags flags) @extern("SDL_WasInit");

extern fn void quit() @extern("SDL_Quit");

extern fn bool is_main_thread() @extern("SDL_IsMainThread");

alias SDL_MainThreadCallback = fn void(void* userdata);

extern fn bool run_on_main_thread(SDL_MainThreadCallback callback, void* userdata, bool wait_complete) @extern("SDL_RunOnMainThread");

extern fn bool set_app_metadata(ZString appname, ZString appversion, ZString appidentifier) @extern("SDL_SetAppMetadata");

extern fn bool set_app_metadata_property(ZString name, ZString value) @extern("SDL_SetAppMetadataProperty");

const PROP_APP_METADATA_NAME_STRING          = "SDL.app.metadata.name";
const PROP_APP_METADATA_VERSION_STRING       = "SDL.app.metadata.version";
const PROP_APP_METADATA_IDENTIFIER_STRING    = "SDL.app.metadata.identifier";
const PROP_APP_METADATA_CREATOR_STRING       = "SDL.app.metadata.creator";
const PROP_APP_METADATA_COPYRIGHT_STRING     = "SDL.app.metadata.copyright";
const PROP_APP_METADATA_URL_STRING           = "SDL.app.metadata.url";
const PROP_APP_METADATA_TYPE_STRING          = "SDL.app.metadata.type";

extern fn ZString get_app_metadata_property(ZString name) @extern("SDL_GetAppMetadataProperty");
