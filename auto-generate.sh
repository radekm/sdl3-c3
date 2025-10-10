#!/usr/bin/env bash
set -e

script_dir=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
build_dir="$script_dir/build"

mkdir -p "$build_dir"
cd "$build_dir"

c3c compile "$script_dir/gen.c3"

./generator "$script_dir/01-inputs/SDL_video.h" > "$script_dir/02-auto-generated/sdl_video.c3"
