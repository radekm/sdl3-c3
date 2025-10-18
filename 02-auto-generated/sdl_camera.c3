module sdl;


::LINE:: #ifndef SDL_camera_h_
::LINE:: #define SDL_camera_h_


/* Set up for C function definitions, even when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: extern "C" {
::LINE:: #endif

typedef SDL_CameraID = uint;

typedef SDL_Camera = void;

struct SDL_CameraSpec
{
    SDL_PixelFormat format;  /**< Frame format */
    SDL_Colorspace colorspace;  /**< Frame colorspace */
    CInt width;  /**< Frame width */
    CInt height;  /**< Frame height */
    CInt framerate_numerator;  /**< Frame rate numerator ((num / denom) == FPS, (denom / num) == duration in seconds) */
    CInt framerate_denominator;  /**< Frame rate denominator ((num / denom) == FPS, (denom / num) == duration in seconds) */
}

enum SDL_CameraPosition : const CInt
{
    UNKNOWN,
    FRONT_FACING,
    BACK_FACING,
}

enum SDL_CameraPermissionState : const CInt
{
    DENIED = -1,
    PENDING,
    APPROVED,
}


extern fn CInt get_num_camera_drivers() @extern("SDL_GetNumCameraDrivers");

extern fn ZString get_camera_driver(CInt index) @extern("SDL_GetCameraDriver");

extern fn ZString get_current_camera_driver() @extern("SDL_GetCurrentCameraDriver");

extern fn SDL_CameraID* get_cameras(CInt* count) @extern("SDL_GetCameras");

extern fn SDL_CameraSpec** get_camera_supported_formats(SDL_CameraID instance_id, CInt* count) @extern("SDL_GetCameraSupportedFormats");

extern fn ZString get_camera_name(SDL_CameraID instance_id) @extern("SDL_GetCameraName");

extern fn SDL_CameraPosition get_camera_position(SDL_CameraID instance_id) @extern("SDL_GetCameraPosition");

extern fn SDL_Camera* open_camera(SDL_CameraID instance_id, SDL_CameraSpec* spec) @extern("SDL_OpenCamera");

extern fn SDL_CameraPermissionState get_camera_permission_state(SDL_Camera* camera) @extern("SDL_GetCameraPermissionState");

extern fn SDL_CameraID get_camera_id(SDL_Camera* camera) @extern("SDL_GetCameraID");

extern fn SDL_PropertiesID get_camera_properties(SDL_Camera* camera) @extern("SDL_GetCameraProperties");

extern fn bool get_camera_format(SDL_Camera* camera, SDL_CameraSpec* spec) @extern("SDL_GetCameraFormat");

extern fn SDL_Surface* acquire_camera_frame(SDL_Camera* camera, ulong* timestampNS) @extern("SDL_AcquireCameraFrame");

extern fn void release_camera_frame(SDL_Camera* camera, SDL_Surface* frame) @extern("SDL_ReleaseCameraFrame");

extern fn void close_camera(SDL_Camera* camera) @extern("SDL_CloseCamera");

/* Ends C function definitions when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: }
::LINE:: #endif

::LINE:: #endif /* SDL_camera_h_ */
