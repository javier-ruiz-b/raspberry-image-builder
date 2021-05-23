#!/bin/bash
set -euxo pipefail
configs_dir="/src/configs"
config_dir="$configs_dir/${1:-}"
config_file="$config_dir/build.sh"
if [ ! -f "$config_file" ]; then
    echo "Error: config ${1:-} not found. Available configs:"
    ls -1 "$configs_dir"
    exit 0
fi
base_img="base.img"
if [ ! -f $base_img ]; then
    bash /build-basis-image.sh $base_img || bash
fi

cp $base_img result.img
bash /mount.sh result.img

bash -eux "$config_file"
cp -r "$config_dir"/* /mnt/root/

bash /umount.sh result.img
# bash

# cp /*raspios*.img /src