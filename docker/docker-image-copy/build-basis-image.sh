#!/bin/bash
set -euxo pipefail

result_image="$1"
tmp_image="$result_image"tmp.img

rm -rf *raspios*.img $result_image $tmp_image
unzip *raspios-buster-armhf*.zip

mv *raspios*.img $tmp_image

qemu-img resize $tmp_image -f raw +2G
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

bash /mount.sh /mnt/root/ "$tmp_image"

cp -r /basis-image-rootcopy/* /mnt/root/

chmod +x /bin/*
cd /mnt/root/
tar xfz /src/cross-compile-output/contents.tgz || ( echo "Run cross compile before."; exit 1)

chroot /mnt/root/ bash /var/tmp/setup.sh || (
    echo "Error: build failed, opening shell:"
    chroot /mnt/root/ bash
)

bash /umount.sh "$tmp_image"
mv $tmp_image $result_image