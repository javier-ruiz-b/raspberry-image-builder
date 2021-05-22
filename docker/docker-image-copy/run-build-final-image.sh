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

bash /decompress-image.sh

qemu-img resize *raspios*.img -f raw +2G
parted *raspios*.img resizepart 2 100%

losetup -D

root_part_start=$(fdisk -l *raspios*.img | grep '\.img2' | awk '{print $2}')
root_dev=$(losetup -f --offset $((root_part_start*512)) --show *raspios*.img)
e2fsck -f $root_dev
resize2fs $root_dev

losetup -D

bash /mount.sh

cp -r /rootcopy/* /mnt/root/

chmod +x /bin/*
bash -eux "$config_file"
cp -r "$config_dir"/* /mnt/root/

cd /mnt/root/
tar xfz /src/cross-compile-output/contents.tgz || ( echo "Run cross compile before."; exit 1)

chroot /mnt/root/ bash /var/tmp/setup.sh || (
    echo "Error: build failed, opening shell:"
    chroot /mnt/root/ bash
)

umount /mnt/root/boot
umount -l /mnt/root || true
sync

# bash

cp /*raspios*.img /src