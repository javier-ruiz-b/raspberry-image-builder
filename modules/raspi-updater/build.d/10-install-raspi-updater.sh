#!/bin/sh
set -eu

#install dependencies
apt-get install -yq \
    initramfs-tools \
    udhcpc

dpkg -i /var/tmp/raspi-updater_*_"$(dpkg --print-architecture)".deb