#!/bin/bash

apt-get install -yq libunwind8 libpcap0.8

if is-64bit; then
    cd /var/tmp/arm64
else 
    cd /var/tmp/armhf
fi

dpkg -i libmbed*.deb libwiringx*.deb pilight*

cp /etc/pilight/config.json.bak /etc/pilight/config.json

systemctl enable pilight
systemctl enable pilight-watchdog