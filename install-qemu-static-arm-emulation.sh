#!/bin/bash
set -euxo pipefail

apt-get install -y binfmt-support qemu-user-static qemu

/etc/init.d/binfmt-support start