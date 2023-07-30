#!/bin/sh
set -eu

# #install dependencies
# apt-get install -yq \
#     initramfs-tools \
#     udhcpc

package=$(ls -1 /var/tmp/raspi-updater_*_"$(dpkg --print-architecture)".deb)

dpkg -i "$package" ||
    apt-get install -f && dpkg -i "$package"