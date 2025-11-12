#!/bin/bash
#
# Perform final image cleanup.
# Removes build dependencies, unused packages, and temporary files.

set -euo pipefail

readonly BUILD_DEPS=(
  binutils
  curl
  dbus
  patch
  xz-utils
)

main() {
  echo "Performing final cleanup..."

  # Remove build dependencies
  apt-get purge -y "${BUILD_DEPS[@]}"

  # Remove unused packages
  apt-get autoremove -y

  # Clean package cache and temp files
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

  echo "Cleanup complete"
}

main "$@"
