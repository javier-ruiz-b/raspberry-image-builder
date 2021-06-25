#!/bin/bash

sed -i  '/arm_64bit/d' /boot/config.txt
echo "arm_64bit=1" | sudo tee -a /boot/config.txt

cd /
tar xfJ /var/tmp/contents_arm64.tar.xz

for lib in /opt/vc/lib/*.so; do
    ln -s "$lib" /usr/local/lib/"$(basename "$lib")"
done 

# Replacing 64bit userland binaries because they have mmal. Do not allow library updates.
apt-mark hold libraspberrypi-bin libraspberrypi-dev libraspberrypi-doc libraspberrypi0
ldconfig