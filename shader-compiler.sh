#!/usr/bin/env bash
set -e

if [ "$#" -ne 1 ]; then
    echo "Single file with shader must be given"
    exit 1
fi

if [[ ! $1 =~ \.slang$ ]]; then
    echo "Shader file must have extension .slang"
    exit 1
fi

slangc "$1" -target metal -o "${1%.slang}.metal"
slangc "$1" -target spirv -o "${1%.slang}.spv"
slangc "$1" -target dxil -profile sm_6_3 -o "${1%.slang}.dxil"
