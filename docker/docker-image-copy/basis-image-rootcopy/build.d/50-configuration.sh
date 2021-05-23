#!/bin/bash

# echo "pi:" | chpasswd
rm -f /etc/localtime
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

systemctl enable ssh
systemctl enable wpa_supplicant


echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf
