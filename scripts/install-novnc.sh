#!/bin/bash
set -e

echo "Installing and configuring noVNC..."

# Create noVNC directory and download
mkdir -p /usr/share/novnc
curl -fL# https://github.com/novnc/noVNC/archive/master.tar.gz -o /tmp/novnc.tar.gz
tar -xf /tmp/novnc.tar.gz --strip-components=1 -C /usr/share/novnc
rm -f /tmp/novnc.tar.gz

# Download and install websockify
mkdir -p /usr/share/novnc/utils/websockify
curl -fL# https://github.com/novnc/websockify/archive/master.tar.gz -o /tmp/websockify.tar.gz
tar -xf /tmp/websockify.tar.gz --strip-components=1 -C /usr/share/novnc/utils/websockify
rm -f /tmp/websockify.tar.gz

# Download custom icons
curl -fL# https://site-assets.fontawesome.com/releases/v6.0.0/svgs/solid/cloud-arrow-down.svg -o /usr/share/novnc/app/images/downloads.svg
curl -fL# https://site-assets.fontawesome.com/releases/v6.0.0/svgs/solid/folder-music.svg -o /usr/share/novnc/app/images/shared.svg
curl -fL# https://site-assets.fontawesome.com/releases/v6.0.0/svgs/solid/comments.svg -o /usr/share/novnc/app/images/logs.svg

# Style the icons (make them white)
sed -i "s/<path/<path style=\"fill:white\"/" /usr/share/novnc/app/images/downloads.svg
sed -i "s/<path/<path style=\"fill:white\"/" /usr/share/novnc/app/images/logs.svg
sed -i "s/<path/<path style=\"fill:white\"/" /usr/share/novnc/app/images/shared.svg

# Apply UI patch
if [ -f /tmp/ui.patch ]; then
    patch /usr/share/novnc/vnc.html < /tmp/ui.patch
fi

# Adjust CSS
sed -i 's/10px 0 5px/8px 0 6px/' /usr/share/novnc/app/styles/base.css

# Create symlinks for data directories
ln -sf /app/default.png /usr/share/novnc/app/images/soulseek.png
ln -sf /data/downloads /usr/share/novnc/downloads
ln -sf /data/shared /usr/share/novnc/shared
ln -sf /data/logs /usr/share/novnc/logs

echo "noVNC installation complete"
