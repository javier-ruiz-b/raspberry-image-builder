#!/bin/bash
set -euo pipefail

zip_file="$1"

img_file="${zip_file%%.*}.img"

rm -rf "$img_file"
unzip "$zip_file"

tmp_image="$img_file.tmp.img"
mv "$img_file" "$tmp_image"

qemu-img resize $tmp_image -f raw +4G
size_img=$(parted $tmp_image -s unit MB print devices | grep $tmp_image | cut -d'(' -f 2 | sed -rn 's/([0-9]*).*/\1/p')
size_data=100
data_start=$((size_img - size_data))

parted -s $tmp_image \
    resizepart 2 ${data_start}MB \
    mkpart primary ext4 ${data_start}MB ${size_img}MB 

losetup -D

root_part_start=$(fdisk -l $tmp_image | grep '\.img2' | awk '{print $2}')
root_part_size=$(fdisk -l $tmp_image | grep '\.img2' | awk '{print $4}')
root_dev=$(losetup -f --offset $((root_part_start*512)) --size $((root_part_size*512)) --show $tmp_image)
e2fsck -f $root_dev
resize2fs $root_dev
e2label $root_dev root

losetup -D

data_part_start=$(fdisk -l $tmp_image | grep '\.img3' | awk '{print $2}')
data_dev=$(losetup -f --offset $((data_part_start*512)) --show $tmp_image)
mkfs.ext4 $data_dev
e2fsck -f $data_dev
resize2fs $data_dev
e2label $data_dev data

mv $tmp_image $img_file