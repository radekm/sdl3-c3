module sdl;

typedef SDL_PenID = uint;

const SDL_MouseID PEN_MOUSEID = (SDL_MouseID)-2;

const SDL_TouchID PEN_TOUCHID = (SDL_TouchID)-2;

enum SDL_PenInputFlags : const uint
{
    DOWN        = 1u << 0,  /**< pen is pressed down */
    BUTTON_1    = 1u << 1,  /**< button 1 is pressed */
    BUTTON_2    = 1u << 2,  /**< button 2 is pressed */
    BUTTON_3    = 1u << 3,  /**< button 3 is pressed */
    BUTTON_4    = 1u << 4,  /**< button 4 is pressed */
    BUTTON_5    = 1u << 5,  /**< button 5 is pressed */
    ERASER_TIP  = 1u << 30, /**< eraser tip is used */
}

enum SDL_PenAxis : const CInt
{
    PRESSURE,  /**< Pen pressure.  Unidirectional: 0 to 1.0 */
    XTILT,  /**< Pen horizontal tilt angle.  Bidirectional: -90.0 to 90.0 (left-to-right). */
    YTILT,  /**< Pen vertical tilt angle.  Bidirectional: -90.0 to 90.0 (top-to-down). */
    DISTANCE,  /**< Pen distance to drawing surface.  Unidirectional: 0.0 to 1.0 */
    ROTATION,  /**< Pen barrel rotation.  Bidirectional: -180 to 179.9 (clockwise, 0 is facing up, -180.0 is facing down). */
    SLIDER,  /**< Pen finger wheel or slider (e.g., Airbrush Pen).  Unidirectional: 0 to 1.0 */
    TANGENTIAL_PRESSURE,  /**< Pressure from squeezing the pen ("barrel pressure"). */
    COUNT,  /**< Total known pen axis types in this version of SDL. This number may grow in future releases! */
}

enum SDL_PenDeviceType : const CInt
{
    INVALID = -1,  /**< Not a valid pen device. */
    UNKNOWN,  /**< Don't know specifics of this pen. */
    DIRECT,  /**< Pen touches display. */
    INDIRECT,  /**< Pen touches something that isn't the display. */
}

extern fn SDL_PenDeviceType get_pen_device_type(SDL_PenID instance_id) @extern("SDL_GetPenDeviceType");
