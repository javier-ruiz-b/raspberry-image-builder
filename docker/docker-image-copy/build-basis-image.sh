#!/bin/bash
set -euxo pipefail

result_image="$1"

rm -rf *raspios*.img $result_image
unzip *raspios-buster-armhf*.zip

mv *raspios*.img $result_image

qemu-img resize $result_image -f raw +2G
size_img=$(parted $result_image -s unit MB print devices | grep $result_image | cut -d'(' -f 2 | sed -rn 's/([0-9]*).*/\1/p')
size_data=100
data_start=$((size_img - size_data))

parted -s $result_image \
    resizepart 2 ${data_start}MB \
    mkpart primary ext4 ${data_start}MB ${size_img}MB 

losetup -D

root_part_start=$(fdisk -l $result_image | grep '\.img2' | awk '{print $2}')
root_dev=$(losetup -f --offset $((root_part_start*512)) --show $result_image)
e2fsck -f $root_dev
resize2fs $root_dev
e2label $data_dev root

losetup -D

data_part_start=$(fdisk -l $result_image | grep '\.img3' | awk '{print $2}')
data_dev=$(losetup -f --offset $((data_part_start*512)) --show $result_image)
mkfs.ext4 $data_dev
e2label $data_dev data

losetup -D

bash /mount.sh "$result_image"

cp -r /rootcopy/* /mnt/root/

chmod +x /bin/*
cd /mnt/root/
tar xfz /src/cross-compile-output/contents.tgz || ( echo "Run cross compile before."; exit 1)

chroot /mnt/root/ bash /var/tmp/setup.sh || (
    echo "Error: build failed, opening shell:"
    chroot /mnt/root/ bash
)

bash /umount.sh "$result_image"