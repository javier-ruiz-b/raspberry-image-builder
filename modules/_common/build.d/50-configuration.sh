#!/bin/bash

# configure timezone and locale
rm -f /etc/localtime
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

cat <<EOF >> /tmp/tzdata.txt
tzdata tzdata/Areas select Europe
tzdata tzdata/Zones/Europe select Berlin
EOF
debconf-set-selections /tmp/tzdata.txt

cat <<EOF >> /tmp/locales.txt
locales locales/locales_to_be_generated multiselect     en_US.UTF-8 UTF-8
locales locales/default_environment_locale      select  en_US.UTF-8
EOF
debconf-set-selections /tmp/locales.txt

#enable services
systemctl enable expand-filesystem \
    ssh

#hostname
echo "$config" > /etc/hostname

cat << EOF > /etc/hosts
127.0.0.1 localhost
127.0.1.1 $config

::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF

mkdir -p /home/pi
groupadd spi
groupadd i2c
groupadd gpio
useradd -s /bin/bash -d /home/pi -G sudo,video,adm,dialout,cdrom,audio,plugdev,games,users,input,netdev,spi,i2c,gpio pi
chown -R pi:pi /home/pi

echo "pi:raspberry" | chpasswd
echo "root:raspberry" | chpasswd

#disable unnecessary services
systemctl disable \
    e2scrub_all \
    e2scrub_reap \
    apply_noobs_os_config