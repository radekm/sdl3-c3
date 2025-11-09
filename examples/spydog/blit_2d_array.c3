module main;

import std;
import sdl;

char[*] metal_shaders = $embed("shaders/blit_2d_array.metal");
char[*] spirv_shaders = $embed("shaders/blit_2d_array.spv");
char[*] dxil_shaders = $embed("shaders/blit_2d_array.dxil");

char[*] image_bytes1 = $embed("images/ravioli.bmp");
char[*] image_bytes2 = $embed("images/ravioli_inverted.bmp");

Context context;

SDL_GPUGraphicsPipeline* pipeline;
SDL_GPUBuffer* vertex_buffer;
SDL_GPUBuffer* index_buffer;
SDL_GPUTexture* source_texture;
SDL_GPUTexture* destination_texture;
SDL_GPUSampler* sampler;

fn SDL_AppResult app_init(void** appstate, int argc, char** argv) @export("SDL_AppInit")
{
    context.example_name = "Blit2DArray";
    common_init(&context, 0);

    SDL_GPUShader* vertex_shader;
    SDL_GPUShader* fragment_shader;
    load_shaders(
        &context, &metal_shaders, &spirv_shaders, &dxil_shaders,
        &vertex_shader, &fragment_shader,
        fragment_num_samplers: 1);

    // Create the pipeline.
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
                .pitch = PositionTextureVertex.sizeof,
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
                    .format = FLOAT2,
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

    // Load the images.
    SDL_Surface* image_data1 = load_image(&image_bytes1, 4);
    SDL_Surface* image_data2 = load_image(&image_bytes2, 4);

    if (image_data1.w != image_data2.w || image_data1.h != image_data2.h) abort("Images don't have same size");

    uint src_width = image_data1.w;
    uint src_height = image_data1.h;

    // Create the GPU resources.
    vertex_buffer = sdl::create_gpu_buffer(
        context.device,
        &&(SDL_GPUBufferCreateInfo){
            .usage = VERTEX,
            .size = PositionTextureVertex.sizeof * 8,
        });
    if (!vertex_buffer) abort_with_sdl_error("create_gpu_buffer failed");

    index_buffer = sdl::create_gpu_buffer(
        context.device,
        &&(SDL_GPUBufferCreateInfo){
            .usage = INDEX,
            .size = ushort.sizeof * 6,
        });
    if (!index_buffer) abort_with_sdl_error("create_gpu_buffer failed");

    source_texture = sdl::create_gpu_texture(
        context.device,
        &&(SDL_GPUTextureCreateInfo){
            .format = R8G8B8A8_UNORM,
            .type = TYPE_2D_ARRAY,
            .width = src_width,
            .height = src_height,
            .layer_count_or_depth = 2,
            .num_levels = 1,
            .usage = SAMPLER,
        });
    if (!source_texture) abort_with_sdl_error("create_gpu_texture failed");

    destination_texture = sdl::create_gpu_texture(
        context.device,
        &&(SDL_GPUTextureCreateInfo){
            .format = R8G8B8A8_UNORM,
            .type = TYPE_2D_ARRAY,
            .width = src_width / 2,
            .height = src_height / 2,
            .layer_count_or_depth = 2,
            .num_levels = 1,
            .usage = SDL_GPUTextureUsageFlags.SAMPLER | SDL_GPUTextureUsageFlags.COLOR_TARGET,
        });
    if (!destination_texture) abort_with_sdl_error("create_gpu_texture failed");

    sampler = sdl::create_gpu_sampler(
        context.device,
        &&(SDL_GPUSamplerCreateInfo){
            .min_filter = NEAREST,
            .mag_filter = NEAREST,
            .mipmap_mode = NEAREST,
            .address_mode_u = CLAMP_TO_EDGE,
            .address_mode_v = CLAMP_TO_EDGE,
            .address_mode_w = CLAMP_TO_EDGE,
        });
    if (!sampler) abort_with_sdl_error("create_gpu_sampler failed");

    // Set up buffer data.
    SDL_GPUTransferBuffer* buffer_transfer_buffer = sdl::create_gpu_transfer_buffer(
        context.device,
        &&(SDL_GPUTransferBufferCreateInfo){
            .usage = UPLOAD,
            .size = PositionTextureVertex.sizeof * 8 + ushort.sizeof * 6,
        });
    if (!buffer_transfer_buffer) abort_with_sdl_error("create_gpu_transfer_buffer failed");

    PositionTextureVertex* transfer_data = sdl::map_gpu_transfer_buffer(context.device, buffer_transfer_buffer, false);
    if (!transfer_data) abort_with_sdl_error("map_gpu_transfer_buffer failed");

    transfer_data[0] = { -1,  1, 0, 0, 0 };
    transfer_data[1] = {  0,  1, 0, 1, 0 };
    transfer_data[2] = {  0, -1, 0, 1, 1 };
    transfer_data[3] = { -1, -1, 0, 0, 1 };
    transfer_data[4] = {  0,  1, 0, 0, 0 };
    transfer_data[5] = {  1,  1, 0, 1, 0 };
    transfer_data[6] = {  1, -1, 0, 1, 1 };
    transfer_data[7] = {  0, -1, 0, 0, 1 };

    ushort* index_data = (ushort*)&transfer_data[8];
    index_data[0] = 0;
    index_data[1] = 1;
    index_data[2] = 2;
    index_data[3] = 0;
    index_data[4] = 2;
    index_data[5] = 3;

    sdl::unmap_gpu_transfer_buffer(context.device, buffer_transfer_buffer);

    // Set up texture data.
    uint image_size_in_bytes = src_width * src_height * 4;
    SDL_GPUTransferBuffer* texture_transfer_buffer = sdl::create_gpu_transfer_buffer(
        context.device,
        &&(SDL_GPUTransferBufferCreateInfo){
            .usage = UPLOAD,
            .size = image_size_in_bytes * 2,
        });
    if (!texture_transfer_buffer) abort_with_sdl_error("create_gpu_transfer_buffer failed");

    char* texture_transfer_ptr = sdl::map_gpu_transfer_buffer(context.device, texture_transfer_buffer, false);
    if (!texture_transfer_ptr) abort_with_sdl_error("map_gpu_transfer_buffer failed");

    mem::copy(texture_transfer_ptr, image_data1.pixels, image_size_in_bytes);
    mem::copy(texture_transfer_ptr + image_size_in_bytes, image_data2.pixels, image_size_in_bytes);

    sdl::unmap_gpu_transfer_buffer(context.device, texture_transfer_buffer);

    // Upload the transfer data to the GPU resources.
    // Upload the transfer data to the vertex buffer
    SDL_GPUCommandBuffer* upload_cmdbuf = sdl::acquire_gpu_command_buffer(context.device);
    if (!upload_cmdbuf) abort_with_sdl_error("acquire_gpu_command_buffer failed");
    SDL_GPUCopyPass* copy_pass = sdl::begin_gpu_copy_pass(upload_cmdbuf);

    sdl::upload_to_gpu_buffer(
        copy_pass,
        &&(SDL_GPUTransferBufferLocation){
            .transfer_buffer = buffer_transfer_buffer,
            .offset = 0,
        },
        &&(SDL_GPUBufferRegion){
            .buffer = vertex_buffer,
            .offset = 0,
            .size = PositionTextureVertex.sizeof * 8,
        },
        false);
    sdl::upload_to_gpu_buffer(
        copy_pass,
        &&(SDL_GPUTransferBufferLocation){
            .transfer_buffer = buffer_transfer_buffer,
            .offset = PositionTextureVertex.sizeof * 8,
        },
        &&(SDL_GPUBufferRegion){
            .buffer = index_buffer,
            .offset = 0,
            .size = ushort.sizeof * 6,
        },
        false);
    sdl::upload_to_gpu_texture(
        copy_pass,
        &&(SDL_GPUTextureTransferInfo){
            .transfer_buffer = texture_transfer_buffer,
            .offset = 0,
        },
        &&(SDL_GPUTextureRegion){
            .texture = source_texture,
            .layer = 0,
            .w = src_width,
            .h = src_height,
            .d = 1,
        },
        false);

    sdl::upload_to_gpu_texture(
        copy_pass,
        &&(SDL_GPUTextureTransferInfo){
            .transfer_buffer = texture_transfer_buffer,
            .offset = image_size_in_bytes,
        },
        &&(SDL_GPUTextureRegion){
            .texture = source_texture,
            .layer = 1,
            .w = src_width,
            .h = src_height,
            .d = 1,
        },
        false);

    sdl::destroy_surface(image_data1);
    sdl::destroy_surface(image_data2);
    sdl::end_gpu_copy_pass(copy_pass);

    sdl::blit_gpu_texture(
        upload_cmdbuf,
        &&(SDL_GPUBlitInfo){
            .source.texture = source_texture,
            .source.w = src_width,
            .source.h = src_height,
            .destination.texture = destination_texture,
            .destination.w = src_width / 2,
            .destination.h = src_height / 2,
            .load_op = DONT_CARE,
            .filter = LINEAR,
        });
    sdl::blit_gpu_texture(
        upload_cmdbuf,
        &&(SDL_GPUBlitInfo){
            .source.texture = source_texture,
            .source.layer_or_depth_plane = 1,
            .source.w = src_width,
            .source.h = src_height,
            .destination.texture = destination_texture,
            .destination.layer_or_depth_plane = 1,
            .destination.w = src_width / 2,
            .destination.h = src_height / 2,
            .load_op = LOAD,
            .filter = LINEAR,
        });

    if (!sdl::submit_gpu_command_buffer(upload_cmdbuf)) abort_with_sdl_error("submit_gpu_command_buffer failed");
    sdl::release_gpu_transfer_buffer(context.device, buffer_transfer_buffer);
    sdl::release_gpu_transfer_buffer(context.device, texture_transfer_buffer);

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
        sdl::bind_gpu_index_buffer(render_pass, &&(SDL_GPUBufferBinding){ .buffer = index_buffer, .offset = 0 }, SIZE_16BIT);
        sdl::bind_gpu_fragment_samplers(render_pass, 0, &&(SDL_GPUTextureSamplerBinding){ .texture = source_texture, .sampler = sampler }, 1);
        sdl::draw_gpu_indexed_primitives(render_pass, 6, 1, 0, 0, 0);
        sdl::bind_gpu_fragment_samplers(render_pass, 0, &&(SDL_GPUTextureSamplerBinding){ .texture = destination_texture, .sampler = sampler }, 1);
        sdl::draw_gpu_indexed_primitives(render_pass, 6, 1, 0, 4, 0);

        sdl::end_gpu_render_pass(render_pass);
    }

    if (!sdl::submit_gpu_command_buffer(cmdbuf)) abort_with_sdl_error("submit_gpu_command_buffer failed");

    return CONTINUE;
}

fn void app_quit(void* appstate, SDL_AppResult result) @export("SDL_AppQuit")
{
    sdl::release_gpu_graphics_pipeline(context.device, pipeline);
    sdl::release_gpu_buffer(context.device, vertex_buffer);
    sdl::release_gpu_buffer(context.device, index_buffer);
    sdl::release_gpu_texture(context.device, source_texture);
    sdl::release_gpu_texture(context.device, destination_texture);
    sdl::release_gpu_sampler(context.device, sampler);

    common_quit(&context);
}
