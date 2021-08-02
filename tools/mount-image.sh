#!/bin/bash
set -euo pipefail

if [ "$(whoami)" != "root" ]; then
    echo "Run as root"
    exit 1
fi

if [ ! -f "$*" ]; then
    echo "Expecting image file as argument"
    exit 1
fi

bash "$(dirname "$0")/umount-image.sh"

image="$*"

boot_part_start=$(fdisk -l "$image" | grep '\.img1' | awk '{print $2}')
boot_part_size=$(fdisk -l "$image" | grep '\.img1' | awk '{print $4}')
root_part_start=$(fdisk -l "$image" | grep '\.img2' | awk '{print $2}')
root_part_size=$(fdisk -l "$image" | grep '\.img2' | awk '{print $4}')
data_part_start=$(fdisk -l "$image" | grep '\.img3' | awk '{print $2}')

mkdir -p /mnt/raspi_root
mount -o loop,offset=$((root_part_start*512)),sizelimit=$((root_part_size*512)) "$image" /mnt/raspi_root
    
mkdir -p /mnt/raspi_boot /mnt/raspi_data
mount -o loop,offset=$((boot_part_start*512)),sizelimit=$((boot_part_size*512)) "$image" /mnt/raspi_boot
mount -o loop,offset=$((data_part_start*512)) "$image" /mnt/raspi_data

echo -e "\nMounted on "/mnt/raspi_*