#!/bin/bash
set -euo pipefail

apt-get upgrade -yq 

#other packages are in docker/docker-image-copy/debootstrap-packages.txt
apt-get install -yq --no-install-recommends \
    cockpit
