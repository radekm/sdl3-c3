module main;

import std;
import sdl;

Context context;

fn SDL_AppResult app_init(void** appstate, int argc, char** argv) @export("SDL_AppInit")
{
    common_init(&context, RESIZABLE);
    return CONTINUE;
}

fn SDL_AppResult app_event(void* appstate, SDL_Event* event) @export("SDL_AppEvent")
{
    // Close the window on request.
    if (event.type == WINDOW_CLOSE_REQUESTED)
    {
        return SUCCESS;
    }

    return CONTINUE;
}


fn SDL_AppResult app_iterate(void* appstate) @export("SDL_AppIterate")
{
    SDL_GPUCommandBuffer* cmdbuf = sdl::acquire_gpu_command_buffer(context.device);
    if (!cmdbuf) abort_with_sdl_error("acquire_gpu_command_buffer failed");

    SDL_GPUTexture* swapchain_texture;
    bool ok = sdl::wait_and_acquire_gpu_swapchain_texture(cmdbuf, context.window, &swapchain_texture, null, null);
    if (!ok) abort_with_sdl_error("wait_and_acquire_gpu_swapchain_texture failed");

    // Draw only if swapchain texture is available (eg. window is not minimized).
    if (swapchain_texture)
    {
        SDL_GPUColorTargetInfo color_target_info = {
            .clear_color = {0.3, 0.4, 0.5, 1.0},
            .load_op = CLEAR,
            .store_op = STORE,
            .texture = swapchain_texture,
        };

        SDL_GPURenderPass* render_pass = sdl::begin_gpu_render_pass(cmdbuf, &color_target_info, 1, null);
        sdl::end_gpu_render_pass(render_pass);
    }

    if (!sdl::submit_gpu_command_buffer(cmdbuf)) abort_with_sdl_error("submit_gpu_command_buffer failed");

    return CONTINUE;
}

fn void app_quit(void* appstate, SDL_AppResult result) @export("SDL_AppQuit")
{
    common_quit(&context);
}
