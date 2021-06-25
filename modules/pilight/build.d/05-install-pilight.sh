#!/bin/bash

# echo "deb http://apt.pilight.org/ stable main" > /etc/apt/sources.list.d/pilight.list
# wget -O - http://apt.pilight.org/pilight.key | apt-key add -
# apt-get update


if ls -1 /usr/lib/aarch64-linux-gnu; then
    cd /var/tmp/arm64
else 
    cd /var/tmp/armhf
fi

dpkg -i libmbed*.deb

apt-get install -yq build-essential libunwind8 cmake git dialog libwiringx libwiringx-dev libpcap0.8-dev libmbedtls-dev liblua5.2-dev libluajit-5.1-dev lua5.1-dev

git clone https://github.com/pilight/pilight.git
cd pilight
git checkout staging # support for aarch64

./setup.sh install

# apt-get install -yq pilight liblua5.1-0 

cp /etc/pilight/config.json.bak /etc/pilight/config.json

systemctl enable pilight
systemctl enable pilight-watchdog