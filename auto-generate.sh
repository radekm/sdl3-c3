#!/usr/bin/env bash
set -e

script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
build_dir="$script_dir/build"

mkdir -p "$build_dir"
cd "$build_dir"

c3c compile "$script_dir/gen.c3"

./generator "$script_dir/01-inputs/SDL_video.h" > "$script_dir/02-auto-generated/sdl_video.c3"
./generator "$script_dir/01-inputs/SDL_gpu.h" > "$script_dir/02-auto-generated/sdl_gpu.c3"
./generator "$script_dir/01-inputs/SDL_keycode.h" > "$script_dir/02-auto-generated/sdl_keycode.c3"
./generator "$script_dir/01-inputs/SDL_events.h" > "$script_dir/02-auto-generated/sdl_events.c3"
./generator "$script_dir/01-inputs/SDL_audio.h" > "$script_dir/02-auto-generated/sdl_audio.c3"
./generator "$script_dir/01-inputs/SDL_blendmode.h" > "$script_dir/02-auto-generated/sdl_blendmode.c3"
./generator "$script_dir/01-inputs/SDL_error.h" > "$script_dir/02-auto-generated/sdl_error.c3"
./generator "$script_dir/01-inputs/SDL_init.h" > "$script_dir/02-auto-generated/sdl_init.c3"
