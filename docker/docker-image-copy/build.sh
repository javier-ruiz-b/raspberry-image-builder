#!/bin/bash
set -euxo pipefail
#follows gist: https://gist.github.com/G-UK/ded781ea016e2c95addba2508c6bbfbe

#register arm binary executor
/etc/init.d/binfmt-support start

export arch="$1"
export config="$2"

trap 'chown -R 1000:1000 /output' EXIT

configs_dir="/src/configs"
config_dir="$configs_dir/${config:-}"
config_file="$config_dir/build.sh"
if [ ! -f "$config_file" ]; then
    echo "Error: config ${config:-} not found. Available configs:"
    ls -1 "$configs_dir"
    exit 1
fi

export MOUNT_POINT=/mnt/sd
mkdir -p "$MOUNT_POINT"
cd "$MOUNT_POINT"

common_scripts=/src/modules/_common
common_cache="/cache/common_$arch.tar.zstd"
if [ ! -f "$common_cache" ] || is-path-newer "$common_scripts/" "$common_cache"; then
    /run-debootstrap-or-extract-from-cache.sh "$arch" "$MOUNT_POINT"

    cp -r \
        "$common_scripts/"* \
        "$MOUNT_POINT"

    /run-scripts.sh "$MOUNT_POINT"

    tar -cf- . | pv | zstd -T0 -3 > "$common_cache"
else
    pv "$common_cache" | zstdcat - | tar -xf-
fi

bash -eux "$config_file"

cp -r \
    "$config_dir"/* \
    "$MOUNT_POINT"

/run-scripts.sh "$MOUNT_POINT"

/pack-to-image.sh "$MOUNT_POINT" "/output/image_${arch}_$config.img"

exit 0
