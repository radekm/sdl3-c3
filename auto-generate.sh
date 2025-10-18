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
./generator "$script_dir/01-inputs/SDL_surface.h" > "$script_dir/02-auto-generated/sdl_surface.c3"
./generator "$script_dir/01-inputs/SDL_pixels.h" > "$script_dir/02-auto-generated/sdl_pixels.c3"
./generator "$script_dir/01-inputs/SDL_rect.h" > "$script_dir/02-auto-generated/sdl_rect.c3"
./generator "$script_dir/01-inputs/SDL_keyboard.h" > "$script_dir/02-auto-generated/sdl_keyboard.c3"
./generator "$script_dir/01-inputs/SDL_scancode.h" > "$script_dir/02-auto-generated/sdl_scancode.c3"
./generator "$script_dir/01-inputs/SDL_properties.h" > "$script_dir/02-auto-generated/sdl_properties.c3"
./generator "$script_dir/01-inputs/SDL_sensor.h" > "$script_dir/02-auto-generated/sdl_sensor.c3"
