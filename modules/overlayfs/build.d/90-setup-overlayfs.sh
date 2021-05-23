#!/bin/sh


update-initramfs -c -k $(uname -r)
bash

cat <<EOF >>/boot/cmdline.txt
initramfs initrd7.img
EOF

sed -i '/s/ root=/boot=overlay root=/g'