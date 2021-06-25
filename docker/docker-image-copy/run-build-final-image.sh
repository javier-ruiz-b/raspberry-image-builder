#!/bin/bash
set -euxo pipefail

zip_file="$1"
config="$2"

export MOUNT_POINT=/mnt/root
configs_dir="/src/configs"
config_dir="$configs_dir/${config:-}"
config_file="$config_dir/build.sh"
if [ ! -f "$config_file" ]; then
    echo "Error: config ${config:-} not found. Available configs:"
    ls -1 "$configs_dir"
    exit 1
fi

/mount-and-build-if-necessary.sh "$zip_file" "$config.img"

bash -eux "$config_file"
cp -r "$config_dir"/* $MOUNT_POINT
cp -r /basis-image-rootcopy/* $MOUNT_POINT
chroot $MOUNT_POINT sh -c 'chmod +x /bin/* /usr/local/bin*'


chroot $MOUNT_POINT bash -eu /var/tmp/setup.sh || (
    echo "Error: build failed, opening shell:"
    chroot $MOUNT_POINT bash
)

/umount.sh $MOUNT_POINT
echo "Success"