#!/bin/bash
set -euo pipefail

apt-get update -yq 
apt-get upgrade -yq 
apt-get install -yq --no-install-recommends \
    borgbackup \
    cockpit \
    dos2unix \
    git \
    inotify-tools \
    make \
    openvpn \
    tmux \
    python3-pip \
    saidar \
    syncthing \
    vis \
    watchdog
