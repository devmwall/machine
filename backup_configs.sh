#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_USER="${SUDO_USER:-$USER}"
SOURCE_HOME="$(getent passwd "$SOURCE_USER" | cut -d: -f6)"

if [[ -z "$SOURCE_HOME" || ! -d "$SOURCE_HOME" ]]; then
  echo "Error: failed to resolve source home for $SOURCE_USER"
  exit 1
fi

copy_dir() {
  local src="$1"
  local dst="$2"
  if [[ -d "$src" ]]; then
    mkdir -p "$dst"
    rsync -a "$src"/ "$dst"/
  fi
}

copy_file() {
  local src="$1"
  local dst="$2"
  if [[ -f "$src" ]]; then
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
  fi
}

copy_file "$SOURCE_HOME/.config/i3/config" "$REPO_ROOT/env/.config/i3/config"
copy_dir "$SOURCE_HOME/.config/nvim" "$REPO_ROOT/env/.config/nvim"
copy_dir "$SOURCE_HOME/.config/hypr" "$REPO_ROOT/env/.config/hypr"
copy_dir "$SOURCE_HOME/.config/waybar" "$REPO_ROOT/env/.config/waybar"
copy_dir "$SOURCE_HOME/.config/wal" "$REPO_ROOT/env/.config/wal"
copy_dir "$SOURCE_HOME/.config/ghostty" "$REPO_ROOT/env/.config/ghostty"
copy_dir "$SOURCE_HOME/.config/keyboard" "$REPO_ROOT/env/.config/keyboard"
copy_dir "$SOURCE_HOME/.config/keyd" "$REPO_ROOT/env/.config/keyd"

copy_file "$SOURCE_HOME/.bashrc" "$REPO_ROOT/env/.bashrc"
copy_file "$SOURCE_HOME/.profile" "$REPO_ROOT/env/.profile"

copy_file "$SOURCE_HOME/.config/Code/User/settings.json" "$REPO_ROOT/env/.config/vscode/settings.json"
copy_file "$SOURCE_HOME/.config/Code/User/keybindings.json" "$REPO_ROOT/env/.config/vscode/keybindings.json"

echo "Config backup complete."
