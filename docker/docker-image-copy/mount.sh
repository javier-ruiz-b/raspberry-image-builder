#!/bin/bash
set -euxo pipefail
mountpoint="$1"
image="$2"

echo "Mounting $image"
losetup -D

boot_part_start=$(fdisk -l "$image" | grep '\.img1' | awk '{print $2}')
boot_part_size=$(fdisk -l "$image" | grep '\.img1' | awk '{print $4}')
root_part_start=$(fdisk -l "$image" | grep '\.img2' | awk '{print $2}')
root_part_size=$(fdisk -l "$image" | grep '\.img2' | awk '{print $4}')
data_part_start=$(fdisk -l "$image" | grep '\.img3' | awk '{print $2}')

mkdir -p $mountpoint
mount -o loop,offset=$((root_part_start*512)),sizelimit=$((root_part_size*512))  \
    "$image" $mountpoint
    
mkdir -p $mountpoint/boot $mountpoint/data
mount -o loop,offset=$((boot_part_start*512)),sizelimit=$((boot_part_size*512)) \
    "$image" $mountpoint/boot
mount -o loop,offset=$((data_part_start*512)) \
    "$image" $mountpoint/data

cd $mountpoint
mount -t proc /proc proc/
mount --rbind /sys sys/
mount --rbind /dev dev/
