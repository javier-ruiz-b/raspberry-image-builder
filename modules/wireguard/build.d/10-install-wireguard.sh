#!/bin/bash
set -e

if [ -f /etc/wireguard/my_privatekey ]; then
    echo "wireguard already installed."
    exit 0
fi 

apt-get install -yq \
    iptables \
    wireguard-tools

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

mkdir -p /etc/wireguard
cd /etc/wireguard

umask 077
