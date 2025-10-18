module sdl;

typedef SDL_TouchID = ulong;

typedef SDL_FingerID = ulong;

enum SDL_TouchDeviceType : const CInt
{
    INVALID = -1,
    DIRECT,  /**< touch screen with window-relative coordinates */
    INDIRECT_ABSOLUTE,  /**< trackpad with absolute device coordinates */
    INDIRECT_RELATIVE,  /**< trackpad with screen cursor-relative coordinates */
}

struct SDL_Finger
{
    SDL_FingerID id;  /**< the finger ID */
    float x;  /**< the x-axis location of the touch event, normalized (0...1) */
    float y;  /**< the y-axis location of the touch event, normalized (0...1) */
    float pressure;  /**< the quantity of pressure applied, normalized (0...1) */
}

const SDL_MouseID TOUCH_MOUSEID = (SDL_MouseID)-1;

const SDL_TouchID MOUSE_TOUCHID = (SDL_TouchID)-1;


extern fn SDL_TouchID* get_touch_devices(CInt* count) @extern("SDL_GetTouchDevices");

extern fn ZString get_touch_device_name(SDL_TouchID touchID) @extern("SDL_GetTouchDeviceName");

extern fn SDL_TouchDeviceType get_touch_device_type(SDL_TouchID touchID) @extern("SDL_GetTouchDeviceType");

extern fn SDL_Finger** get_touch_fingers(SDL_TouchID touchID, CInt* count) @extern("SDL_GetTouchFingers");
