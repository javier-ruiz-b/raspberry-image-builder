#!/bin/bash

apt-get purge -yq \
    avahi-daemon \
    bluez \
    triggerhappy \
    vim-tiny

apt-get autoremove -y