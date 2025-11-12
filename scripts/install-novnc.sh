#!/bin/bash
#
# Install and configure noVNC for web-based VNC access.
# Downloads noVNC, websockify, custom icons, applies patches and styling.

set -euo pipefail

readonly NOVNC_DIR="/usr/share/novnc"
readonly NOVNC_IMAGES="${NOVNC_DIR}/app/images"
readonly FONTAWESOME_BASE="https://site-assets.fontawesome.com/releases/v6.0.0/svgs/solid"

main() {
  echo "Installing and configuring noVNC..."

  # Create noVNC directory and download
  mkdir -p "${NOVNC_DIR}"
  curl -fL# https://github.com/novnc/noVNC/archive/master.tar.gz -o /tmp/novnc.tar.gz
  tar -xf /tmp/novnc.tar.gz --strip-components=1 -C "${NOVNC_DIR}"
  rm -f /tmp/novnc.tar.gz

  # Download and install websockify
  mkdir -p "${NOVNC_DIR}/utils/websockify"
  curl -fL# https://github.com/novnc/websockify/archive/master.tar.gz -o /tmp/websockify.tar.gz
  tar -xf /tmp/websockify.tar.gz --strip-components=1 -C "${NOVNC_DIR}/utils/websockify"
  rm -f /tmp/websockify.tar.gz

  # Download custom icons
  curl -fL# "${FONTAWESOME_BASE}/cloud-arrow-down.svg" -o "${NOVNC_IMAGES}/downloads.svg"
  curl -fL# "${FONTAWESOME_BASE}/folder-music.svg" -o "${NOVNC_IMAGES}/shared.svg"
  curl -fL# "${FONTAWESOME_BASE}/comments.svg" -o "${NOVNC_IMAGES}/logs.svg"

  # Style the icons (make them white)
  sed -i "s/<path/<path style=\"fill:white\"/" "${NOVNC_IMAGES}/downloads.svg"
  sed -i "s/<path/<path style=\"fill:white\"/" "${NOVNC_IMAGES}/logs.svg"
  sed -i "s/<path/<path style=\"fill:white\"/" "${NOVNC_IMAGES}/shared.svg"

  # Apply UI patch
  if [[ -f /tmp/ui.patch ]]; then
    patch "${NOVNC_DIR}/vnc.html" < /tmp/ui.patch
  fi

  # Adjust CSS
  sed -i 's/10px 0 5px/8px 0 6px/' "${NOVNC_DIR}/app/styles/base.css"

  # Create symlinks for data directories
  ln -sf /app/default.png "${NOVNC_IMAGES}/soulseek.png"
  ln -sf /data/downloads "${NOVNC_DIR}/downloads"
  ln -sf /data/shared "${NOVNC_DIR}/shared"
  ln -sf /data/logs "${NOVNC_DIR}/logs"

  echo "noVNC installation complete"
}

main "$@"
