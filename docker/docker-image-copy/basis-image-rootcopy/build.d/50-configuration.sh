#!/bin/bash

echo "LABEL=data     /data    ext4   defaults 0 2" >> /etc/fstab

# echo "pi:" | chpasswd
rm -f /etc/localtime
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

systemctl enable ssh

echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.confum