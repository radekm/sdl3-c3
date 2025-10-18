module sdl;

struct SDL_Guid
{
    char[16] data;
}

/* Function prototypes */

extern fn void guid_to_string(SDL_Guid guid, char* pszGUID, CInt cbGUID) @extern("SDL_GUIDToString");

extern fn SDL_Guid string_to_guid(ZString pchGUID) @extern("SDL_StringToGUID");
