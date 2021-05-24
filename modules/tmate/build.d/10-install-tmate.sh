#!/bin/bash
set -e
cd /tmp
wget https://github.com/tmate-io/tmate/releases/download/2.4.0/tmate-2.4.0-static-linux-arm32v6.tar.xz
tar xfJ tmate-*-static-linux-arm32v6.tar.xz
rm tmate-*-static-linux-arm32v6.tar.xz
mv tmate-*-static-linux-arm32v6/tmate /usr/local/bin/tmate
