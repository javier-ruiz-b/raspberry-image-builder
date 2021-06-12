#!/bin/bash

sed -i  '/arm_64bit/d' /boot/config.txt
echo "arm_64bit=1" | sudo tee -a /boot/config.txt

cd /
tar xfJ /var/tmp/contents_arm64.tar.xz

# Replacing 64bit userland binaries. Do not update libraries.
sudo apt-mark hold libraspberrypi-bin libraspberrypi-dev libraspberrypi-doc libraspberrypi0