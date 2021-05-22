#!/bin/bash


cd /home/pi
mkdir workspace

apt-get install -yq \
    clang \
    cmake \
    ninja-build \
    qtbase5-dev \
    qtchooser
    
exit 0

cd /home/pi/workspace
git clone https://github.com/javier-ruiz-b/docker-rasppi-images.git
cd docker-rasppi-images/http-server-home
bash -eu ./install.sh
pip3 install -r requirements.txt
systemctl disable http-server-home.service


cd /home/pi/workspace
git clone https://github.com/javier-ruiz-b/ledify.git
cd ledify
bash -eu ./setup-development.sh
bash -eu ./release.sh
cp ledify.service /etc/systemd/system


chown -R pi:pi /home/pi

systemctl daemon-reload
systemctl enable http-server-home.service
systemctl enable ledify