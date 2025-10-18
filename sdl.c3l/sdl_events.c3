module sdl;

/* General keyboard/mouse/pen state definitions */

// NOTE: We changed the type `CInt` to `uint`.
enum SDL_EventType : const uint
{
    FIRST = 0,  /**< Unused (do not remove) */

    /* Application events */
    QUIT = 0x100,  /**< User-requested quit */

    /* These application events have special meaning on iOS and Android, see README-ios.md and README-android.md for details */
    TERMINATING,  /**< The application is being terminated by the OS. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationWillTerminate()
                                     Called on Android in onDestroy()
                                */
    LOW_MEMORY,  /**< The application is low on memory, free memory if possible. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationDidReceiveMemoryWarning()
                                     Called on Android in onTrimMemory()
                                */
    WILL_ENTER_BACKGROUND,  /**< The application is about to enter the background. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationWillResignActive()
                                     Called on Android in onPause()
                                */
    DID_ENTER_BACKGROUND,  /**< The application did enter the background and may not get CPU for some time. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationDidEnterBackground()
                                     Called on Android in onPause()
                                */
    WILL_ENTER_FOREGROUND,  /**< The application is about to enter the foreground. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationWillEnterForeground()
                                     Called on Android in onResume()
                                */
    DID_ENTER_FOREGROUND,  /**< The application is now interactive. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationDidBecomeActive()
                                     Called on Android in onResume()
                                */

    LOCALE_CHANGED,  /**< The user's locale preferences have changed. */

    SYSTEM_THEME_CHANGED,  /**< The system theme changed */

    /* Display events */
    /* 0x150 was SDL_DISPLAYEVENT, reserve the number for sdl2-compat */
    DISPLAY_ORIENTATION = 0x151,  /**< Display orientation has changed to data1 */
    DISPLAY_ADDED,  /**< Display has been added to the system */
    DISPLAY_REMOVED,  /**< Display has been removed from the system */
    DISPLAY_MOVED,  /**< Display has changed position */
    DISPLAY_DESKTOP_MODE_CHANGED,  /**< Display has changed desktop mode */
    DISPLAY_CURRENT_MODE_CHANGED,  /**< Display has changed current mode */
    DISPLAY_CONTENT_SCALE_CHANGED,  /**< Display has changed content scale */
    DISPLAY_USABLE_BOUNDS_CHANGED,  /**< Display has changed usable bounds */
    DISPLAY_FIRST = DISPLAY_ORIENTATION,
    DISPLAY_LAST = DISPLAY_USABLE_BOUNDS_CHANGED,

    /* Window events */
    /* 0x200 was SDL_WINDOWEVENT, reserve the number for sdl2-compat */
    /* 0x201 was SDL_SYSWMEVENT, reserve the number for sdl2-compat */
    WINDOW_SHOWN = 0x202,  /**< Window has been shown */
    WINDOW_HIDDEN,  /**< Window has been hidden */
    WINDOW_EXPOSED,  /**< Window has been exposed and should be redrawn, and can be redrawn directly from event watchers for this event.
                                             data1 is 1 for live-resize expose events, 0 otherwise. */
    WINDOW_MOVED,  /**< Window has been moved to data1, data2 */
    WINDOW_RESIZED,  /**< Window has been resized to data1xdata2 */
    WINDOW_PIXEL_SIZE_CHANGED,  /**< The pixel size of the window has changed to data1xdata2 */
    WINDOW_METAL_VIEW_RESIZED,  /**< The pixel size of a Metal view associated with the window has changed */
    WINDOW_MINIMIZED,  /**< Window has been minimized */
    WINDOW_MAXIMIZED,  /**< Window has been maximized */
    WINDOW_RESTORED,  /**< Window has been restored to normal size and position */
    WINDOW_MOUSE_ENTER,  /**< Window has gained mouse focus */
    WINDOW_MOUSE_LEAVE,  /**< Window has lost mouse focus */
    WINDOW_FOCUS_GAINED,  /**< Window has gained keyboard focus */
    WINDOW_FOCUS_LOST,  /**< Window has lost keyboard focus */
    WINDOW_CLOSE_REQUESTED,  /**< The window manager requests that the window be closed */
    WINDOW_HIT_TEST,  /**< Window had a hit test that wasn't SDL_HITTEST_NORMAL */
    WINDOW_ICCPROF_CHANGED,  /**< The ICC profile of the window's display has changed */
    WINDOW_DISPLAY_CHANGED,  /**< Window has been moved to display data1 */
    WINDOW_DISPLAY_SCALE_CHANGED,  /**< Window display scale has been changed */
    WINDOW_SAFE_AREA_CHANGED,  /**< The window safe area has been changed */
    WINDOW_OCCLUDED,  /**< The window has been occluded */
    WINDOW_ENTER_FULLSCREEN,  /**< The window has entered fullscreen mode */
    WINDOW_LEAVE_FULLSCREEN,  /**< The window has left fullscreen mode */
    WINDOW_DESTROYED,  /**< The window with the associated ID is being or has been destroyed. If this message is being handled
                                             in an event watcher, the window handle is still valid and can still be used to retrieve any properties
                                             associated with the window. Otherwise, the handle has already been destroyed and all resources
                                             associated with it are invalid */
    WINDOW_HDR_STATE_CHANGED,  /**< Window HDR properties have changed */
    WINDOW_FIRST = WINDOW_SHOWN,
    WINDOW_LAST = WINDOW_HDR_STATE_CHANGED,

    /* Keyboard events */
    KEY_DOWN = 0x300,  /**< Key pressed */
    KEY_UP,  /**< Key released */
    TEXT_EDITING,  /**< Keyboard text editing (composition) */
    TEXT_INPUT,  /**< Keyboard text input */
    KEYMAP_CHANGED,  /**< Keymap changed due to a system event such as an
                                            input language or keyboard layout change. */
    KEYBOARD_ADDED,  /**< A new keyboard has been inserted into the system */
    KEYBOARD_REMOVED,  /**< A keyboard has been removed */
    TEXT_EDITING_CANDIDATES,  /**< Keyboard text editing candidates */
    SCREEN_KEYBOARD_SHOWN,  /**< The on-screen keyboard has been shown */
    SCREEN_KEYBOARD_HIDDEN,  /**< The on-screen keyboard has been hidden */

    /* Mouse events */
    MOUSE_MOTION = 0x400,  /**< Mouse moved */
    MOUSE_BUTTON_DOWN,  /**< Mouse button pressed */
    MOUSE_BUTTON_UP,  /**< Mouse button released */
    MOUSE_WHEEL,  /**< Mouse wheel motion */
    MOUSE_ADDED,  /**< A new mouse has been inserted into the system */
    MOUSE_REMOVED,  /**< A mouse has been removed */

    /* Joystick events */
    JOYSTICK_AXIS_MOTION = 0x600,  /**< Joystick axis motion */
    JOYSTICK_BALL_MOTION,  /**< Joystick trackball motion */
    JOYSTICK_HAT_MOTION,  /**< Joystick hat position change */
    JOYSTICK_BUTTON_DOWN,  /**< Joystick button pressed */
    JOYSTICK_BUTTON_UP,  /**< Joystick button released */
    JOYSTICK_ADDED,  /**< A new joystick has been inserted into the system */
    JOYSTICK_REMOVED,  /**< An opened joystick has been removed */
    JOYSTICK_BATTERY_UPDATED,  /**< Joystick battery level change */
    JOYSTICK_UPDATE_COMPLETE,  /**< Joystick update is complete */

    /* Gamepad events */
    GAMEPAD_AXIS_MOTION = 0x650,  /**< Gamepad axis motion */
    GAMEPAD_BUTTON_DOWN,  /**< Gamepad button pressed */
    GAMEPAD_BUTTON_UP,  /**< Gamepad button released */
    GAMEPAD_ADDED,  /**< A new gamepad has been inserted into the system */
    GAMEPAD_REMOVED,  /**< A gamepad has been removed */
    GAMEPAD_REMAPPED,  /**< The gamepad mapping was updated */
    GAMEPAD_TOUCHPAD_DOWN,  /**< Gamepad touchpad was touched */
    GAMEPAD_TOUCHPAD_MOTION,  /**< Gamepad touchpad finger was moved */
    GAMEPAD_TOUCHPAD_UP,  /**< Gamepad touchpad finger was lifted */
    GAMEPAD_SENSOR_UPDATE,  /**< Gamepad sensor was updated */
    GAMEPAD_UPDATE_COMPLETE,  /**< Gamepad update is complete */
    GAMEPAD_STEAM_HANDLE_UPDATED,  /**< Gamepad Steam handle has changed */

    /* Touch events */
    FINGER_DOWN = 0x700,
    FINGER_UP,
    FINGER_MOTION,
    FINGER_CANCELED,

    /* Pinch events */
    PINCH_BEGIN = 0x710,  /**< Pinch gesture started */
    PINCH_UPDATE,  /**< Pinch gesture updated */
    PINCH_END,  /**< Pinch gesture ended */

    /* 0x800, 0x801, and 0x802 were the Gesture events from SDL2. Do not reuse these values! sdl2-compat needs them! */

    /* Clipboard events */
    CLIPBOARD_UPDATE = 0x900,  /**< The clipboard changed */

    /* Drag and drop events */
    DROP_FILE = 0x1000,  /**< The system requests a file open */
    DROP_TEXT,  /**< text/plain drag-and-drop event */
    DROP_BEGIN,  /**< A new set of drops is beginning (NULL filename) */
    DROP_COMPLETE,  /**< Current set of drops is now complete (NULL filename) */
    DROP_POSITION,  /**< Position while moving over the window */

    /* Audio hotplug events */
    AUDIO_DEVICE_ADDED = 0x1100,  /**< A new audio device is available */
    AUDIO_DEVICE_REMOVED,  /**< An audio device has been removed. */
    AUDIO_DEVICE_FORMAT_CHANGED,  /**< An audio device's format has been changed by the system. */

    /* Sensor events */
    SENSOR_UPDATE = 0x1200,  /**< A sensor was updated */

    /* Pressure-sensitive pen events */
    PEN_PROXIMITY_IN = 0x1300,  /**< Pressure-sensitive pen has become available */
    PEN_PROXIMITY_OUT,  /**< Pressure-sensitive pen has become unavailable */
    PEN_DOWN,  /**< Pressure-sensitive pen touched drawing surface */
    PEN_UP,  /**< Pressure-sensitive pen stopped touching drawing surface */
    PEN_BUTTON_DOWN,  /**< Pressure-sensitive pen button pressed */
    PEN_BUTTON_UP,  /**< Pressure-sensitive pen button released */
    PEN_MOTION,  /**< Pressure-sensitive pen is moving on the tablet */
    PEN_AXIS,  /**< Pressure-sensitive pen angle/pressure/etc changed */

    /* Camera hotplug events */
    CAMERA_DEVICE_ADDED = 0x1400,  /**< A new camera device is available */
    CAMERA_DEVICE_REMOVED,  /**< A camera device has been removed. */
    CAMERA_DEVICE_APPROVED,  /**< A camera device has been approved for use by the user. */
    CAMERA_DEVICE_DENIED,  /**< A camera device has been denied for use by the user. */

    /* Render events */
    RENDER_TARGETS_RESET = 0x2000,  /**< The render targets have been reset and their contents need to be updated */
    RENDER_DEVICE_RESET,  /**< The device has been reset and all textures need to be recreated */
    RENDER_DEVICE_LOST,  /**< The device has been lost and can't be recovered. */

    /* Reserved events for private platforms */
    PRIVATE0 = 0x4000,
    PRIVATE1,
    PRIVATE2,
    PRIVATE3,

    /* Internal events */
    POLL_SENTINEL = 0x7F00,  /**< Signals the end of an event poll cycle */

    /** Events SDL_EVENT_USER through SDL_EVENT_LAST are for your use,
     *  and should be allocated with SDL_RegisterEvents()
     */
    USER = 0x8000,

    /**
     *  This last event is only for bounding internal arrays
     */
    LAST = 0xFFFF,

    /* This just makes sure the enum is the size of Uint32 */
    ENUM_PADDING = 0x7FFFFFFF,

}

struct SDL_CommonEvent
{
    uint type;  /**< Event type, shared with all events, Uint32 to cover user events which are not in the SDL_EventType enumeration */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
}

struct SDL_DisplayEvent
{
    SDL_EventType type;  /**< SDL_EVENT_DISPLAY_* */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_DisplayID displayID;  /**< The associated display */
    int data1;  /**< event dependent data */
    int data2;  /**< event dependent data */
}

struct SDL_WindowEvent
{
    SDL_EventType type;  /**< SDL_EVENT_WINDOW_* */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The associated window */
    int data1;  /**< event dependent data */
    int data2;  /**< event dependent data */
}

struct SDL_KeyboardDeviceEvent
{
    SDL_EventType type;  /**< SDL_EVENT_KEYBOARD_ADDED or SDL_EVENT_KEYBOARD_REMOVED */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_KeyboardID which;  /**< The keyboard instance id */
}

struct SDL_KeyboardEvent
{
    SDL_EventType type;  /**< SDL_EVENT_KEY_DOWN or SDL_EVENT_KEY_UP */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window with keyboard focus, if any */
    SDL_KeyboardID which;  /**< The keyboard instance id, or 0 if unknown or virtual */
    SDL_Scancode scancode;  /**< SDL physical key code */
    SDL_Keycode key;  /**< SDL virtual key code */
    SDL_Keymod mod;  /**< current key modifiers */
    ushort raw;  /**< The platform dependent scancode for this event */
    bool down;  /**< true if the key is pressed */
    bool repeat;  /**< true if this is a key repeat */
}

struct SDL_TextEditingEvent
{
    SDL_EventType type;  /**< SDL_EVENT_TEXT_EDITING */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window with keyboard focus, if any */
    ZString text;  /**< The editing text */
    int start;  /**< The start cursor of selected editing text, or -1 if not set */
    int length;  /**< The length of selected editing text, or -1 if not set */
}

struct SDL_TextEditingCandidatesEvent
{
    SDL_EventType type;  /**< SDL_EVENT_TEXT_EDITING_CANDIDATES */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window with keyboard focus, if any */
    ZString* candidates;  /**< The list of candidates, or NULL if there are no candidates available */
    int num_candidates;  /**< The number of strings in `candidates` */
    int selected_candidate;  /**< The index of the selected candidate, or -1 if no candidate is selected */
    bool horizontal;  /**< true if the list is horizontal, false if it's vertical */
    char padding1;
    char padding2;
    char padding3;
}

struct SDL_TextInputEvent
{
    SDL_EventType type;  /**< SDL_EVENT_TEXT_INPUT */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window with keyboard focus, if any */
    ZString text;  /**< The input text, UTF-8 encoded */
}

struct SDL_MouseDeviceEvent
{
    SDL_EventType type;  /**< SDL_EVENT_MOUSE_ADDED or SDL_EVENT_MOUSE_REMOVED */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_MouseID which;  /**< The mouse instance id */
}

struct SDL_MouseMotionEvent
{
    SDL_EventType type;  /**< SDL_EVENT_MOUSE_MOTION */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window with mouse focus, if any */
    SDL_MouseID which;  /**< The mouse instance id in relative mode, SDL_TOUCH_MOUSEID for touch events, or 0 */
    SDL_MouseButtonFlags state;  /**< The current button state */
    float x;  /**< X coordinate, relative to window */
    float y;  /**< Y coordinate, relative to window */
    float xrel;  /**< The relative motion in the X direction */
    float yrel;  /**< The relative motion in the Y direction */
}

struct SDL_MouseButtonEvent
{
    SDL_EventType type;  /**< SDL_EVENT_MOUSE_BUTTON_DOWN or SDL_EVENT_MOUSE_BUTTON_UP */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window with mouse focus, if any */
    SDL_MouseID which;  /**< The mouse instance id in relative mode, SDL_TOUCH_MOUSEID for touch events, or 0 */
    char button;  /**< The mouse button index */
    bool down;  /**< true if the button is pressed */
    char clicks;  /**< 1 for single-click, 2 for double-click, etc. */
    char padding;
    float x;  /**< X coordinate, relative to window */
    float y;  /**< Y coordinate, relative to window */
}

struct SDL_MouseWheelEvent
{
    SDL_EventType type;  /**< SDL_EVENT_MOUSE_WHEEL */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window with mouse focus, if any */
    SDL_MouseID which;  /**< The mouse instance id in relative mode or 0 */
    float x;  /**< The amount scrolled horizontally, positive to the right and negative to the left */
    float y;  /**< The amount scrolled vertically, positive away from the user and negative toward the user */
    SDL_MouseWheelDirection direction;  /**< Set to one of the SDL_MOUSEWHEEL_* defines. When FLIPPED the values in X and Y will be opposite. Multiply by -1 to change them back */
    float mouse_x;  /**< X coordinate, relative to window */
    float mouse_y;  /**< Y coordinate, relative to window */
    int integer_x;  /**< The amount scrolled horizontally, accumulated to whole scroll "ticks" (added in 3.2.12) */
    int integer_y;  /**< The amount scrolled vertically, accumulated to whole scroll "ticks" (added in 3.2.12) */
}

struct SDL_JoyAxisEvent
{
    SDL_EventType type;  /**< SDL_EVENT_JOYSTICK_AXIS_MOTION */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which;  /**< The joystick instance id */
    char axis;  /**< The joystick axis index */
    char padding1;
    char padding2;
    char padding3;
    short value;  /**< The axis value (range: -32768 to 32767) */
    ushort padding4;
}

struct SDL_JoyBallEvent
{
    SDL_EventType type;  /**< SDL_EVENT_JOYSTICK_BALL_MOTION */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which;  /**< The joystick instance id */
    char ball;  /**< The joystick trackball index */
    char padding1;
    char padding2;
    char padding3;
    short xrel;  /**< The relative motion in the X direction */
    short yrel;  /**< The relative motion in the Y direction */
}

struct SDL_JoyHatEvent
{
    SDL_EventType type;  /**< SDL_EVENT_JOYSTICK_HAT_MOTION */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which;  /**< The joystick instance id */
    char hat;  /**< The joystick hat index */
    char value;  /**< The hat position value.
                         *   \sa SDL_HAT_LEFTUP SDL_HAT_UP SDL_HAT_RIGHTUP
                         *   \sa SDL_HAT_LEFT SDL_HAT_CENTERED SDL_HAT_RIGHT
                         *   \sa SDL_HAT_LEFTDOWN SDL_HAT_DOWN SDL_HAT_RIGHTDOWN
                         *
                         *   Note that zero means the POV is centered.
                         */
    char padding1;
    char padding2;
}

struct SDL_JoyButtonEvent
{
    SDL_EventType type;  /**< SDL_EVENT_JOYSTICK_BUTTON_DOWN or SDL_EVENT_JOYSTICK_BUTTON_UP */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which;  /**< The joystick instance id */
    char button;  /**< The joystick button index */
    bool down;  /**< true if the button is pressed */
    char padding1;
    char padding2;
}

struct SDL_JoyDeviceEvent
{
    SDL_EventType type;  /**< SDL_EVENT_JOYSTICK_ADDED or SDL_EVENT_JOYSTICK_REMOVED or SDL_EVENT_JOYSTICK_UPDATE_COMPLETE */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which;  /**< The joystick instance id */
}

struct SDL_JoyBatteryEvent
{
    SDL_EventType type;  /**< SDL_EVENT_JOYSTICK_BATTERY_UPDATED */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which;  /**< The joystick instance id */
    SDL_PowerState state;  /**< The joystick battery state */
    CInt percent;  /**< The joystick battery percent charge remaining */
}

struct SDL_GamepadAxisEvent
{
    SDL_EventType type;  /**< SDL_EVENT_GAMEPAD_AXIS_MOTION */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which;  /**< The joystick instance id */
    char axis;  /**< The gamepad axis (SDL_GamepadAxis) */
    char padding1;
    char padding2;
    char padding3;
    short value;  /**< The axis value (range: -32768 to 32767) */
    ushort padding4;
}


struct SDL_GamepadButtonEvent
{
    SDL_EventType type;  /**< SDL_EVENT_GAMEPAD_BUTTON_DOWN or SDL_EVENT_GAMEPAD_BUTTON_UP */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which;  /**< The joystick instance id */
    char button;  /**< The gamepad button (SDL_GamepadButton) */
    bool down;  /**< true if the button is pressed */
    char padding1;
    char padding2;
}


struct SDL_GamepadDeviceEvent
{
    SDL_EventType type;  /**< SDL_EVENT_GAMEPAD_ADDED, SDL_EVENT_GAMEPAD_REMOVED, or SDL_EVENT_GAMEPAD_REMAPPED, SDL_EVENT_GAMEPAD_UPDATE_COMPLETE or SDL_EVENT_GAMEPAD_STEAM_HANDLE_UPDATED */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which;  /**< The joystick instance id */
}

struct SDL_GamepadTouchpadEvent
{
    SDL_EventType type;  /**< SDL_EVENT_GAMEPAD_TOUCHPAD_DOWN or SDL_EVENT_GAMEPAD_TOUCHPAD_MOTION or SDL_EVENT_GAMEPAD_TOUCHPAD_UP */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which;  /**< The joystick instance id */
    int touchpad;  /**< The index of the touchpad */
    int finger;  /**< The index of the finger on the touchpad */
    float x;  /**< Normalized in the range 0...1 with 0 being on the left */
    float y;  /**< Normalized in the range 0...1 with 0 being at the top */
    float pressure;  /**< Normalized in the range 0...1 */
}

struct SDL_GamepadSensorEvent
{
    SDL_EventType type;  /**< SDL_EVENT_GAMEPAD_SENSOR_UPDATE */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which;  /**< The joystick instance id */
    int sensor;  /**< The type of the sensor, one of the values of SDL_SensorType */
    float[3] data;  /**< Up to 3 values from the sensor, as defined in SDL_sensor.h */
    ulong sensor_timestamp;  /**< The timestamp of the sensor reading in nanoseconds, not necessarily synchronized with the system clock */
}

struct SDL_AudioDeviceEvent
{
    SDL_EventType type;  /**< SDL_EVENT_AUDIO_DEVICE_ADDED, or SDL_EVENT_AUDIO_DEVICE_REMOVED, or SDL_EVENT_AUDIO_DEVICE_FORMAT_CHANGED */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_AudioDeviceID which;  /**< SDL_AudioDeviceID for the device being added or removed or changing */
    bool recording;  /**< false if a playback device, true if a recording device. */
    char padding1;
    char padding2;
    char padding3;
}

struct SDL_CameraDeviceEvent
{
    SDL_EventType type;  /**< SDL_EVENT_CAMERA_DEVICE_ADDED, SDL_EVENT_CAMERA_DEVICE_REMOVED, SDL_EVENT_CAMERA_DEVICE_APPROVED, SDL_EVENT_CAMERA_DEVICE_DENIED */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_CameraID which;  /**< SDL_CameraID for the device being added or removed or changing */
}


struct SDL_RenderEvent
{
    SDL_EventType type;  /**< SDL_EVENT_RENDER_TARGETS_RESET, SDL_EVENT_RENDER_DEVICE_RESET, SDL_EVENT_RENDER_DEVICE_LOST */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window containing the renderer in question. */
}


struct SDL_TouchFingerEvent
{
    SDL_EventType type;  /**< SDL_EVENT_FINGER_DOWN, SDL_EVENT_FINGER_UP, SDL_EVENT_FINGER_MOTION, or SDL_EVENT_FINGER_CANCELED */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_TouchID touchID;  /**< The touch device id */
    SDL_FingerID fingerID;
    float x;  /**< Normalized in the range 0...1 */
    float y;  /**< Normalized in the range 0...1 */
    float dx;  /**< Normalized in the range -1...1 */
    float dy;  /**< Normalized in the range -1...1 */
    float pressure;  /**< Normalized in the range 0...1 */
    SDL_WindowID windowID;  /**< The window underneath the finger, if any */
}

struct SDL_PinchFingerEvent
{
    SDL_EventType type;  /**< ::SDL_EVENT_PINCH_BEGIN or ::SDL_EVENT_PINCH_UPDATE or ::SDL_EVENT_PINCH_END */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    float scale;  /**< The scale change since the last SDL_EVENT_PINCH_UPDATE. Scale < 1 is "zoom out". Scale > 1 is "zoom in". */
    SDL_WindowID windowID;  /**< The window underneath the finger, if any */
}

struct SDL_PenProximityEvent
{
    SDL_EventType type;  /**< SDL_EVENT_PEN_PROXIMITY_IN or SDL_EVENT_PEN_PROXIMITY_OUT */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window with pen focus, if any */
    SDL_PenID which;  /**< The pen instance id */
}

struct SDL_PenMotionEvent
{
    SDL_EventType type;  /**< SDL_EVENT_PEN_MOTION */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window with pen focus, if any */
    SDL_PenID which;  /**< The pen instance id */
    SDL_PenInputFlags pen_state;  /**< Complete pen input state at time of event */
    float x;  /**< X coordinate, relative to window */
    float y;  /**< Y coordinate, relative to window */
}

struct SDL_PenTouchEvent
{
    SDL_EventType type;  /**< SDL_EVENT_PEN_DOWN or SDL_EVENT_PEN_UP */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window with pen focus, if any */
    SDL_PenID which;  /**< The pen instance id */
    SDL_PenInputFlags pen_state;  /**< Complete pen input state at time of event */
    float x;  /**< X coordinate, relative to window */
    float y;  /**< Y coordinate, relative to window */
    bool eraser;  /**< true if eraser end is used (not all pens support this). */
    bool down;  /**< true if the pen is touching or false if the pen is lifted off */
}

struct SDL_PenButtonEvent
{
    SDL_EventType type;  /**< SDL_EVENT_PEN_BUTTON_DOWN or SDL_EVENT_PEN_BUTTON_UP */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window with mouse focus, if any */
    SDL_PenID which;  /**< The pen instance id */
    SDL_PenInputFlags pen_state;  /**< Complete pen input state at time of event */
    float x;  /**< X coordinate, relative to window */
    float y;  /**< Y coordinate, relative to window */
    char button;  /**< The pen button index (first button is 1). */
    bool down;  /**< true if the button is pressed */
}

struct SDL_PenAxisEvent
{
    SDL_EventType type;  /**< SDL_EVENT_PEN_AXIS */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window with pen focus, if any */
    SDL_PenID which;  /**< The pen instance id */
    SDL_PenInputFlags pen_state;  /**< Complete pen input state at time of event */
    float x;  /**< X coordinate, relative to window */
    float y;  /**< Y coordinate, relative to window */
    SDL_PenAxis axis;  /**< Axis that has changed */
    float value;  /**< New value of axis */
}

struct SDL_DropEvent
{
    SDL_EventType type;  /**< SDL_EVENT_DROP_BEGIN or SDL_EVENT_DROP_FILE or SDL_EVENT_DROP_TEXT or SDL_EVENT_DROP_COMPLETE or SDL_EVENT_DROP_POSITION */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window that was dropped on, if any */
    float x;  /**< X coordinate, relative to window (not on begin) */
    float y;  /**< Y coordinate, relative to window (not on begin) */
    ZString source;  /**< The source app that sent this drop event, or NULL if that isn't available */
    ZString data;  /**< The text for SDL_EVENT_DROP_TEXT and the file name for SDL_EVENT_DROP_FILE, NULL for other events */
}

struct SDL_ClipboardEvent
{
    SDL_EventType type;  /**< SDL_EVENT_CLIPBOARD_UPDATE */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    bool owner;  /**< are we owning the clipboard (internal update) */
    int num_mime_types;  /**< number of mime types */
    ZString* mime_types;  /**< current mime types */
}

struct SDL_SensorEvent
{
    SDL_EventType type;  /**< SDL_EVENT_SENSOR_UPDATE */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_SensorID which;  /**< The instance ID of the sensor */
    float[6] data;  /**< Up to 6 values from the sensor - additional values can be queried using SDL_GetSensorData() */
    ulong sensor_timestamp;  /**< The timestamp of the sensor reading in nanoseconds, not necessarily synchronized with the system clock */
}

struct SDL_QuitEvent
{
    SDL_EventType type;  /**< SDL_EVENT_QUIT */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
}

struct SDL_UserEvent
{
    uint type;  /**< SDL_EVENT_USER through SDL_EVENT_LAST, Uint32 because these are not in the SDL_EventType enumeration */
    uint reserved;
    ulong timestamp;  /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The associated window if any */
    int code;  /**< User defined event code */
    void* data1;  /**< User defined data pointer */
    void* data2;  /**< User defined data pointer */
}


// NOTE: We changed the type of the field `type` from `uint` to `SDL_EventType`.
//       I believe that it will work in C3 with user events.
union SDL_Event
{
    SDL_EventType type;  /**< Event type, shared with all events, Uint32 to cover user events which are not in the SDL_EventType enumeration */
    SDL_CommonEvent common;  /**< Common event data */
    SDL_DisplayEvent display;  /**< Display event data */
    SDL_WindowEvent window;  /**< Window event data */
    SDL_KeyboardDeviceEvent kdevice;  /**< Keyboard device change event data */
    SDL_KeyboardEvent key;  /**< Keyboard event data */
    SDL_TextEditingEvent edit;  /**< Text editing event data */
    SDL_TextEditingCandidatesEvent edit_candidates;  /**< Text editing candidates event data */
    SDL_TextInputEvent text;  /**< Text input event data */
    SDL_MouseDeviceEvent mdevice;  /**< Mouse device change event data */
    SDL_MouseMotionEvent motion;  /**< Mouse motion event data */
    SDL_MouseButtonEvent button;  /**< Mouse button event data */
    SDL_MouseWheelEvent wheel;  /**< Mouse wheel event data */
    SDL_JoyDeviceEvent jdevice;  /**< Joystick device change event data */
    SDL_JoyAxisEvent jaxis;  /**< Joystick axis event data */
    SDL_JoyBallEvent jball;  /**< Joystick ball event data */
    SDL_JoyHatEvent jhat;  /**< Joystick hat event data */
    SDL_JoyButtonEvent jbutton;  /**< Joystick button event data */
    SDL_JoyBatteryEvent jbattery;  /**< Joystick battery event data */
    SDL_GamepadDeviceEvent gdevice;  /**< Gamepad device event data */
    SDL_GamepadAxisEvent gaxis;  /**< Gamepad axis event data */
    SDL_GamepadButtonEvent gbutton;  /**< Gamepad button event data */
    SDL_GamepadTouchpadEvent gtouchpad;  /**< Gamepad touchpad event data */
    SDL_GamepadSensorEvent gsensor;  /**< Gamepad sensor event data */
    SDL_AudioDeviceEvent adevice;  /**< Audio device event data */
    SDL_CameraDeviceEvent cdevice;  /**< Camera device event data */
    SDL_SensorEvent sensor;  /**< Sensor event data */
    SDL_QuitEvent quit;  /**< Quit request event data */
    SDL_UserEvent user;  /**< Custom event data */
    SDL_TouchFingerEvent tfinger;  /**< Touch finger event data */
    SDL_PinchFingerEvent pinch;  /**< Pinch event data */
    SDL_PenProximityEvent pproximity;  /**< Pen proximity event data */
    SDL_PenTouchEvent ptouch;  /**< Pen tip touching event data */
    SDL_PenMotionEvent pmotion;  /**< Pen motion event data */
    SDL_PenButtonEvent pbutton;  /**< Pen button event data */
    SDL_PenAxisEvent paxis;  /**< Pen axis event data */
    SDL_RenderEvent render;  /**< Render event data */
    SDL_DropEvent drop;  /**< Drag and drop event data */
    SDL_ClipboardEvent clipboard;  /**< Clipboard event data */

    /* This is necessary for ABI compatibility between Visual C++ and GCC.
       Visual C++ will respect the push pack pragma and use 52 bytes (size of
       SDL_TextEditingEvent, the largest structure for 32-bit and 64-bit
       architectures) for this union, and GCC will use the alignment of the
       largest datatype within the union, which is 8 bytes on 64-bit
       architectures.

       So... we'll add padding to force the size to be the same for both.

       On architectures where pointers are 16 bytes, this needs rounding up to
       the next multiple of 16, 64, and on architectures where pointers are
       even larger the size of SDL_UserEvent will dominate as being 3 pointers.
    */
    char[128] padding;
}


/* Function prototypes */

extern fn void pump_events() @extern("SDL_PumpEvents");

/* @{ */

enum SDL_EventAction : const CInt
{
    ADDEVENT,  /**< Add events to the back of the queue. */
    PEEKEVENT,  /**< Check but don't remove events from the queue front. */
    GETEVENT,  /**< Retrieve/remove events from the front of the queue. */
}

extern fn CInt peep_events(SDL_Event* events, CInt numevents, SDL_EventAction action, uint minType, uint maxType) @extern("SDL_PeepEvents");
/* @} */

extern fn bool has_event(uint type) @extern("SDL_HasEvent");


extern fn bool has_events(uint minType, uint maxType) @extern("SDL_HasEvents");

extern fn void flush_event(uint type) @extern("SDL_FlushEvent");

extern fn void flush_events(uint minType, uint maxType) @extern("SDL_FlushEvents");

extern fn bool poll_event(SDL_Event* event) @extern("SDL_PollEvent");

extern fn bool wait_event(SDL_Event* event) @extern("SDL_WaitEvent");

extern fn bool wait_event_timeout(SDL_Event* event, int timeoutMS) @extern("SDL_WaitEventTimeout");

extern fn bool push_event(SDL_Event* event) @extern("SDL_PushEvent");

alias SDL_EventFilter = fn bool(void* userdata, SDL_Event* event);

extern fn void set_event_filter(SDL_EventFilter filter, void* userdata) @extern("SDL_SetEventFilter");

extern fn bool get_event_filter(SDL_EventFilter* filter, void** userdata) @extern("SDL_GetEventFilter");

extern fn bool add_event_watch(SDL_EventFilter filter, void* userdata) @extern("SDL_AddEventWatch");

extern fn void remove_event_watch(SDL_EventFilter filter, void* userdata) @extern("SDL_RemoveEventWatch");

extern fn void filter_events(SDL_EventFilter filter, void* userdata) @extern("SDL_FilterEvents");

extern fn void set_event_enabled(uint type, bool enabled) @extern("SDL_SetEventEnabled");

extern fn bool event_enabled(uint type) @extern("SDL_EventEnabled");

extern fn uint register_events(CInt numevents) @extern("SDL_RegisterEvents");

extern fn SDL_Window* get_window_from_event(SDL_Event* event) @extern("SDL_GetWindowFromEvent");

extern fn CInt get_event_description(SDL_Event* event, char* buf, CInt buflen) @extern("SDL_GetEventDescription");
