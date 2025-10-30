module main;

import std;
import sdl;

struct Context
{
    ZString example_name;
    ZString base_path;
    SDL_Window* window;
    SDL_GPUDevice* device;
    bool left_pressed;
    bool right_pressed;
    bool down_pressed;
    bool up_pressed;
    float delta_time;
}

fn void abort_with_sdl_error(String problem) @noreturn
{
    abort("%s: %s", problem, sdl::get_error());
}

fn void common_init(Context* context, SDL_WindowFlags window_flags)
{
    context.window = sdl::create_window(context.example_name, 640, 480, window_flags);
    if (!context.window) abort_with_sdl_error("No window created");

    context.device = sdl::create_gpu_device(
        SDL_GPUShaderFormat.MSL | SDL_GPUShaderFormat.SPIRV | SDL_GPUShaderFormat.DXIL,
        true,
        null);
    if (!context.device) abort_with_sdl_error("No device created");

    bool ok = sdl::claim_window_for_gpu_device(context.device, context.window);
    if (!ok) abort_with_sdl_error("claim_window_for_gpu_device failed");
}

fn void common_quit(Context* context)
{
    sdl::release_window_from_gpu_device(context.device, context.window);
    sdl::destroy_window(context.window);
    sdl::destroy_gpu_device(context.device);
}
