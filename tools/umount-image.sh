#!/bin/bash
set -euo pipefail

if [ "$(whoami)" != "root" ]; then
    echo "Run as root"
    exit 1
fi

for name in boot root data; do
    path=/mnt/raspi_$name
    if [ -d "$path" ] && grep "$path" /proc/mounts; then
        echo "Existing mount in $path, unmounting..."
        umount "$path" || umount -l "$path"
    fi
done