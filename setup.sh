#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

if [[ -z "$TARGET_HOME" || ! -d "$TARGET_HOME" ]]; then
  echo "Error: failed to resolve home directory for $TARGET_USER"
  exit 1
fi

run_as_user() {
  if [[ "$(id -u)" -eq 0 ]]; then
    sudo -u "$TARGET_USER" HOME="$TARGET_HOME" "$@"
  else
    "$@"
  fi
}

if ! command -v apt-get >/dev/null 2>&1; then
  echo "Error: apt-get not found. Install Ubuntu or another apt-based distro first."
  exit 1
fi

echo "Setting up dev environment from: $REPO_ROOT"

sudo apt-get update
sudo apt-get install -y \
  apt-transport-https \
  bash \
  bluez \
  brightnessctl \
  build-essential \
  ca-certificates \
  curl \
  fd-find \
  fzf \
  git \
  gnupg \
  golang-go \
  hyprland \
  hyprlock \
  hyprpaper \
  keyd \
  lua5.4 \
  luarocks \
  network-manager-gnome \
  neovim \
  pipewire-audio \
  pipewire-pulse \
  playerctl \
  ripgrep \
  rofi-wayland \
  rsync \
  swww \
  waybar \
  wireplumber \
  wl-clipboard \
  wget

mkdir -p "$TARGET_HOME/.local/bin" "$TARGET_HOME/go/bin"
chown -R "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.local" "$TARGET_HOME/go" 2>/dev/null || true

if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" "$TARGET_HOME/.local/bin/fd"
  chown -h "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.local/bin/fd" 2>/dev/null || true
fi

if ! command -v code >/dev/null 2>&1; then
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
  sudo sh -c 'printf "%s\n" "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt-get update
  sudo apt-get install -y code
fi

if ! command -v opencode >/dev/null 2>&1; then
  run_as_user bash -lc 'curl -fsSL https://opencode.ai/install | bash'
fi

"$REPO_ROOT/scripts/apply-config.sh"

if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl enable --now bluetooth keyd || true
fi

if command -v git >/dev/null 2>&1; then
  run_as_user git config --global user.email "me@mattwall.dev"
  run_as_user git config --global user.name "devmwall"
fi

echo "Setup complete."
