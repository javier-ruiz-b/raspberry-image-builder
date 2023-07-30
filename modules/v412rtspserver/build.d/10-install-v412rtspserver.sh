#!/bin/sh
set -eu

apt-get install -yq \
    cmake \
    gcc \
    g++ \
    git \
    make \
    pkg-config

cd /tmp
git clone https://github.com/mpromonet/v4l2rtspserver.git
cd v4l2rtspserver
cmake .
make -j"$(nproc)"
make install

systemctl enable v412rtspserver