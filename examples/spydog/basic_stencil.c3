module main;

import std;
import sdl;

char[*] metal_shaders = $embed("shaders/basic_stencil.metal");
char[*] spirv_shaders = $embed("shaders/basic_stencil.spv");
char[*] dxil_shaders = $embed("shaders/basic_stencil.dxil");

Context context;

SDL_GPUGraphicsPipeline* masker_pipeline;
SDL_GPUGraphicsPipeline* maskee_pipeline;
SDL_GPUBuffer* vertex_buffer;
SDL_GPUTexture* depth_stencil_texture;

fn SDL_AppResult app_init(void** appstate, int argc, char** argv) @export("SDL_AppInit")
{
    context.example_name = "BasicStencil";
    common_init(&context, 0);

    SDL_GPUShader* vertex_shader;
    SDL_GPUShader* fragment_shader;
    load_shaders(&context, &metal_shaders, &spirv_shaders, &dxil_shaders, &vertex_shader, &fragment_shader);

    SDL_GPUTextureFormat depth_stencil_format;
    switch {
        case sdl::gpu_texture_supports_format(context.device, D24_UNORM_S8_UINT, TYPE_2D, DEPTH_STENCIL_TARGET):
            depth_stencil_format = D24_UNORM_S8_UINT;
        case sdl::gpu_texture_supports_format(context.device, D32_FLOAT_S8_UINT, TYPE_2D, DEPTH_STENCIL_TARGET):
            depth_stencil_format = D32_FLOAT_S8_UINT;
        default:
            abort("Stencil formats not supported!");
    }

    SDL_GPUGraphicsPipelineCreateInfo pipeline_create_info = {
        .target_info = {
            .num_color_targets = 1,
            .color_target_descriptions = &&(SDL_GPUColorTargetDescription[*]){
                {
                    .format = sdl::get_gpu_swapchain_texture_format(context.device, context.window),
                },
            },
            .has_depth_stencil_target = true,
            .depth_stencil_format = depth_stencil_format,
        },
        .depth_stencil_state = {
            .enable_stencil_test = true,
            .front_stencil_state = {
                .compare_op = NEVER,
                .fail_op = REPLACE,
                .pass_op = KEEP,
                .depth_fail_op = KEEP,
            },
            .back_stencil_state = {
                .compare_op = NEVER,
                .fail_op = REPLACE,
                .pass_op = KEEP,
                .depth_fail_op = KEEP,
            },
            .write_mask = 0xFF,
        },
        .rasterizer_state = {
            .cull_mode = NONE,
            .fill_mode = FILL,
            .front_face = COUNTER_CLOCKWISE,
        },
        .vertex_input_state = {
            .num_vertex_buffers = 1,
            .vertex_buffer_descriptions = &&(SDL_GPUVertexBufferDescription[*]){
                {
                    .slot = 0,
                    .input_rate = VERTEX,
                    .instance_step_rate = 0,
                    .pitch = PositionColorVertex.sizeof,
                },
            },
            .num_vertex_attributes = 2,
            .vertex_attributes = &&(SDL_GPUVertexAttribute[*]){
                {
                    .buffer_slot = 0,
                    .format = FLOAT3,
                    .location = 0,
                    .offset = 0,
                },
                {
                    .buffer_slot = 0,
                    .format = UBYTE4_NORM,
                    .location = 1,
                    .offset = float.sizeof * 3,
                },
            },
        },
        .primitive_type = TRIANGLELIST,
        .vertex_shader = vertex_shader,
        .fragment_shader = fragment_shader,
    };

    masker_pipeline = sdl::create_gpu_graphics_pipeline(context.device, &pipeline_create_info);
    if (!masker_pipeline) abort_with_sdl_error("Masker pipeline creation failed");

    pipeline_create_info.depth_stencil_state = {
        .enable_stencil_test = true,
        .front_stencil_state = {
            .compare_op = EQUAL,
            .fail_op = KEEP,
            .pass_op = KEEP,
            .depth_fail_op = KEEP,
        },
        .back_stencil_state = {
            .compare_op = NEVER,
            .fail_op = KEEP,
            .pass_op = KEEP,
            .depth_fail_op = KEEP,
        },
        .compare_mask = 0xFF,
        .write_mask = 0,
    };

    maskee_pipeline = sdl::create_gpu_graphics_pipeline(context.device, &pipeline_create_info);
    if (!maskee_pipeline) abort_with_sdl_error("Maskee pipeline creation failed");

    sdl::release_gpu_shader(context.device, fragment_shader);
    sdl::release_gpu_shader(context.device, vertex_shader);

    vertex_buffer = sdl::create_gpu_buffer(
        context.device,
        &&{
            .usage = VERTEX,
            .size = PositionColorVertex.sizeof * 6,
        });
    if (!vertex_buffer) abort_with_sdl_error("create_gpu_buffer failed");

    CInt w, h;
    sdl::get_window_size_in_pixels(context.window, &w, &h);

    depth_stencil_texture = sdl::create_gpu_texture(
        context.device,
        &&{
            .type = TYPE_2D,
            .width = w,
            .height = h,
            .layer_count_or_depth = 1,
            .num_levels = 1,
            .sample_count = COUNT_1,
            .format = depth_stencil_format,
            .usage = DEPTH_STENCIL_TARGET,
        });
    if (!depth_stencil_texture) abort_with_sdl_error("create_gpu_texture failed");

    SDL_GPUTransferBuffer* transfer_buffer = sdl::create_gpu_transfer_buffer(
        context.device,
        &&{
            .usage = UPLOAD,
            .size = PositionColorVertex.sizeof * 6,
        });
    if (!transfer_buffer) abort_with_sdl_error("create_gpu_transfer_buffer failed");

    PositionColorVertex* transfer_data = sdl::map_gpu_transfer_buffer(context.device, transfer_buffer, false);
    if (!transfer_data) abort_with_sdl_error("map_gpu_transfer_buffer failed");

    transfer_data[0] = { -0.5, -0.5, 0, 255, 255,   0, 255 };
    transfer_data[1] = {  0.5, -0.5, 0, 255, 255,   0, 255 };
    transfer_data[2] = {    0,  0.5, 0, 255, 255,   0, 255 };
    transfer_data[3] = {   -1,   -1, 0, 255,   0,   0, 255 };
    transfer_data[4] = {    1,   -1, 0,   0, 255,   0, 255 };
    transfer_data[5] = {    0,    1, 0,   0,   0, 255, 255 };

    sdl::unmap_gpu_transfer_buffer(context.device, transfer_buffer);

    SDL_GPUCommandBuffer* upload_cmdbuf = sdl::acquire_gpu_command_buffer(context.device);
    if (!upload_cmdbuf) abort_with_sdl_error("acquire_gpu_command_buffer failed");
    SDL_GPUCopyPass* copy_pass = sdl::begin_gpu_copy_pass(upload_cmdbuf);

    sdl::upload_to_gpu_buffer(
        copy_pass,
        &&(SDL_GPUTransferBufferLocation){
            .transfer_buffer = transfer_buffer,
            .offset = 0,
        },
        &&(SDL_GPUBufferRegion){
            .buffer = vertex_buffer,
            .offset = 0,
            .size = PositionColorVertex.sizeof * 6,
        },
        false);

    sdl::end_gpu_copy_pass(copy_pass);
    if (!sdl::submit_gpu_command_buffer(upload_cmdbuf)) abort_with_sdl_error("submit_gpu_command_buffer failed");
    sdl::release_gpu_transfer_buffer(context.device, transfer_buffer);

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
            .clear_color = {0, 0, 0, 1},
            .load_op = CLEAR,
            .store_op = STORE,
            .texture = swapchain_texture,
        };

        SDL_GPUDepthStencilTargetInfo depth_stencil_target_info = {
            .texture = depth_stencil_texture,
            .cycle = true,
            .clear_depth = 0,
            .clear_stencil = 0,
            .load_op = CLEAR,
            .store_op = DONT_CARE,
            .stencil_load_op = CLEAR,
            .stencil_store_op = DONT_CARE,
        };

        SDL_GPURenderPass* render_pass = sdl::begin_gpu_render_pass(
            cmdbuf, &color_target_info, 1, &depth_stencil_target_info);

        sdl::bind_gpu_vertex_buffers(render_pass, 0, &&{ .buffer = vertex_buffer, .offset = 0 }, 1);

        sdl::set_gpu_stencil_reference(render_pass, 1);
        sdl::bind_gpu_graphics_pipeline(render_pass, masker_pipeline);
        sdl::draw_gpu_primitives(render_pass, 3, 1, 0, 0);

        sdl::set_gpu_stencil_reference(render_pass, 0);
        sdl::bind_gpu_graphics_pipeline(render_pass, maskee_pipeline);
        sdl::draw_gpu_primitives(render_pass, 3, 1, 3, 0);

        sdl::end_gpu_render_pass(render_pass);
    }

    if (!sdl::submit_gpu_command_buffer(cmdbuf)) abort_with_sdl_error("submit_gpu_command_buffer failed");

    return CONTINUE;
}

fn void app_quit(void* appstate, SDL_AppResult result) @export("SDL_AppQuit")
{
    sdl::release_gpu_graphics_pipeline(context.device, maskee_pipeline);
    sdl::release_gpu_graphics_pipeline(context.device, masker_pipeline);

    sdl::release_gpu_texture(context.device, depth_stencil_texture);
    sdl::release_gpu_buffer(context.device, vertex_buffer);

    common_quit(&context);
}
