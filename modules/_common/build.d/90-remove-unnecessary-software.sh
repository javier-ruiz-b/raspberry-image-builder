#!/bin/bash

#no swap
apt-get purge -yq \
    avahi-daemon \
    bluez \
    console-setup \
    dphys-swapfile \
    triggerhappy \
    vim-tiny

apt-get purge -y 
apt-get autoremove -y