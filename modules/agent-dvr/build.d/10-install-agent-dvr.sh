#!/bin/bash

cd /tmp

case "$(dpkg --print-architecture)" in
amd64)      echo not supported; exit 1 ;;
arm64)                
    wget https://download.visualstudio.microsoft.com/download/pr/08602346-21c0-43ed-9520-ad3bf1ab3dc0/0728031d0bdcad6468b3928eaea086ec/aspnetcore-runtime-3.1.11-linux-arm64.tar.gz
    wget https://ispyfiles.azureedge.net/downloads/Agent_ARM64_3_5_2_0.zip
    ;;
armhf)
    wget https://download.visualstudio.microsoft.com/download/pr/cdd0f59e-e9ac-414c-9608-2f1aa415ce88/cf43b2bdd0218ce377027fd40cd5a162/aspnetcore-runtime-3.1.11-linux-arm.tar.gz
    wget https://ispyfiles.azureedge.net/downloads/Agent_ARM32_3_5_2_0.zip
    ;;
esac

mkdir -p /home/pi/dotnet /home/pi/agent-dvr
cd /home/pi/dotnet
tar xfz /tmp/aspnetcore*tar.gz

cd /home/pi/agent-dvr
unzip  /tmp/Agent_ARM*.zip

chown -R pi:pi /home/pi 

apt-get install -yq ffmpeg libtbb-dev libc6-dev gss-ntlmssp libvlc-dev vlc libx11-dev

systemctl enable agent-dvr
