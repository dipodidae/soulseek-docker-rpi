# Build Scripts

This directory contains modular build scripts used during Docker image construction.

## Scripts

### install-s6-overlay.sh
Installs the s6-overlay init system for process supervision.
- Downloads both noarch and x86_64 versions
- Extracts to root filesystem

### install-novnc.sh
Sets up noVNC for web-based VNC access.
- Downloads and installs noVNC and websockify
- Downloads custom FontAwesome icons
- Applies UI patches and styling
- Creates symlinks to data directories

### install-soulseek.sh
Downloads and extracts the SoulseekQt application.
- Downloads AppImage from official source
- Extracts contents to /app
- Strips binary to reduce size
- Supports SOULSEEK_VERSION environment variable

### setup-user.sh
Configures the soulseek user and data directory.
- Removes conflicting users/groups
- Creates soulseek user (UID 1000)
- Sets up /data directory

### cleanup.sh
Performs final image cleanup.
- Removes build dependencies
- Cleans package cache
- Removes temporary files

## Usage

These scripts are automatically executed during the Docker build process. They are copied to `/build-scripts/` in the container, executed in order, then removed.

You can also run them individually for testing:
```bash
chmod +x scripts/*.sh
./scripts/install-s6-overlay.sh
```
