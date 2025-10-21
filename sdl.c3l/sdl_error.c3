module sdl;

/* Public functions */


extern fn bool set_error(ZString format, ...) @extern("SDL_SetError");

extern fn bool out_of_memory() @extern("SDL_OutOfMemory");

extern fn ZString get_error() @extern("SDL_GetError");

extern fn bool clear_error() @extern("SDL_ClearError");
