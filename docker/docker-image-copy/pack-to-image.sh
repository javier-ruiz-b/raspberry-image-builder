#!/bin/bash
set -euo pipefail

MOUNT_POINT="$1"
IMAGE_FILE="$2"

cd "$MOUNT_POINT"

# delete temp dirs and caches

rm -rf  /var/cache/apt/* \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*


block_size=1M
size_os_mb=$(du --block-size $block_size -s . | awk '{print $1}')
free_space_root_mb=128
size_root_mb=$((size_os_mb + free_space_root_mb))
size_boot_mb=192

start_offset_boot_mb=1
start_offset_root_mb=$((start_offset_boot_mb + size_boot_mb))

size_image_mb=$((start_offset_root_mb + size_root_mb))

dd if=/dev/zero of="$IMAGE_FILE" bs=$block_size seek="$size_image_mb" count=0

losetup -D
losetup -f "$IMAGE_FILE" --show

parted -s /dev/loop0 mklabel msdos \
    mkpart primary fat32 ${start_offset_boot_mb}MiB ${start_offset_root_mb}MiB \
    mkpart primary ext4 ${start_offset_root_mb}MiB $((size_image_mb-1))MiB

partprobe /dev/loop0

# Format the partitions with the FAT and ext4 filesystems
mkfs.fat -F 32 -n boot /dev/loop0p1
mkfs.ext4 -F -L root /dev/loop0p2

mkdir -p /mnt/image
mount /dev/loop0p2 /mnt/image
mkdir -p /mnt/image/boot
mount /dev/loop0p1 /mnt/image/boot

cp -ra . "/mnt/image/"

umount /mnt/image/boot
umount /mnt/image

zstd -f -3 -T0 --rm "$IMAGE_FILE"