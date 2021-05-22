#!/bin/bash

mkdir /tmp/noip
cd /tmp/noip
wget https://www.noip.com/client/linux/noip-duc-linux.tar.gz
tar zxf noip-duc-linux.tar.gz
rm noip-duc-linux.tar.gz

cd noip*

make
cp noip2 /usr/local/bin

systemctl enable noip2