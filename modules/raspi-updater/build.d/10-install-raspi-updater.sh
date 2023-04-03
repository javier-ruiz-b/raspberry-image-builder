#!/bin/sh
set -eu

#install dependencies
apt-get install -yq \
    initramfs-tools \
    udhcpc

dpkg -i /var/tmp/raspi-update_*_"$(dpkg --print-architecture)".deb