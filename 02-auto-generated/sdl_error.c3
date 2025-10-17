module sdl;


::LINE:: #ifndef SDL_error_h_
::LINE:: #define SDL_error_h_


/* Set up for C function definitions, even when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: extern "C" {
::LINE:: #endif

/* Public functions */


::LINE:: extern SDL_DECLSPEC bool SDLCALL SDL_SetError(SDL_PRINTF_FORMAT_STRING const char *fmt, ...) SDL_PRINTF_VARARG_FUNC(1);

::LINE:: extern SDL_DECLSPEC bool SDLCALL SDL_SetErrorV(SDL_PRINTF_FORMAT_STRING const char *fmt, va_list ap) SDL_PRINTF_VARARG_FUNCV(1);

extern fn bool out_of_memory() @extern("SDL_OutOfMemory");

extern fn ZString get_error() @extern("SDL_GetError");

extern fn bool clear_error() @extern("SDL_ClearError");

/* @{ */

::LINE:: #define SDL_Unsupported()               SDL_SetError("That operation is not supported")

::LINE:: #define SDL_InvalidParamError(param)    SDL_SetError("Parameter '%s' is invalid", (param))

/* @} *//* Internal error functions */

/* Ends C function definitions when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: }
::LINE:: #endif

::LINE:: #endif /* SDL_error_h_ */
