#!/bin/sh

cat <<EOF >> /boot/config.txt
# Disable Activity LED
dtparam=act_led_trigger=default-on
dtparam=act_led_activelow=off

# Disable Power LED
dtparam=pwr_led_trigger=none
dtparam=pwr_led_activelow=off

disable_camera_led=1
EOF