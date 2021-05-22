#!/bin/bash

echo "deb http://apt.pilight.org/ stable main" > /etc/apt/sources.list.d/pilight.list
wget -O - http://apt.pilight.org/pilight.key | apt-key add -
apt-get update

cd /var/tmp
dpkg -i libmbed*.deb

apt-get install -yq pilight

cp /etc/pilight/config.json.bak /etc/pilight/config.json

systemctl enable pilight
systemctl enable pilight-watchdog