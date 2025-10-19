module sdl;


::LINE:: #ifndef SDL_joystick_h_
::LINE:: #define SDL_joystick_h_


/* Set up for C function definitions, even when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: extern "C" {
::LINE:: #endif

::LINE:: #ifdef SDL_THREAD_SAFETY_ANALYSIS
::LINE:: extern SDL_Mutex *SDL_joystick_lock;
::LINE:: #endif

typedef SDL_Joystick = void;

typedef SDL_JoystickID = uint;

enum SDL_JoystickType : const CInt
{
    UNKNOWN,
    GAMEPAD,
    WHEEL,
    ARCADE_STICK,
    FLIGHT_STICK,
    DANCE_PAD,
    GUITAR,
    DRUM_KIT,
    ARCADE_PAD,
    THROTTLE,
    COUNT,
}

enum SDL_JoystickConnectionState : const CInt
{
    INVALID = -1,
    UNKNOWN,
    WIRED,
    WIRELESS,
}

::LINE:: #define SDL_JOYSTICK_AXIS_MAX   32767

::LINE:: #define SDL_JOYSTICK_AXIS_MIN   -32768


/* Function prototypes */

::LINE:: extern SDL_DECLSPEC void SDLCALL SDL_LockJoysticks(void) SDL_ACQUIRE(SDL_joystick_lock);

::LINE:: extern SDL_DECLSPEC void SDLCALL SDL_UnlockJoysticks(void) SDL_RELEASE(SDL_joystick_lock);

extern fn bool has_joystick() @extern("SDL_HasJoystick");

extern fn SDL_JoystickID* get_joysticks(CInt* count) @extern("SDL_GetJoysticks");

extern fn ZString get_joystick_name_for_id(SDL_JoystickID instance_id) @extern("SDL_GetJoystickNameForID");

extern fn ZString get_joystick_path_for_id(SDL_JoystickID instance_id) @extern("SDL_GetJoystickPathForID");

extern fn CInt get_joystick_player_index_for_id(SDL_JoystickID instance_id) @extern("SDL_GetJoystickPlayerIndexForID");

extern fn SDL_Guid get_joystick_guid_for_id(SDL_JoystickID instance_id) @extern("SDL_GetJoystickGUIDForID");

extern fn ushort get_joystick_vendor_for_id(SDL_JoystickID instance_id) @extern("SDL_GetJoystickVendorForID");

extern fn ushort get_joystick_product_for_id(SDL_JoystickID instance_id) @extern("SDL_GetJoystickProductForID");

extern fn ushort get_joystick_product_version_for_id(SDL_JoystickID instance_id) @extern("SDL_GetJoystickProductVersionForID");

extern fn SDL_JoystickType get_joystick_type_for_id(SDL_JoystickID instance_id) @extern("SDL_GetJoystickTypeForID");

extern fn SDL_Joystick* open_joystick(SDL_JoystickID instance_id) @extern("SDL_OpenJoystick");

extern fn SDL_Joystick* get_joystick_from_id(SDL_JoystickID instance_id) @extern("SDL_GetJoystickFromID");

extern fn SDL_Joystick* get_joystick_from_player_index(CInt player_index) @extern("SDL_GetJoystickFromPlayerIndex");

struct SDL_VirtualJoystickTouchpadDesc
{
    ushort nfingers;  /**< the number of simultaneous fingers on this touchpad */
    ushort[3] padding;
}

struct SDL_VirtualJoystickSensorDesc
{
    SDL_SensorType type;  /**< the type of this sensor */
    float rate;  /**< the update frequency of this sensor, may be 0.0f */
}

struct SDL_VirtualJoystickDesc
{
    uint version;  /**< the version of this interface */
    ushort type;  /**< `SDL_JoystickType` */
    ushort padding;  /**< unused */
    ushort vendor_id;  /**< the USB vendor ID of this joystick */
    ushort product_id;  /**< the USB product ID of this joystick */
    ushort naxes;  /**< the number of axes on this joystick */
    ushort nbuttons;  /**< the number of buttons on this joystick */
    ushort nballs;  /**< the number of balls on this joystick */
    ushort nhats;  /**< the number of hats on this joystick */
    ushort ntouchpads;  /**< the number of touchpads on this joystick, requires `touchpads` to point at valid descriptions */
    ushort nsensors;  /**< the number of sensors on this joystick, requires `sensors` to point at valid descriptions */
    ushort[2] padding2;  /**< unused */
    uint button_mask;  /**< A mask of which buttons are valid for this controller
                             e.g. (1 << SDL_GAMEPAD_BUTTON_SOUTH) */
    uint axis_mask;  /**< A mask of which axes are valid for this controller
                             e.g. (1 << SDL_GAMEPAD_AXIS_LEFTX) */
    ZString name;  /**< the name of the joystick */
    SDL_VirtualJoystickTouchpadDesc* touchpads;  /**< A pointer to an array of touchpad descriptions, required if `ntouchpads` is > 0 */
    SDL_VirtualJoystickSensorDesc* sensors;  /**< A pointer to an array of sensor descriptions, required if `nsensors` is > 0 */

    void* userdata;  /**< User data pointer passed to callbacks */
::LINE::     void (SDLCALL *Update)(void *userdata); /**< Called when the joystick state should be updated */
::LINE::     void (SDLCALL *SetPlayerIndex)(void *userdata, int player_index); /**< Called when the player index is set */
::LINE::     bool (SDLCALL *Rumble)(void *userdata, Uint16 low_frequency_rumble, Uint16 high_frequency_rumble); /**< Implements SDL_RumbleJoystick() */
::LINE::     bool (SDLCALL *RumbleTriggers)(void *userdata, Uint16 left_rumble, Uint16 right_rumble); /**< Implements SDL_RumbleJoystickTriggers() */
::LINE::     bool (SDLCALL *SetLED)(void *userdata, Uint8 red, Uint8 green, Uint8 blue); /**< Implements SDL_SetJoystickLED() */
::LINE::     bool (SDLCALL *SendEffect)(void *userdata, const void *data, int size); /**< Implements SDL_SendJoystickEffect() */
::LINE::     bool (SDLCALL *SetSensorsEnabled)(void *userdata, bool enabled); /**< Implements SDL_SetGamepadSensorEnabled() */
::LINE::     void (SDLCALL *Cleanup)(void *userdata); /**< Cleans up the userdata when the joystick is detached */
}

::LINE:: /* Check the size of SDL_VirtualJoystickDesc
::LINE::  *
::LINE::  * If this assert fails, either the compiler is padding to an unexpected size,
::LINE::  * or the interface has been updated and this should be updated to match and
::LINE::  * the code using this interface should be updated to handle the old version.
::LINE::  */
::LINE:: SDL_COMPILE_TIME_ASSERT(SDL_VirtualJoystickDesc_SIZE,
::LINE::     (sizeof(void *) == 4 && sizeof(SDL_VirtualJoystickDesc) == 84) ||
::LINE::     (sizeof(void *) == 8 && sizeof(SDL_VirtualJoystickDesc) == 136));

extern fn SDL_JoystickID attach_virtual_joystick(SDL_VirtualJoystickDesc* desc) @extern("SDL_AttachVirtualJoystick");

extern fn bool detach_virtual_joystick(SDL_JoystickID instance_id) @extern("SDL_DetachVirtualJoystick");

extern fn bool is_joystick_virtual(SDL_JoystickID instance_id) @extern("SDL_IsJoystickVirtual");

extern fn bool set_joystick_virtual_axis(SDL_Joystick* joystick, CInt axis, short value) @extern("SDL_SetJoystickVirtualAxis");

extern fn bool set_joystick_virtual_ball(SDL_Joystick* joystick, CInt ball, short xrel, short yrel) @extern("SDL_SetJoystickVirtualBall");

extern fn bool set_joystick_virtual_button(SDL_Joystick* joystick, CInt button, bool down) @extern("SDL_SetJoystickVirtualButton");

extern fn bool set_joystick_virtual_hat(SDL_Joystick* joystick, CInt hat, char value) @extern("SDL_SetJoystickVirtualHat");

extern fn bool set_joystick_virtual_touchpad(SDL_Joystick* joystick, CInt touchpad, CInt finger, bool down, float x, float y, float pressure) @extern("SDL_SetJoystickVirtualTouchpad");

extern fn bool send_joystick_virtual_sensor_data(SDL_Joystick* joystick, SDL_SensorType type, ulong sensor_timestamp, float* data, CInt num_values) @extern("SDL_SendJoystickVirtualSensorData");

extern fn SDL_PropertiesID get_joystick_properties(SDL_Joystick* joystick) @extern("SDL_GetJoystickProperties");

const PROP_JOYSTICK_CAP_MONO_LED_BOOLEAN           = "SDL.joystick.cap.mono_led";
const PROP_JOYSTICK_CAP_RGB_LED_BOOLEAN            = "SDL.joystick.cap.rgb_led";
const PROP_JOYSTICK_CAP_PLAYER_LED_BOOLEAN         = "SDL.joystick.cap.player_led";
const PROP_JOYSTICK_CAP_RUMBLE_BOOLEAN             = "SDL.joystick.cap.rumble";
const PROP_JOYSTICK_CAP_TRIGGER_RUMBLE_BOOLEAN     = "SDL.joystick.cap.trigger_rumble";

extern fn ZString get_joystick_name(SDL_Joystick* joystick) @extern("SDL_GetJoystickName");

extern fn ZString get_joystick_path(SDL_Joystick* joystick) @extern("SDL_GetJoystickPath");

extern fn CInt get_joystick_player_index(SDL_Joystick* joystick) @extern("SDL_GetJoystickPlayerIndex");

extern fn bool set_joystick_player_index(SDL_Joystick* joystick, CInt player_index) @extern("SDL_SetJoystickPlayerIndex");

extern fn SDL_Guid get_joystick_guid(SDL_Joystick* joystick) @extern("SDL_GetJoystickGUID");

extern fn ushort get_joystick_vendor(SDL_Joystick* joystick) @extern("SDL_GetJoystickVendor");

extern fn ushort get_joystick_product(SDL_Joystick* joystick) @extern("SDL_GetJoystickProduct");

extern fn ushort get_joystick_product_version(SDL_Joystick* joystick) @extern("SDL_GetJoystickProductVersion");

extern fn ushort get_joystick_firmware_version(SDL_Joystick* joystick) @extern("SDL_GetJoystickFirmwareVersion");

extern fn ZString get_joystick_serial(SDL_Joystick* joystick) @extern("SDL_GetJoystickSerial");

extern fn SDL_JoystickType get_joystick_type(SDL_Joystick* joystick) @extern("SDL_GetJoystickType");

extern fn void get_joystick_guid_info(SDL_Guid guid, ushort* vendor, ushort* product, ushort* version, ushort* crc16) @extern("SDL_GetJoystickGUIDInfo");

extern fn bool joystick_connected(SDL_Joystick* joystick) @extern("SDL_JoystickConnected");

extern fn SDL_JoystickID get_joystick_id(SDL_Joystick* joystick) @extern("SDL_GetJoystickID");

extern fn CInt get_num_joystick_axes(SDL_Joystick* joystick) @extern("SDL_GetNumJoystickAxes");

extern fn CInt get_num_joystick_balls(SDL_Joystick* joystick) @extern("SDL_GetNumJoystickBalls");

extern fn CInt get_num_joystick_hats(SDL_Joystick* joystick) @extern("SDL_GetNumJoystickHats");

extern fn CInt get_num_joystick_buttons(SDL_Joystick* joystick) @extern("SDL_GetNumJoystickButtons");

extern fn void set_joystick_events_enabled(bool enabled) @extern("SDL_SetJoystickEventsEnabled");

extern fn bool joystick_events_enabled() @extern("SDL_JoystickEventsEnabled");

extern fn void update_joysticks() @extern("SDL_UpdateJoysticks");

extern fn short get_joystick_axis(SDL_Joystick* joystick, CInt axis) @extern("SDL_GetJoystickAxis");

extern fn bool get_joystick_axis_initial_state(SDL_Joystick* joystick, CInt axis, short* state) @extern("SDL_GetJoystickAxisInitialState");

extern fn bool get_joystick_ball(SDL_Joystick* joystick, CInt ball, CInt* dx, CInt* dy) @extern("SDL_GetJoystickBall");

extern fn char get_joystick_hat(SDL_Joystick* joystick, CInt hat) @extern("SDL_GetJoystickHat");

::LINE:: #define SDL_HAT_CENTERED    0x00u
::LINE:: #define SDL_HAT_UP          0x01u
::LINE:: #define SDL_HAT_RIGHT       0x02u
::LINE:: #define SDL_HAT_DOWN        0x04u
::LINE:: #define SDL_HAT_LEFT        0x08u
::LINE:: #define SDL_HAT_RIGHTUP     (SDL_HAT_RIGHT|SDL_HAT_UP)
::LINE:: #define SDL_HAT_RIGHTDOWN   (SDL_HAT_RIGHT|SDL_HAT_DOWN)
::LINE:: #define SDL_HAT_LEFTUP      (SDL_HAT_LEFT|SDL_HAT_UP)
::LINE:: #define SDL_HAT_LEFTDOWN    (SDL_HAT_LEFT|SDL_HAT_DOWN)

extern fn bool get_joystick_button(SDL_Joystick* joystick, CInt button) @extern("SDL_GetJoystickButton");

extern fn bool rumble_joystick(SDL_Joystick* joystick, ushort low_frequency_rumble, ushort high_frequency_rumble, uint duration_ms) @extern("SDL_RumbleJoystick");

extern fn bool rumble_joystick_triggers(SDL_Joystick* joystick, ushort left_rumble, ushort right_rumble, uint duration_ms) @extern("SDL_RumbleJoystickTriggers");

extern fn bool set_joystick_led(SDL_Joystick* joystick, char red, char green, char blue) @extern("SDL_SetJoystickLED");

extern fn bool send_joystick_effect(SDL_Joystick* joystick, void* data, CInt size) @extern("SDL_SendJoystickEffect");

extern fn void close_joystick(SDL_Joystick* joystick) @extern("SDL_CloseJoystick");

extern fn SDL_JoystickConnectionState get_joystick_connection_state(SDL_Joystick* joystick) @extern("SDL_GetJoystickConnectionState");

extern fn SDL_PowerState get_joystick_power_info(SDL_Joystick* joystick, CInt* percent) @extern("SDL_GetJoystickPowerInfo");

/* Ends C function definitions when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: }
::LINE:: #endif

::LINE:: #endif /* SDL_joystick_h_ */
