#!/bin/bash
set -e

echo "Setting up user and permissions..."

# Remove existing user/group with UID/GID 1000
userdel -f $(id -nu 1000) 2>/dev/null || true
groupdel -f $(id -ng 1000) 2>/dev/null || true

# Remove default home directories
rm -rf /home

# Create soulseek user
useradd -u 1000 -U -d /data -s /bin/false soulseek
usermod -G users soulseek

# Create data directory
mkdir -p /data

echo "User setup complete"
