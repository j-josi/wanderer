# LAYER: System Setup
# PURPOSE: Installs global development dependencies required on the host machine
# EXECUTION: one-time per machine setup or after OS / toolchain changes
# FREQUENCY: rarely (once per machine)

#!/usr/bin/env bash
set -e

OS="$(uname -s)"

echo "----------- System dependencies -----------"

install_macos() {
  brew install nvm
  brew install go

  # node module 'sharp' fails on Apple Silicon if vips is installed
  # (see https://github.com/lovell/sharp/issues/2588#issuecomment-783254806)
  if brew list --formula | grep -q "^vips$"; then
    brew uninstall vips
  fi
}

install_linux() {
  # Detect Arch-based systems with paru first (CachyOS)
  if command -v paru >/dev/null 2>&1; then
    paru -S --noconfirm go nvm

  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -Sy --noconfirm go
    # nvm is typically installed via curl on Arch-based systems

  elif command -v apt >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y golang
  else
    echo "Unsupported Linux package manager"
    exit 1
  fi

  # IMPORTANT:
  # vips is NOT removed on Linux (required or managed differently)
}

case "$OS" in
  Darwin)
    install_macos
    ;;
  Linux)
    install_linux
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

echo "----------- Done -----------"