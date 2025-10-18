module sdl;

::LINE:: #ifndef SDL_power_h_
::LINE:: #define SDL_power_h_



/* Set up for C function definitions, even when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: extern "C" {
::LINE:: #endif

enum SDL_PowerState : const CInt
{
    ERROR = -1,  /**< error determining power status */
    UNKNOWN,  /**< cannot determine power status */
    ON_BATTERY,  /**< Not plugged in, running on the battery */
    NO_BATTERY,  /**< Plugged in, no battery available */
    CHARGING,  /**< Plugged in, charging battery */
    CHARGED,  /**< Plugged in, battery charged */
}

extern fn SDL_PowerState get_power_info(CInt* seconds, CInt* percent) @extern("SDL_GetPowerInfo");

/* Ends C function definitions when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: }
::LINE:: #endif

::LINE:: #endif /* SDL_power_h_ */
