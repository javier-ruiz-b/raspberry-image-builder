#!/bin/bash

# Commands
pv_cmd="pv -c -B 1M"
decompress_cmd="zstd -dc"

if [ "$(whoami)" != "root" ]; then
    echo "Run as root"
    exit 1
fi

if [[ -z $2 ]]; then
  echo "Usage: $0 /dev/sdX backup_base_name(without .mbr...)"
  exit 1
fi

set -euo pipefail

# Input card device
card_device=$1

# Output image filenames
output_base_name="$2"
output_mbr="$output_base_name.mbr.img.zst"
output_partition1="$output_base_name.p1.img.zst"
output_partition2="$output_base_name.p2.img.zst"

echo Unmount everything
umount "$card_device"* &>/dev/null || true

echo Restore MBR
$decompress_cmd "$output_mbr" | dd of="$card_device" bs=512 count=1 status=progress
partprobe "$card_device"

echo Restore first partition
first_partition_start="$(parted "$card_device" unit s print | awk '/^ 1/ {print $2}' | sed 's/s//g')"
$pv_cmd "$output_partition1" | $decompress_cmd - | dd of="$card_device" bs=$((512*8)) seek="$((first_partition_start/8))" # SD cards have 4K blocks (*8)

echo Restore second partition
second_partition_start="$(parted "$card_device" unit s print | awk '/^ 2/ {print $2}'| sed 's/s//g')"
$pv_cmd "$output_partition2" | $decompress_cmd - | dd of="$card_device" bs=$((512*8)) seek="$((second_partition_start/8))"

echo Formatting /data
mkfs.ext4 -F -L data "${card_device}3"

echo Checking
fsck.ext4 /dev/sdc2 -f -y

echo Syncing
sync
partprobe "$card_device"

echo Success!