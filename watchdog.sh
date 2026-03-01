#!/bin/bash

while true
do
    # Check XRDP
    if ! systemctl is-active --quiet xrdp; then
        systemctl restart xrdp
        echo "XRDP Restarted" >> /var/log/rdp-watchdog.log
    fi

    # Check Tailscale
    if ! systemctl is-active --quiet tailscaled; then
        systemctl restart tailscaled
        echo "Tailscale Restarted" >> /var/log/rdp-watchdog.log
    fi

    sleep 30
done
