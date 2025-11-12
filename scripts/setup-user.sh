#!/bin/bash
#
# Configure soulseek user and data directory.
# Creates user with UID 1000 and sets up /data directory.

set -euo pipefail

readonly SOULSEEK_UID=1000
readonly SOULSEEK_USER="soulseek"
readonly DATA_DIR="/data"

main() {
  echo "Setting up user and permissions..."

  # Remove existing user/group with UID/GID 1000
  local existing_user
  existing_user="$(id -nu "${SOULSEEK_UID}" 2>/dev/null)" || true
  if [[ -n "${existing_user}" ]]; then
    userdel -f "${existing_user}" 2>/dev/null || true
  fi

  local existing_group
  existing_group="$(id -ng "${SOULSEEK_UID}" 2>/dev/null)" || true
  if [[ -n "${existing_group}" ]]; then
    groupdel -f "${existing_group}" 2>/dev/null || true
  fi

  # Remove default home directories
  rm -rf /home

  # Create soulseek user
  useradd -u "${SOULSEEK_UID}" -U -d "${DATA_DIR}" -s /bin/false "${SOULSEEK_USER}"
  usermod -G users "${SOULSEEK_USER}"

  # Create data directory
  mkdir -p "${DATA_DIR}"

  echo "User setup complete"
}

main "$@"
