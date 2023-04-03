#!/bin/bash
set -euo pipefail

image_file="$1"

sudo umount "$2"* 2> /dev/null || true

while true; do
    printf "\r %s" "$(grep -e Dirty: /proc/meminfo)"
    sleep 1
done &
watch_pid=$!
trap 'kill $watch_pid' EXIT

zstd -dc "$image_file" | sudo dd of="$2" bs=1M

echo "Syncing.."
sync

sudo partprobe "$2"

echo "Success!"