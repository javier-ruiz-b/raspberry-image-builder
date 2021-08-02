#!/bin/sh

echo "dtparam=watchdog=on" | sudo tee -a /boot/config.txt

cat << EOF >> /etc/modprobe.d/bcm2708_wdog.conf
alias char-major-10-130 bcm2708_wdog
alias char-major-10-131 bcm2708_wdog
options bcm2708_wdog heartbeat=15 nowayout=1
EOF
