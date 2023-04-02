#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

mkdir -p /build.d/done
for script in /build.d/*.sh; do
    echo " * Running $script"
    bash -euxo pipefail "$script"
    mv $script /build.d/done
done
