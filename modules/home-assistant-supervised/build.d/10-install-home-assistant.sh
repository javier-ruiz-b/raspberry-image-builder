#!/bin/bash
OS_AGENT_VERSION="1.5.1"


chmod +x /usr/share/home-assistant/start
apt-get install \
    apparmor \
    jq \
    wget \
    curl \
    udisks2 \
    libglib2.0-bin \
    network-manager \
    dbus \
    lsb-release \
    systemd-journal-remote \
    systemd-resolved \
    wget -y

tmp_dir=$(mktemp -d)
trap 'rm -rf $tmp_dir' EXIT
cd "$tmp_dir"

wget https://github.com/home-assistant/os-agent/releases/download/$OS_AGENT_VERSION/os-agent_${OS_AGENT_VERSION}_linux_$(arch).deb
dpkg -i os-agent_*.deb

echo Checking OS Agent installation
gdbus introspect --system --dest io.hass.os --object-path /io/hass/os

wget https://github.com/home-assistant/supervised-installer/releases/latest/download/homeassistant-supervised.deb
apt-get install ./homeassistant-supervised.deb -yq