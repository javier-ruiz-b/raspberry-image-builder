#!/bin/bash

sed -i 's/noatime/noatime,nodiratime/g' /etc/fstab
echo "LABEL=data     /data    ext4   defaults,noatime,nodiratime 0 2" >> /etc/fstab

# disable root partition resize
sed -i 's/ init=[^ ]*//g' /boot/cmdline.txt
rm -f /etc/init.d/resizefs_once /etc/rc3.d/S01resizefs_once

# enable data partition resize
systemctl enable expand-data-filesystem

# echo "pi:" | chpasswd
rm -f /etc/localtime
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

systemctl enable ssh
touch /boot/ssh
