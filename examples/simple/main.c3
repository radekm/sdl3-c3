module main;

import sdl;

SDL_Window* window;

fn SDL_AppResult sdl_app_init(void** appstate, int argc, char** argv) @export("SDL_AppInit")
{
    // Create a window.
    window = sdl::create_window("Hello, Triangle!", 960, 540, RESIZABLE);

    return CONTINUE;
}

fn SDL_AppResult sdl_app_iterate(void* appstate) @export("SDL_AppIterate")
{
    return CONTINUE;
}

fn SDL_AppResult sdl_app_event(void* appstate, SDL_Event* event) @export("SDL_AppEvent")
{
    // Close the window on request.
    if (event.type == WINDOW_CLOSE_REQUESTED)
    {
        return SUCCESS;
    }

    return CONTINUE;
}

fn void sdl_app_quit(void* appstate, SDL_AppResult result) @export("SDL_AppQuit")
{
    // Destroy the window.
    sdl::destroy_window(window);
}
