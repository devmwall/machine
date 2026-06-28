#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"

if [[ -z "$TARGET_HOME" || ! -d "$TARGET_HOME" ]]; then
  echo "Error: failed to resolve home directory for $TARGET_USER"
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

copy_file "$REPO_ROOT/env/.config/i3/config" "$TARGET_HOME/.config/i3/config"
copy_dir "$REPO_ROOT/env/.config/nvim" "$TARGET_HOME/.config/nvim"
copy_dir "$REPO_ROOT/env/.config/hypr" "$TARGET_HOME/.config/hypr"
copy_dir "$REPO_ROOT/env/.config/waybar" "$TARGET_HOME/.config/waybar"
copy_dir "$REPO_ROOT/env/.config/wal" "$TARGET_HOME/.config/wal"
copy_dir "$REPO_ROOT/env/.config/ghostty" "$TARGET_HOME/.config/ghostty"
copy_dir "$REPO_ROOT/env/.config/keyboard" "$TARGET_HOME/.config/keyboard"
copy_dir "$REPO_ROOT/env/.config/keyd" "$TARGET_HOME/.config/keyd"

if [[ -f "$REPO_ROOT/env/.config/keyd/default.config" ]] && command -v sudo >/dev/null 2>&1; then
  sudo install -D -m 644 "$REPO_ROOT/env/.config/keyd/default.config" /etc/keyd/default.conf
fi

copy_file "$REPO_ROOT/env/.bashrc" "$TARGET_HOME/.bashrc"
copy_file "$REPO_ROOT/env/.profile" "$TARGET_HOME/.profile"

copy_file "$REPO_ROOT/env/.config/vscode/settings.json" "$TARGET_HOME/.config/Code/User/settings.json"
copy_file "$REPO_ROOT/env/.config/vscode/keybindings.json" "$TARGET_HOME/.config/Code/User/keybindings.json"

copy_dir "$REPO_ROOT/env/.local" "$TARGET_HOME/.local"

if [[ -d "$TARGET_HOME/.local/scripts" ]]; then
  chmod +x "$TARGET_HOME/.local/scripts"/* 2>/dev/null || true
fi

if [[ "$(id -u)" -eq 0 ]]; then
  chown -R "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.config" "$TARGET_HOME/.local"
  [[ -f "$TARGET_HOME/.bashrc" ]] && chown "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.bashrc"
  [[ -f "$TARGET_HOME/.profile" ]] && chown "$TARGET_USER:$TARGET_USER" "$TARGET_HOME/.profile"
fi

echo "Configuration sync complete for $TARGET_USER."
