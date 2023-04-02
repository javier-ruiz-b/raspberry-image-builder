#!/bin/bash
set -euo pipefail
arch="$1"
MOUNT_POINT="$2"

CACHE_DEBOOTSTRAP="/cache/debootstrap_$arch.tar.zstd"

if [ -f "$CACHE_DEBOOTSTRAP" ]; then
    cd "$MOUNT_POINT"
    pv "$CACHE_DEBOOTSTRAP" | zstdcat - | tar -xf-
else
    debootstrap \
        --arch "$arch" \
        bullseye \
        "$MOUNT_POINT" \
       http://deb.debian.org/debian
    
    cd "$MOUNT_POINT"
    tar -cf- . | pv | zstd -T0 -11 > "$CACHE_DEBOOTSTRAP"
fi