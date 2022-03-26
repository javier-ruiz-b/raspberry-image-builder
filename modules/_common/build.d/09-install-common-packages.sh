#!/bin/bash
set -euo pipefail

apt-get update -yq 
apt-get upgrade -yq 
apt-get install -yq --no-install-recommends \
    bc \
    borgbackup \
    cockpit \
    dos2unix \
    git \
    inotify-tools \
    tmux \
    python3-pip \
    saidar \
    vis \
    zstd
    
#avahi-autoipd not necessary