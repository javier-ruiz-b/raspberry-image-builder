#!/bin/bash

cat <<EOF >> /boot/config.txt

dtoverlay=disable-bt

# Disable Activity LED
dtparam=act_led_trigger=none
dtparam=act_led_activelow=off

# Disable Power LED
dtparam=pwr_led_trigger=none
dtparam=pwr_led_activelow=off

start_x=1             # essential for camera
gpu_mem=128           # at least for camera
disable_camera_led=1
EOF

sed -i 's/dtparam=audio=on/dtparam=audio=off/g' /boot/config.txt


systemctl disable apt-daily.timer
systemctl mask apt-daily.service
systemctl disable apt-daily-upgrade.timer
systemctl mask apt-daily-upgrade.service
systemctl mask apply_noobs_os_config.service
systemctl mask fake-hwclock.service
systemctl mask keyboard-setup.service
systemctl mask dphys-swapfile.service

# sed 's#Exec=.*$#Exec=/bin/false#g' /usr/share/dbus-1/system-services/org.freedesktop.PolicyKit1.service