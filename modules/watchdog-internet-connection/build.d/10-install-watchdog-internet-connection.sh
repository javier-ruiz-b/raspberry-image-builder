#!/bin/bash
systemctl enable watchdog-internet-connection

chmod +x /usr/share/watchdog-internet-connection/*  2>/dev/null || true