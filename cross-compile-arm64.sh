#!/bin/bash
set -euo pipefail

docker build -t rpi-image-cam docker

docker run --privileged --rm -it \
    -v "$(pwd)":/src \
    -v /dev:/dev \
    rpi-image-cam \
    /run-cross-compile-arm64.sh  "$@"
    