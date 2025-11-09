#!/usr/bin/env bash
set -e

script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
build_dir="$script_dir/build"

mkdir -p "$build_dir"
cd "$build_dir"

c3c compile --no-entry --libdir .. --lib sdl "$@" ../examples/let-there-be-triangles/*.c3 -o let-there-be-triangles
c3c compile --no-entry --libdir .. --lib sdl "$@" ../examples/spydog/common.c3 ../examples/spydog/clear_screen.c3 -o clear-screen
c3c compile --no-entry --libdir .. --lib sdl "$@" ../examples/spydog/common.c3 ../examples/spydog/clear_screen_multi_window.c3 -o clear-screen-multi-window
c3c compile --no-entry --libdir .. --lib sdl "$@" ../examples/spydog/common.c3 ../examples/spydog/basic_triangle.c3 -o basic-triangle
c3c compile --no-entry --libdir .. --lib sdl "$@" ../examples/spydog/common.c3 ../examples/spydog/basic_stencil.c3 -o basic-stencil
c3c compile --no-entry --libdir .. --lib sdl "$@" ../examples/spydog/common.c3 ../examples/spydog/basic_vertex_buffer.c3 -o basic-vertex-buffer
c3c compile --no-entry --libdir .. --lib sdl "$@" ../examples/spydog/common.c3 ../examples/spydog/blit_2d_array.c3 -o blit-2d-array
