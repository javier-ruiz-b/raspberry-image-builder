#!/bin/sh

echo "dtparam=watchdog=on" | sudo tee -a /boot/config.txt
