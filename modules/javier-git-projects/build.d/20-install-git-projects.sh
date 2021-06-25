#!/bin/bash


cd /home/pi
mkdir -p workspace

apt-get install -yq \
    clang \
    cmake \
    make \
    ninja-build \
    qtbase5-dev \
    qtchooser \
    python3-setuptools
cd /home/pi/workspace
git clone https://github.com/javier-ruiz-b/docker-rasppi-images.git
cd docker-rasppi-images/http-server-home
bash -eu ./install.sh
pip3 install wheel
pip3 install -r requirements.txt
systemctl enable http-server-home.service


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