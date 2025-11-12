#!/bin/bash
#
# Install s6-overlay init system for process supervision.
# Downloads and installs both noarch and x86_64 versions.

set -euo pipefail

readonly S6_OVERLAY_VERSION="latest"
readonly S6_BASE_URL="https://github.com/just-containers/s6-overlay/releases/${S6_OVERLAY_VERSION}/download"

main() {
  echo "Installing s6-overlay..."

  # Download and install s6-overlay (noarch)
  curl -fL# "${S6_BASE_URL}/s6-overlay-noarch.tar.xz" -o /tmp/s6-overlay-noarch.tar.xz
  tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
  rm -rf /tmp/s6-overlay-noarch.tar.xz

  # Download and install s6-overlay (x86_64)
  curl -fL# "${S6_BASE_URL}/s6-overlay-x86_64.tar.xz" -o /tmp/s6-overlay-x86_64.tar.xz
  tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
  rm -rf /tmp/s6-overlay-x86_64.tar.xz

  echo "s6-overlay installation complete"
}

main "$@"
