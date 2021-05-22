#!/bin/bash
set -euxo pipefail

boot_part_start=$(fdisk -l *raspios*.img | grep '\.img1' | awk '{print $2}')
boot_part_size=$(fdisk -l *raspios*.img | grep '\.img1' | awk '{print $4}')

mkdir /mnt/root
root_part_start=$(fdisk -l *raspios*.img | grep '\.img2' | awk '{print $2}')
mount -o loop,offset=$((root_part_start*512)) *raspios*.img /mnt/root
mkdir -p /mnt/root/boot
mount -o loop,offset=$((boot_part_start*512)),sizelimit=$((boot_part_size*512)) *raspios*.img /mnt/root/boot
# ls /mnt/*/

cd /mnt/root/
mount -t proc /proc proc/
mount --rbind /sys sys/
mount --rbind /dev dev/
