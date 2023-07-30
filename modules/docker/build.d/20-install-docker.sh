#!/bin/bash
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sh /tmp/get-docker.sh

docker_compose_version=v2.20.2
curl -SL "https://github.com/docker/compose/releases/download/$docker_compose_version/docker-compose-linux-$(arch)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

systemctl enable docker-cleanup