#!/bin/bash
set -e

echo "Performing final cleanup..."

# Remove build dependencies
apt-get purge -y binutils curl dbus patch xz-utils

# Remove unused packages
apt-get autoremove -y

# Clean package cache and temp files
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

echo "Cleanup complete"
