#!/bin/bash
set -euxo pipefail

mountpoint="$1"

for dir in $(grep "$mountpoint" /proc/mounts  | cut -d' ' -f2 | tac); do 
    umount $dir || (
        echo "Could not umount $dir, forcing..."
        umount -l $dir
    )
done

sync