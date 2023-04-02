#!/bin/bash
set -euo pipefail

mkdir -p output

docker build -t rpi-image ./docker
docker run --privileged --rm -it \
    -v "$(pwd)":/src \
    -v "$(pwd)/output":/output \
    -v /dev:/dev \
    -v rpi-image-cache:/cache \
    rpi-image \
    /build-debootstrap.sh "$@"
    