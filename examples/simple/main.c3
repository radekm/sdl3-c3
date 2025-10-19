module main;

import sdl;

SDL_Window* window;
SDL_GPUDevice* device;

fn SDL_AppResult app_init(void** appstate, int argc, char** argv) @export("SDL_AppInit")
{
    // Create a window.
    window = sdl::create_window("Hello, Triangle!", 960, 540, RESIZABLE);

    // Create the device.
    device = sdl::create_gpu_device(MSL, false, null);
    if (!device) abort("No device created");

    sdl::claim_window_for_gpu_device(device, window);

    return CONTINUE;
}

fn SDL_AppResult app_iterate(void* appstate) @export("SDL_AppIterate")
{
    SDL_GPUCommandBuffer* command_buffer = sdl::acquire_gpu_command_buffer(device);

    SDL_GPUTexture* swapchain_texture;
    uint width, height;
    sdl::wait_and_acquire_gpu_swapchain_texture(command_buffer, window, &swapchain_texture, &width, &height);

    // End the frame early if a swapchain texture is not available (eg. window is minimized).
    if (swapchain_texture == null)
    {
        // We must always submit the command buffer.
        sdl::submit_gpu_command_buffer(command_buffer);
        return CONTINUE;
    }

    SDL_GPUColorTargetInfo color_target_info = {
        .clear_color = {255/255.0, 219/255.0, 187/255.0, 255/255.0},
        .load_op = CLEAR,
        .store_op = STORE,
        .texture = swapchain_texture,
    };

    SDL_GPURenderPass* render_pass = sdl::begin_gpu_render_pass(command_buffer, &color_target_info, 1, null);

    sdl::end_gpu_render_pass(render_pass);

    sdl::submit_gpu_command_buffer(command_buffer);

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

fn void app_quit(void* appstate, SDL_AppResult result) @export("SDL_AppQuit")
{
    sdl::destroy_gpu_device(device);

    // Destroy the window.
    sdl::destroy_window(window);
}
