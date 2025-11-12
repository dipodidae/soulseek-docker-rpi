#!/bin/bash
#
# Download and extract SoulseekQt application.
# Supports SOULSEEK_VERSION environment variable for version selection.

set -euo pipefail

readonly SOULSEEK_VERSION="${SOULSEEK_VERSION:-2024-6-30}"
readonly SOULSEEK_URL="https://f004.backblazeb2.com/file/SoulseekQt/SoulseekQt-${SOULSEEK_VERSION}.AppImage"

main() {
  echo "Downloading and extracting SoulseekQt ${SOULSEEK_VERSION}..."

  # Download SoulseekQt AppImage
  curl -fL# "${SOULSEEK_URL}" -o /tmp/SoulseekQt.AppImage
  chmod +x /tmp/SoulseekQt.AppImage

  # Extract AppImage
  /tmp/SoulseekQt.AppImage --appimage-extract

  # Move to /app and cleanup
  mv /squashfs-root /app
  rm -f /tmp/SoulseekQt.AppImage

  # Strip binary to reduce size
  strip /app/SoulseekQt 2>/dev/null || true

  echo "SoulseekQt installation complete"
}

main "$@"
