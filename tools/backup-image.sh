#!/bin/bash

# Commands
pv_cmd="pv -c -B 1M"
compress_cmd="zstd -T0 -19 -"

if [ "$(whoami)" != "root" ]; then
    echo "Run as root"
    exit 1
fi

if [[ -z $2 ]]; then
  echo "Usage: $0 /dev/sdX backup_name"
  exit 1
fi

set -euo pipefail

# Input card device
card_device=$1

# Output image filenames
output_base_name="backup-$2-$(date +%Y-%m-%d)"
output_mbr="$output_base_name.mbr.img.zst"
output_partition1="$output_base_name.p1.img.zst"
output_partition2="$output_base_name.p2.img.zst"

echo Backup MBR
dd if="$card_device" bs=512 count=1 | $compress_cmd > "$output_mbr"

echo Backup first partition
read -r first_partition_start first_partition_end <<< "$(parted "$card_device" unit s print | awk '/^ 1/ {print $2, $3}' | sed 's/s//g')"
first_partition_size=$((first_partition_end - first_partition_start))
dd if="$card_device" bs=512 skip="$first_partition_start" count="$first_partition_size" | $pv_cmd | $compress_cmd > "$output_partition1"

echo Backup second partition
read -r second_partition_start second_partition_end <<< "$(parted "$card_device" unit s print | awk '/^ 2/ {print $2, $3}' | sed 's/s//g')"
second_partition_size=$((second_partition_end - second_partition_start))
dd if="$card_device" bs=512 skip="$second_partition_start" count="$second_partition_size" | $pv_cmd | $compress_cmd > "$output_partition2"
