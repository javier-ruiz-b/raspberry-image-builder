#!/bin/bash
set -e

apt-get install -yq \
    iptables \
    wireguard-tools

if ! grep 'net.ipv4.ip_forward = 1' /etc/sysctl.conf; then
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
fi

mkdir -p /etc/wireguard
cd /etc/wireguard

umask 077
