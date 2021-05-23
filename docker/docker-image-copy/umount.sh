#!/bin/bash
set -euxo pipefail

mountpoint="$1"

umount $mountpoint/dev
umount $mountpoint/sys
umount $mountpoint/proc
umount $mountpoint/data
umount $mountpoint/boot
umount $mountpoint

sync