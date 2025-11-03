module main;

import std;
import sdl;

char[*] metal_shaders = $embed("shaders/simplest.metal");
char[*] spirv_shaders = $embed("shaders/simplest.spv");
char[*] dxil_shaders = $embed("shaders/simplest.dxil");

Context context;

SDL_GPUGraphicsPipeline* pipeline;
SDL_GPUBuffer* vertex_buffer;

fn SDL_AppResult app_init(void** appstate, int argc, char** argv) @export("SDL_AppInit")
{
    context.example_name = "BasicVertexBuffer";
    common_init(&context, 0);

    SDL_GPUShader* vertex_shader;
    SDL_GPUShader* fragment_shader;
    load_shaders(&context, &metal_shaders, &spirv_shaders, &dxil_shaders, &vertex_shader, &fragment_shader);

    // Create the pipeline
    SDL_GPUGraphicsPipelineCreateInfo pipelineCreateInfo = {
    };

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

        // This is set up to match the vertex shader layout!
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

    pipeline = sdl::create_gpu_graphics_pipeline(context.device, &pipeline_create_info);
    if (!pipeline) abort_with_sdl_error("Pipeline creation failed");

    // Clean up shader resources.
    sdl::release_gpu_shader(context.device, fragment_shader);
    sdl::release_gpu_shader(context.device, vertex_shader);

    // Create the vertex buffer.
    vertex_buffer = sdl::create_gpu_buffer(
        context.device,
        &&(SDL_GPUBufferCreateInfo){
            .usage = VERTEX,
            .size = PositionColorVertex.sizeof * 3,
        });
    if (!vertex_buffer) abort_with_sdl_error("create_gpu_buffer failed");

    // To get data into the vertex buffer, we have to use a transfer buffer
    SDL_GPUTransferBuffer* transfer_buffer = sdl::create_gpu_transfer_buffer(
        context.device,
        &&(SDL_GPUTransferBufferCreateInfo){
            .usage = UPLOAD,
            .size = PositionColorVertex.sizeof * 3,
        });
    if (!transfer_buffer) abort_with_sdl_error("create_gpu_transfer_buffer failed");

    PositionColorVertex* transfer_data = sdl::map_gpu_transfer_buffer(context.device, transfer_buffer, false);
    if (!transfer_data) abort_with_sdl_error("map_gpu_transfer_buffer failed");

    transfer_data[0] = { -1, -1, 0, 255,   0,   0, 255 };
    transfer_data[1] = {  1, -1, 0,   0, 255,   0, 255 };
    transfer_data[2] = {  0,  1, 0,   0,   0, 255, 255 };

    sdl::unmap_gpu_transfer_buffer(context.device, transfer_buffer);

    // Upload the transfer data to the vertex buffer
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
            .size = PositionColorVertex.sizeof * 3,
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

        SDL_GPURenderPass* render_pass = sdl::begin_gpu_render_pass(cmdbuf, &color_target_info, 1, null);

        sdl::bind_gpu_graphics_pipeline(render_pass, pipeline);
        sdl::bind_gpu_vertex_buffers(render_pass, 0, &&(SDL_GPUBufferBinding){ .buffer = vertex_buffer, .offset = 0 }, 1);
        sdl::draw_gpu_primitives(render_pass, 3, 1, 0, 0);

        sdl::end_gpu_render_pass(render_pass);
    }

    if (!sdl::submit_gpu_command_buffer(cmdbuf)) abort_with_sdl_error("submit_gpu_command_buffer failed");

    return CONTINUE;
}

fn void app_quit(void* appstate, SDL_AppResult result) @export("SDL_AppQuit")
{
    sdl::release_gpu_graphics_pipeline(context.device, pipeline);
    sdl::release_gpu_buffer(context.device, vertex_buffer);

    common_quit(&context);
}
