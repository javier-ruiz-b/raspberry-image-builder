#!/bin/bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

mkdir -p /build.d/done
for script in /build.d/*.sh; do
    echo " * Running $script"
    bash -euxo pipefail "$script"
    mv $script /build.d/done
done

echo "df -h:"
df -h