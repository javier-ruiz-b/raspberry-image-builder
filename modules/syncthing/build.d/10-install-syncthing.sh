#!/bin/bash
curl -s -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | tee /etc/apt/sources.list.d/syncthing.list
printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | tee /etc/apt/preferences.d/syncthing

apt-get update
apt-get install -yq syncthing

# allow setting owner and mode
sed 's/^#AmbientCapabilities/AmbientCapabilities/g' /lib/systemd/system/syncthing\@.service  > /etc/systemd/system/syncthing\@.service

systemctl daemon-reload

systemctl enable syncthing@pi.service