#!/bin/bash
set -euo pipefail

docker build -t rpi-image docker

docker run --privileged --rm -it \
    -v "$(pwd)":/src \
    -v /dev:/dev \
    rpi-image \
    /build.sh $(ls -A *-raspios-*-arm64-lite.{*.zip,*.xz}) "$@"
    