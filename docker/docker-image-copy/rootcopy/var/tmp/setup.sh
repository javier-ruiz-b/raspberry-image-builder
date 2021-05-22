#!/bin/bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

for script in /build.d/*; do
    bash -euxo pipefail "$script"
done
echo "df -h:"
df -h