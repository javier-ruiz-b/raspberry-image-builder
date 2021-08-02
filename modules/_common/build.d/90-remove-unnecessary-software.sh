#!/bin/bash

#no swap
apt-get purge -yq \
    avahi-daemon \
    bluez \
    dphys-swapfile \
    triggerhappy \
    vim-tiny

apt-get purge -y 
apt-get autoremove -y