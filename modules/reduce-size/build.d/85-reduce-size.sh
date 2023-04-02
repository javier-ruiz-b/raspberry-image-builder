#!/bin/bash
set -eu

apt-get purge -yq \
    bluez-firmware \
    binutils-arm-linux-gnueabihf \
    gcc \
    p7zip \
    python3 \
    "*-dev"

rm -rf \
    /usr/lib/python*


rm -rf \
    /var/cache/apt/* \
    /var/lib/apt/lists/* \
    /var/lib/doc/* \
    /usr/lib/firmware/ath10k \
    /usr/lib/firmware/ath11k \
    /usr/lib/firmware/mediatek \
    /usr/lib/firmware/mrvl \
    /usr/lib/firmware/nvidia \
    /usr/lib/firmware/i915