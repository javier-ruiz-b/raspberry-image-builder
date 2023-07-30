#!/bin/bash
set -eu

mkdir -p /data/frigate/media

if [ ! -f /data/frigate/config.yml ]; then
    cp /usr/share/frigate/sample-config.yml /data/frigate/config.yml
fi

cp /data/frigate/config.yml /data/frigate/media/config.yml.backup