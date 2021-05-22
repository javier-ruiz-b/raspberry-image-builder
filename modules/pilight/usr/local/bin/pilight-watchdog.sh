#!/bin/dash
while true; do
    if ! curl 127.0.0.1:8090 > /dev/null || \
       pilight-control -d test -s test 2>&1 | grep 'no pilight ssdp connections found'; then
        sudo systemctl restart pilight
    fi
    sleep 45s
done
