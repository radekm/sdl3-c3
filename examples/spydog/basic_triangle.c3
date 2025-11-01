module main;

import std;
import sdl;

char[*] metal_shaders = $embed("shaders/basic_triangle.metal");
char[*] spirv_shaders = $embed("shaders/basic_triangle.spv");
char[*] dxil_shaders = $embed("shaders/basic_triangle.dxil");

Context context;

SDL_GPUGraphicsPipeline* fill_pipeline;
SDL_GPUGraphicsPipeline* line_pipeline;
SDL_GPUViewport small_viewport = { 160.0, 120.0, 320.0, 240.0, 0.1, 1.0 };
SDL_Rect scissor_rect = { 320, 240, 320, 240 };

bool use_wireframe_mode;
bool use_small_viewport;
bool use_scissor_rect;

fn SDL_AppResult app_init(void** appstate, int argc, char** argv) @export("SDL_AppInit")
{
    context.example_name = "BasicTriangle";
    common_init(&context, RESIZABLE);

    SDL_GPUShader* vertex_shader;
    SDL_GPUShader* fragment_shader;
    load_shaders(&context, &metal_shaders, &spirv_shaders, &dxil_shaders, &vertex_shader, &fragment_shader);

    // Create the pipelines.
    SDL_GPUGraphicsPipelineCreateInfo pipeline_create_info = {
        .target_info = {
            .num_color_targets = 1,
            .color_target_descriptions = &&(SDL_GPUColorTargetDescription[*]){
                {
                    .format = sdl::get_gpu_swapchain_texture_format(context.device, context.window),
                },
            },
        },
        .primitive_type = TRIANGLELIST,
        .vertex_shader = vertex_shader,
        .fragment_shader = fragment_shader,
    };

    pipeline_create_info.rasterizer_state.fill_mode = FILL;
    fill_pipeline = sdl::create_gpu_graphics_pipeline(context.device, &pipeline_create_info);
    if (!fill_pipeline) abort_with_sdl_error("Fill pipeline creation failed");

    pipeline_create_info.rasterizer_state.fill_mode = LINE;
    line_pipeline = sdl::create_gpu_graphics_pipeline(context.device, &pipeline_create_info);
    if (!line_pipeline) abort_with_sdl_error("Line pipeline creation failed");

    // Clean up shader resources.
    sdl::release_gpu_shader(context.device, fragment_shader);
    sdl::release_gpu_shader(context.device, vertex_shader);

    // Finally, print instructions!
    io::printfn("Press Left to toggle wireframe mode");
    io::printfn("Press Down to toggle small viewport");
    io::printfn("Press Right to toggle scissor rect");

    return CONTINUE;
}

fn SDL_AppResult app_event(void* appstate, SDL_Event* event) @export("SDL_AppEvent")
{
    // Close the window on request.
    if (event.type == WINDOW_CLOSE_REQUESTED)
    {
        return SUCCESS;
    }

    common_update(&context, event);
    if (context.left_pressed) use_wireframe_mode = !use_wireframe_mode;
    if (context.down_pressed) use_small_viewport = !use_small_viewport;
    if (context.right_pressed) use_scissor_rect = !use_scissor_rect;

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
            .clear_color = {0, 0, 0, 1},
            .load_op = CLEAR,
            .store_op = STORE,
            .texture = swapchain_texture,
        };

        SDL_GPURenderPass* render_pass = sdl::begin_gpu_render_pass(cmdbuf, &color_target_info, 1, null);

        sdl::bind_gpu_graphics_pipeline(render_pass, use_wireframe_mode ? line_pipeline : fill_pipeline);
        if (use_small_viewport)
        {
            sdl::set_gpu_viewport(render_pass, &small_viewport);
        }
        if (use_scissor_rect)
        {
            sdl::set_gpu_scissor(render_pass, &scissor_rect);
        }
        sdl::draw_gpu_primitives(render_pass, 3, 1, 0, 0);

        sdl::end_gpu_render_pass(render_pass);
    }

    if (!sdl::submit_gpu_command_buffer(cmdbuf)) abort_with_sdl_error("submit_gpu_command_buffer failed");

    return CONTINUE;
}

fn void app_quit(void* appstate, SDL_AppResult result) @export("SDL_AppQuit")
{
    sdl::release_gpu_graphics_pipeline(context.device, fill_pipeline);
    sdl::release_gpu_graphics_pipeline(context.device, line_pipeline);

    common_quit(&context);
}
