#!/bin/bash

sed -i 's/#INITRD=Yes/INITRD=Yes/g' /etc/default/raspberrypi-kernel

sed -i 's/BUSYBOX=auto/BUSYBOX=y/g' /etc/initramfs-tools/initramfs.conf
sed -i 's/COMPRESS=gzip/COMPRESS=zstd/g' /etc/initramfs-tools/initramfs.conf
sed -i 's/FSTYPE=auto/FSTYPE=ext4,vfat/g' /etc/initramfs-tools/initramfs.conf

for module in /lib/modules/*; do
    sudo update-initramfs -c -k "$(basename "$module")"
done

bash
