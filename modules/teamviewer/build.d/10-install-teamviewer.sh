#!/bin/bash
set -e
cd /tmp
wget https://download.teamviewer.com/download/linux/teamviewer-host_armhf.deb
dpkg -i teamviewer-host_armhf.deb || true
apt-get -f install -y