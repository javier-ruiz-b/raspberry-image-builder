#!/bin/sh
set -eu
cd "$1"

chmod 755 /bin/*
chmod 755 /usr/local/bin/* 2>/dev/null || true
chmod 400 /etc/sudoers.d/* 2>/dev/null || true