#!/bin/bash
set -euxo pipefail

zip_file="$1"
shift

export MOUNT_POINT=/mnt/root
configs_dir="/src/configs"
config_dir="$configs_dir/${1:-}"
config_file="$config_dir/build.sh"
if [ ! -f "$config_file" ]; then
    echo "Error: config ${1:-} not found. Available configs:"
    ls -1 "$configs_dir"
    exit 0
fi

base_img="${zip_file%%.*}.img"
if [ ! -f $base_img ]; then
    /build-basis-image.sh "$zip_file" $base_img
fi

echo "Copying image"
cp $base_img result.img
/mount.sh $MOUNT_POINT result.img

bash -eux "$config_file"
cp -r "$config_dir"/* $MOUNT_POINT

chroot $MOUNT_POINT bash -eu /var/tmp/setup.sh || (
    echo "Error: build failed, opening shell:"
    chroot $MOUNT_POINT bash
)

/umount.sh $MOUNT_POINT
echo "Success"