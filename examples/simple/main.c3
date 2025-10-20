module main;

import std;
import sdl;

char[*] metal_shaders = $embed("shaders.metal");
char[*] spirv_shaders = $embed("shaders.spv");
char[*] dxil_shaders = $embed("shaders.dxil");

// The vertex input layout.
struct Vertex
{
    float x, y, z;  // vec3 position.
    float r, g, b, a;  // vec4 color.
}

// A list of vertices.
Vertex[*] vertices =
{
    {0.0, 0.5, 0.0, 1.0, 0.0, 0.0, 1.0},  // Top vertex.
    {-0.5, -0.5, 0.0, 1.0, 1.0, 0.0, 1.0},  // Bottom left vertex.
    {0.5, -0.5, 0.0, 1.0, 0.0, 1.0, 1.0},  // Bottom right vertex.
};

SDL_Window* window;
SDL_GPUDevice* device;
SDL_GPUBuffer* vertex_buffer;
SDL_GPUGraphicsPipeline* graphics_pipeline;

fn SDL_AppResult app_init(void** appstate, int argc, char** argv) @export("SDL_AppInit")
{
    // Create a window.
    window = sdl::create_window("Hello, Triangle!", 960, 540, RESIZABLE);

    // Create the device.
    device = sdl::create_gpu_device(
        SDL_GPUShaderFormat.MSL | SDL_GPUShaderFormat.SPIRV | SDL_GPUShaderFormat.DXIL,
        false, null);
    if (!device) abort("No device created");

    SDL_GPUShaderFormat backend_shader_formats = sdl::get_gpu_shader_formats(device);
    SDL_GPUShaderFormat shader_format;
    char[] shaders_code;
    switch
    {
        case backend_shader_formats & SDL_GPUShaderFormat.MSL != 0:
            shader_format = MSL;
            shaders_code = &metal_shaders;
        case backend_shader_formats & SDL_GPUShaderFormat.SPIRV != 0:
            shader_format = SPIRV;
            shaders_code = &spirv_shaders;
        case backend_shader_formats & SDL_GPUShaderFormat.DXIL != 0:
            shader_format = DXIL;
            shaders_code = &dxil_shaders;
        default:
            abort("Unrecognized backend shader format");
    }

    sdl::claim_window_for_gpu_device(device, window);

    // Create the vertex buffer.
    SDL_GPUBufferCreateInfo buffer_info;
    buffer_info.size = $sizeof(vertices);
    buffer_info.usage = VERTEX;
    vertex_buffer = sdl::create_gpu_buffer(device, &buffer_info);

    // Create a transfer buffer to upload to the vertex buffer.
    SDL_GPUTransferBufferCreateInfo transfer_info;
    transfer_info.size = $sizeof(vertices);
    transfer_info.usage = UPLOAD;
    SDL_GPUTransferBuffer* transfer_buffer = sdl::create_gpu_transfer_buffer(device, &transfer_info);

    // Map the transfer buffer to a pointer.
    Vertex* data = sdl::map_gpu_transfer_buffer(device, transfer_buffer, false);

    mem::copy(data, &vertices, $sizeof(vertices));

    // Unmap the pointer when you are done updating the transfer buffer.
    sdl::unmap_gpu_transfer_buffer(device, transfer_buffer);

    // Start a copy pass.
    SDL_GPUCommandBuffer* command_buffer = sdl::acquire_gpu_command_buffer(device);
    SDL_GPUCopyPass* copy_pass = sdl::begin_gpu_copy_pass(command_buffer);

    // Where is the data.
    SDL_GPUTransferBufferLocation location;
    location.transfer_buffer = transfer_buffer;
    location.offset = 0;  // Start from the beginning.

    // Where to upload the data.
    SDL_GPUBufferRegion region;
    region.buffer = vertex_buffer;
    region.size = $sizeof(vertices);  // Size of the data in bytes.
    region.offset = 0;  // Begin writing from the first vertex.

    // Upload the data.
    sdl::upload_to_gpu_buffer(copy_pass, &location, &region, true);

    // End the copy pass.
    sdl::end_gpu_copy_pass(copy_pass);
    sdl::submit_gpu_command_buffer(command_buffer);

    // Create the vertex shader.
    SDL_GPUShaderCreateInfo vertex_info;
    vertex_info.code = shaders_code.ptr;
    vertex_info.code_size = shaders_code.len;
    vertex_info.entrypoint = "vertexMain";
    vertex_info.format = shader_format;
    vertex_info.stage = VERTEX;
    vertex_info.num_samplers = 0;
    vertex_info.num_storage_buffers = 0;
    vertex_info.num_storage_textures = 0;
    vertex_info.num_uniform_buffers = 0;
    SDL_GPUShader* vertex_shader = sdl::create_gpu_shader(device, &vertex_info);

    // Create the fragment shader.
    SDL_GPUShaderCreateInfo fragment_info;
    fragment_info.code = shaders_code.ptr;
    fragment_info.code_size = shaders_code.len;
    fragment_info.entrypoint = "fragmentMain";
    fragment_info.format = shader_format;
    fragment_info.stage = FRAGMENT;
    fragment_info.num_samplers = 0;
    fragment_info.num_storage_buffers = 0;
    fragment_info.num_storage_textures = 0;
    fragment_info.num_uniform_buffers = 0;
    SDL_GPUShader* fragment_shader = sdl::create_gpu_shader(device, &fragment_info);

    SDL_GPUGraphicsPipelineCreateInfo pipeline_info;

    // Bind shaders.
    pipeline_info.vertex_shader = vertex_shader;
    pipeline_info.fragment_shader = fragment_shader;

    // Draw triangles.
    pipeline_info.primitive_type = TRIANGLELIST;

    // Describe the vertex buffers.
    SDL_GPUVertexBufferDescription[1] vertex_buffer_desctiptions;
    vertex_buffer_desctiptions[0].slot = 0;
    vertex_buffer_desctiptions[0].input_rate = VERTEX;
    vertex_buffer_desctiptions[0].instance_step_rate = 0;
    vertex_buffer_desctiptions[0].pitch = Vertex.sizeof;

    pipeline_info.vertex_input_state.num_vertex_buffers = 1;
    pipeline_info.vertex_input_state.vertex_buffer_descriptions = &vertex_buffer_desctiptions;

    // Describe the vertex attributes.
    SDL_GPUVertexAttribute[2] vertex_attributes;

    // Position.
    vertex_attributes[0].buffer_slot = 0;  // Fetch data from the buffer at slot 0.
    vertex_attributes[0].location = 0;  // Layout (location = 0) in shader.
    vertex_attributes[0].format = FLOAT3;  // vec3.
    vertex_attributes[0].offset = 0;  // Start from the first byte from current buffer position.

    // Color.
    vertex_attributes[1].buffer_slot = 0;  // Use buffer at slot 0.
    vertex_attributes[1].location = 1;  // Layout (location = 1) in shader.
    vertex_attributes[1].format = FLOAT4;  // vec4.
    vertex_attributes[1].offset = float.sizeof * 3;  // 4th float from current buffer position.

    pipeline_info.vertex_input_state.num_vertex_attributes = 2;
    pipeline_info.vertex_input_state.vertex_attributes = &vertex_attributes;

    // Describe the color target.
    SDL_GPUColorTargetDescription[1] color_target_descriptions;
    color_target_descriptions[0].format = sdl::get_gpu_swapchain_texture_format(device, window);

    pipeline_info.target_info.num_color_targets = 1;
    pipeline_info.target_info.color_target_descriptions = &color_target_descriptions;

    // Create the pipeline.
    graphics_pipeline = sdl::create_gpu_graphics_pipeline(device, &pipeline_info);

    sdl::release_gpu_shader(device, fragment_shader);
    sdl::release_gpu_shader(device, vertex_shader);

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

    // Bind the pipeline.
    sdl::bind_gpu_graphics_pipeline(render_pass, graphics_pipeline);

    // Bind the vertex buffer.
    SDL_GPUBufferBinding[1] buffer_bindings;
    buffer_bindings[0].buffer = vertex_buffer;
    buffer_bindings[0].offset = 0;

    sdl::bind_gpu_vertex_buffers(render_pass, 0, &buffer_bindings, 1);

    // Issue a draw call.
    sdl::draw_gpu_primitives(render_pass, 3, 1, 0, 0);

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
    sdl::release_gpu_graphics_pipeline(device, graphics_pipeline);
    sdl::release_gpu_buffer(device, vertex_buffer);
    sdl::destroy_gpu_device(device);

    // Destroy the window.
    sdl::destroy_window(window);
}
