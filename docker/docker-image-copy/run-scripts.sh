#!/bin/bash
set -euo pipefail
MOUNT_POINT="$1"

/correct-permissions.sh "$MOUNT_POINT"

mount -t proc /proc "$MOUNT_POINT/proc/"
mount -t sysfs /sys "$MOUNT_POINT/sys/"
mount -o bind /dev "$MOUNT_POINT/dev/"

chroot "$MOUNT_POINT" bash -eu /var/tmp/setup.sh || (
    echo "Error: build failed, opening shell:"
    chroot "$MOUNT_POINT" bash
)

umount "$MOUNT_POINT/dev/"
umount "$MOUNT_POINT/proc/"
umount "$MOUNT_POINT/sys/"