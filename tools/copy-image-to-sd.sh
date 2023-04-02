#!/bin/bash
set -euxo pipefail

image_file="$1"

sudo umount "$2"* 2> /dev/null || true
pv "$image_file" | zstd -dc - | sudo dd of="$2" bs=1M

echo "Syncing.."
sync

sudo partprobe "$2"

echo "Success!"