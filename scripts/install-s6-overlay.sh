#!/bin/bash
set -e

echo "Installing s6-overlay..."

# Download and install s6-overlay (noarch)
curl -fL# https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-noarch.tar.xz -o /tmp/s6-overlay-noarch.tar.xz
tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
rm -rf /tmp/s6-overlay-noarch.tar.xz

# Download and install s6-overlay (x86_64)
curl -fL# https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-x86_64.tar.xz -o /tmp/s6-overlay-x86_64.tar.xz
tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
rm -rf /tmp/s6-overlay-x86_64.tar.xz

echo "s6-overlay installation complete"
