#!/bin/bash
set -e

if [ -f /etc/wireguard/my_privatekey ]; then
    echo "wireguard already installed."
    exit 0
fi 

apt-get install -yq \
    gcc \
    git \
    libc6-dev \
    make

cd /tmp
rm -rf wireguard-tools
git clone https://git.zx2c4.com/wireguard-tools
make -C wireguard-tools/src -j$(nproc)
make -C wireguard-tools/src install

echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

mkdir -p /etc/wireguard
cd /etc/wireguard

umask 077
wg genkey | tee my_privatekey | wg pubkey > my_publickey