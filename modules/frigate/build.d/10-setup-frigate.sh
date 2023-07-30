#!/bin/sh

systemctl enable docker-compose@frigate
systemctl enable prepare-frigate.service
chmod +x /usr/share/frigate/prepare-frigate.sh