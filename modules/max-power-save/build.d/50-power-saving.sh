#!/bin/bash

cat <<EOF >> /boot/config.txt

dtoverlay=disable-bt

# Disable Activity LED
dtparam=act_led_trigger=none
dtparam=act_led_activelow=off

# Disable Power LED
dtparam=pwr_led_trigger=none
dtparam=pwr_led_activelow=off

disable_camera_led=1
EOF

sed -i 's/dtparam=audio=on/dtparam=audio=off/g' /boot/config.txt

systemctl enable power-save.timer

# systemctl disable apt-daily.timer
# systemctl mask apt-daily.service
# systemctl disable apt-daily-upgrade.timer
# systemctl mask apt-daily-upgrade.service
