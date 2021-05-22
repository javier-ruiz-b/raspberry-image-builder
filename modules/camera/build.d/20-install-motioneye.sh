#!/bin/sh

#install motioneye
apt-get install -yq \
    curl \
    python-pip \
    python-dev \
    python-setuptools \
    libssl-dev \
    libcurl4-openssl-dev \
    libmicrohttpd12 \
    v4l-utils

 ldconfig /usr/local/lib

    # libz-dev \
    # libjpeg-dev \
    # motion \
# apt-get purge -yq motion

# wget https://github.com/Motion-Project/motion/releases/download/release-4.3.2/pi_buster_motion_4.3.2-1_armhf.deb
# dpkg -i pi_buster_motion_*_armhf.deb
# rm pi_buster_motion_*_armhf.deb

# sudo apt-get install -y autoconf automake pkgconf git libtool libjpeg8-dev build-essential libzip-dev gettext libmicrohttpd-dev

# cd /tmp
# git clone https://github.com/Motion-Project/motion.git
# cd motion
# autoreconf -fiv
# ./configure --with-ffmpeg=/opt/ffmpeg
# make
# make install


pip install motioneye

mkdir -p /etc/motioneye /var/lib/motioneye
cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service

systemctl daemon-reload
systemctl enable stream-camera
systemctl enable motioneye