#!/bin/sh

#install motioneye
apt-get install -yq \
    curl \
    python-pip \
    python-dev \
    python-setuptools \
    libjpeg-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libmicrohttpd12 \
    v4l-utils

ldconfig /usr/local/lib

pip install motioneye

mkdir -p /etc/motioneye /var/lib/motioneye
cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service

systemctl daemon-reload
systemctl enable stream-camera
systemctl enable motioneye