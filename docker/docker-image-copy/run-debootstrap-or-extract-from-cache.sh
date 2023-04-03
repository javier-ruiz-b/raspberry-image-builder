#!/bin/bash
set -euxo pipefail
arch="$1"
MOUNT_POINT="$2"

CACHE_DEBOOTSTRAP="/cache/debootstrap_$arch.tar.zstd"

if [ -f "$CACHE_DEBOOTSTRAP" ] \
    && is-path-newer "$CACHE_DEBOOTSTRAP" "/debootstrap-packages.txt"; then
    cd "$MOUNT_POINT"
    pv "$CACHE_DEBOOTSTRAP" | zstdcat - | tar -xf-
else
    if [ "$arch" = "armhf" ]; then
        args="--keyring=/armhf-trusted.gpg"
        mirror="http://raspbian.raspberrypi.org/raspbian"
    else
        mirror="http://deb.debian.org/debian"
    fi

    include_packages=$(tr '\n' ',' <  "/debootstrap-packages.txt")
    debootstrap ${args:-} \
        --arch "$arch" \
        --components=main,contrib,non-free \
        --include="$include_packages" \
        bullseye \
        "$MOUNT_POINT" \
       $mirror || (
            echo Debootstrap failed. Here\'s a shell:
            cd "$MOUNT_POINT"
            bash
       )
    
    cd "$MOUNT_POINT"
    tar -cf- . | pv | zstd -T0 -11 > "$CACHE_DEBOOTSTRAP".tmp
    mv "$CACHE_DEBOOTSTRAP".tmp "$CACHE_DEBOOTSTRAP"
fi