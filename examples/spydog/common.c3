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

fn void common_update(Context* context, SDL_Event* event)
{
    context.left_pressed = false;
    context.right_pressed = false;
    context.down_pressed = false;
    context.up_pressed = false;

    if (event.type == KEY_DOWN)
    {
        switch (event.key.key)
        {
            case LEFT:
                context.left_pressed = true;
            case RIGHT:
                context.right_pressed = true;
            case DOWN:
                context.down_pressed = true;
            case UP:
                context.up_pressed = true;
        }
    }
}

fn void common_quit(Context* context)
{
    sdl::release_window_from_gpu_device(context.device, context.window);
    sdl::destroy_window(context.window);
    sdl::destroy_gpu_device(context.device);
}

fn void load_shaders(
    Context* context,
    char[] metal_shaders, char[] spirv_shaders, char[] dxil_shaders,
    SDL_GPUShader** out_vertex_shader, SDL_GPUShader** out_fragment_shader,
    uint vertex_num_samplers = 0,
    uint vertex_num_uniform_buffers = 0,
    uint vertex_num_storage_buffers = 0,
    uint vertex_num_storage_textures = 0,
    uint fragment_num_samplers = 0,
    uint fragment_num_uniform_buffers = 0,
    uint fragment_num_storage_buffers = 0,
    uint fragment_num_storage_textures = 0)
{
    SDL_GPUShaderFormat backend_shader_formats = sdl::get_gpu_shader_formats(context.device);
    SDL_GPUShaderFormat shader_format;
    char[] shaders_code;
    switch
    {
        case backend_shader_formats & SDL_GPUShaderFormat.MSL != 0:
            shader_format = MSL;
            shaders_code = metal_shaders;
        case backend_shader_formats & SDL_GPUShaderFormat.SPIRV != 0:
            shader_format = SPIRV;
            shaders_code = spirv_shaders;
        case backend_shader_formats & SDL_GPUShaderFormat.DXIL != 0:
            shader_format = DXIL;
            shaders_code = dxil_shaders;
        default:
            abort("Unrecognized backend shader format");
    }

    // Create the vertex shader.
    SDL_GPUShaderCreateInfo vertex_info;
    vertex_info.code = shaders_code.ptr;
    vertex_info.code_size = shaders_code.len;
    vertex_info.entrypoint = "vertexMain";
    vertex_info.format = shader_format;
    vertex_info.stage = VERTEX;
    vertex_info.num_samplers = vertex_num_samplers;
    vertex_info.num_storage_buffers = vertex_num_storage_buffers;
    vertex_info.num_storage_textures = vertex_num_storage_textures;
    vertex_info.num_uniform_buffers = vertex_num_uniform_buffers;
    SDL_GPUShader* vertex_shader = sdl::create_gpu_shader(context.device, &vertex_info);
    if (!vertex_shader) abort_with_sdl_error("Vertex shader creation failed");

    // Create the fragment shader.
    SDL_GPUShaderCreateInfo fragment_info;
    fragment_info.code = shaders_code.ptr;
    fragment_info.code_size = shaders_code.len;
    fragment_info.entrypoint = "fragmentMain";
    fragment_info.format = shader_format;
    fragment_info.stage = FRAGMENT;
    fragment_info.num_samplers = fragment_num_samplers;
    fragment_info.num_storage_buffers = fragment_num_storage_buffers;
    fragment_info.num_storage_textures = fragment_num_storage_textures;
    fragment_info.num_uniform_buffers = fragment_num_uniform_buffers;
    SDL_GPUShader* fragment_shader = sdl::create_gpu_shader(context.device, &fragment_info);
    if (!fragment_shader) abort_with_sdl_error("Fragment shader creation failed");

    *out_vertex_shader = vertex_shader;
    *out_fragment_shader = fragment_shader;
}

fn SDL_Surface* load_image(char[] image_data, int desired_channels)
{
    SDL_IOStream* stream = sdl::io_from_const_mem(image_data.ptr, image_data.len);
    if (!stream) abort_with_sdl_error("io_from_const_mem failed");

    SDL_Surface* result = sdl::load_bmp_io(stream, true);
    if (!result) abort_with_sdl_error("Failed to load BMP");

    if (desired_channels != 4) abort("Unexpected desired_channels");
    SDL_PixelFormat format = ABGR8888;

    if (result.format != format)
    {
        SDL_Surface* next = sdl::convert_surface(result, format);
        if (!next) abort_with_sdl_error("convert_surface failed");
        sdl::destroy_surface(result);
        result = next;
    }

    return result;
}

// Vertex formats.
struct PositionVertex
{
    float x, y, z;
}

struct PositionColorVertex
{
    float x, y, z;
    char r, g, b, a;
}

struct PositionTextureVertex
{
    float x, y, z;
    float u, v;
}
