#!/bin/bash
set -e

cd /tmp
git clone https://git.zx2c4.com/wireguard-tools
make -C wireguard-tools/src -j$(nproc)
make -C wireguard-tools/src install

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

mkdir -p /etc/wireguard
cd /etc/wireguard

umask 077
wg genkey | tee my_privatekey | wg pubkey > my_publickey
