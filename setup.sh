#!/bin/bash

echo "===== RDP PRO V2 INSTALLER ====="

apt update && apt upgrade -y

# Desktop ringan
apt install xfce4 xfce4-goodies -y

# XRDP
apt install xrdp -y
systemctl enable xrdp

# Config session XFCE
echo "xfce4-session" > /etc/skel/.xsession
echo "xfce4-session" > ~/.xsession

# Optimize XRDP performance
cat <<EOF > /etc/xrdp/xrdp.ini
[Globals]
bitmap_cache=yes
bitmap_compression=yes
port=3389
max_bpp=16
EOF

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Enable IP Forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Watchdog service
chmod +x watchdog.sh
cp watchdog.sh /usr/local/bin/rdp-watchdog.sh

cat <<EOF > /etc/systemd/system/rdp-watchdog.service
[Unit]
Description=RDP Pro Watchdog

[Service]
ExecStart=/usr/local/bin/rdp-watchdog.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable rdp-watchdog
systemctl start rdp-watchdog

# Start services
systemctl restart xrdp

echo "================================"
echo " RDP PRO V2 INSTALL COMPLETE"
echo "================================"

echo "Run:"
echo "tailscale up"