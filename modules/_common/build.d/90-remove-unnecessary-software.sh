#!/bin/bash

#no swap
apt-get purge -yq \
    avahi-daemon \
    bluez \
    console-setup \
    dphys-swapfile \
    rsyslog \
    triggerhappy \
    vim-tiny >/dev/null || true

apt-get purge -y 
apt-get autoremove -y

#remove apt cacher proxy
rm /etc/apt/apt.conf.d/01_apt_cacher_proxy