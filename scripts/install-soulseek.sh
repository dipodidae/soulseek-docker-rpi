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

  # Extract AppImage - try direct execution first, fall back to manual extraction
  cd /tmp
  if ! ./SoulseekQt.AppImage --appimage-extract 2>/dev/null; then
    echo "Direct extraction failed, attempting manual extraction..."
    # Find the LAST occurrence of 'hsqs' which is the actual squashfs
    offset=$(python3 -c "
data = open('/tmp/SoulseekQt.AppImage', 'rb').read()
pos = data.rfind(b'hsqs')
print(pos if pos > 0 else '')
")
    
    if [ -n "$offset" ] && [ "$offset" != "-1" ]; then
      echo "Found squashfs at offset $offset"
      dd if=/tmp/SoulseekQt.AppImage bs=1 skip="$offset" of=/tmp/filesystem.squashfs 2>/dev/null
      unsquashfs -d /tmp/squashfs-root /tmp/filesystem.squashfs
      rm -f /tmp/filesystem.squashfs
    else
      echo "ERROR: Could not find squashfs offset in AppImage"
      exit 1
    fi
  fi

  # Move to /app and cleanup
  mv /tmp/squashfs-root /app
  rm -f /tmp/SoulseekQt.AppImage

  # Strip binary to reduce size
  strip /app/SoulseekQt 2>/dev/null || true

  echo "SoulseekQt installation complete"
}

main "$@"
