#!/bin/bash
set -euo pipefail

apt-get update -yq 

apt-get upgrade -yq 

apt-get install -yq --no-install-recommends \
    cockpit \
    ca-certificates \
    crda \
    curl \
    fake-hwclock \
    firmware-brcm80211 \
    inotify-tools \
    locales \
    ntp \
    ssh \
    sudo \
    tmux \
    saidar \
    usb-modeswitch \
    vis \
    wget \
    wpasupplicant \
    xz-utils \
    zstd 

    # ca-certificates crda fake-hwclock firmware-brcm80211 gnupg man-db manpages net-tools ntp usb-modeswitch ssh sudo wget xz-utils