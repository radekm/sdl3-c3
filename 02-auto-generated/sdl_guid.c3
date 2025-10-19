module sdl;

/* WIKI CATEGORY: GUID */


::LINE:: #ifndef SDL_guid_h_
::LINE:: #define SDL_guid_h_


/* Set up for C function definitions, even when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: extern "C" {
::LINE:: #endif

struct SDL_GUID
{
    char[16] data;
}

/* Function prototypes */

extern fn void guid_to_string(SDL_Guid guid, char* pszGUID, CInt cbGUID) @extern("SDL_GUIDToString");

extern fn SDL_Guid string_to_guid(ZString pchGUID) @extern("SDL_StringToGUID");

/* Ends C function definitions when using C++ */
::LINE:: #ifdef __cplusplus
::LINE:: }
::LINE:: #endif

::LINE:: #endif /* SDL_guid_h_ */
