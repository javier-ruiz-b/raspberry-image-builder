#!/bin/bash
set -euxo pipefail
if test $# -ne 2; then
    echo "Usage:   $(basename "$0") module_name username@ip"
    echo "Example: $(basename "$0") openvpn pi@192.168.1.1"
    exit 1
fi

module="$1"
destination="$2"

ssh-copy-id "$destination"

ssh "$destination" "rm -rf /tmp/module-install; mkdir /tmp/module-install/"
scp -r "../modules/$module/"* "$destination:/tmp/module-install/"

ssh "$destination" 'bash -s' << 'EOF'
sudo cp -r /tmp/module-install/* /
sudo rm -rf /tmp/module-install

for script in /build.d/*.sh; do
    sudo bash -x "$script"
done

sudo mkdir -p /build.d/done
sudo mv /build.d/*.sh /build.d/done

EOF