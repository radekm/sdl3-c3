module sdl;

fn uint fourcc(uint a, uint b, uint c, uint d)
{
    return (a & 0xFF) | ((b & 0xFF) << 8) | ((c & 0xFF) << 16) | ((d & 0xFF) << 24);
}

const float FLT_EPSILON = 1.1920928955078125e-07;  /* 0x0.000002p0 */

extern fn float fabsf(float x) @extern("SDL_fabsf");

typedef SDL_FunctionPointer = void*;
