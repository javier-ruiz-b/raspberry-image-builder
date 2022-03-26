#!/bin/sh
set -eu
echo "Started recovery. Getting an IP over DHCP"
if ! udhcpc -t 5 -n -q; then
    echo "Could not get an IP over DHCP. Exiting..."
    exit 1
fi

