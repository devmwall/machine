#!/usr/bin/env bash
#
# Ubuntu setup: sway + VSCode + a git-aware bash prompt.
#
# Run as your NORMAL user (it calls sudo where needed):
#   ./setup-ubuntu.sh
#
# DEV_ENV is auto-detected as this script's directory, so it works wherever
# you clone the repo.

set -euo pipefail

DEV_ENV="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"

echo "Using DEV_ENV: $DEV_ENV"

# ---------------------------------------------------------------------------
# 1. Packages
# ---------------------------------------------------------------------------
sudo apt update

# Sway + Wayland essentials. The terminal (ptyxis) already ships with Ubuntu.
sudo apt install -y \
    sway swaybg swayidle swaylock \
    waybar wofi i3status \
    grim slurp wl-clipboard \
    brightnessctl network-manager-gnome \
    jq fonts-jetbrains-mono git curl wget gpg

# VSCode from Microsoft's official apt repo.
if ! command -v code >/dev/null 2>&1; then
    echo "Installing VSCode..."
    sudo install -d -m 0755 /etc/apt/keyrings
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
        | gpg --dearmor \
        | sudo tee /etc/apt/keyrings/packages.microsoft.gpg >/dev/null
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
        | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
    sudo apt update
    sudo apt install -y code
fi

# ---------------------------------------------------------------------------
# 2. Config files
# ---------------------------------------------------------------------------
mkdir -p "$CONFIG/sway" "$CONFIG/waybar" "$CONFIG/Code/User" "$CONFIG/bashrc.d"

echo "Installing sway config..."
cp "$DEV_ENV/env/.config/sway/config" "$CONFIG/sway/config"
install -m 0755 "$DEV_ENV/env/.config/sway/scale.sh" "$CONFIG/sway/scale.sh"

echo "Installing waybar config..."
cp "$DEV_ENV/env/.config/waybar/config"    "$CONFIG/waybar/config"
cp "$DEV_ENV/env/.config/waybar/style.css" "$CONFIG/waybar/style.css"

# JetBrainsMono Nerd Font: waybar's style.css needs it for its icon glyphs,
# otherwise the bar renders empty boxes. (Ubuntu's plain fonts-jetbrains-mono
# is not nerd-patched, so we fetch the nerd build.)
if ! fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    echo "Installing JetBrainsMono Nerd Font..."
    NERD_TMP="$(mktemp -d)"
    if curl -fsSL -o "$NERD_TMP/JetBrainsMono.tar.xz" \
        https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.tar.xz; then
        mkdir -p "$HOME/.local/share/fonts/JetBrainsMonoNerd"
        tar -xf "$NERD_TMP/JetBrainsMono.tar.xz" -C "$HOME/.local/share/fonts/JetBrainsMonoNerd"
        find "$HOME/.local/share/fonts/JetBrainsMonoNerd" -iname '*Windows Compatible*' -delete 2>/dev/null || true
        fc-cache -f "$HOME/.local/share/fonts" >/dev/null 2>&1
    else
        echo "  (font download failed — skipping; waybar icons may show as boxes)"
    fi
    rm -rf "$NERD_TMP"
fi

# Caps Lock <-> Escape swap for the regular GNOME (Ubuntu) session.
# The sway session handles this itself via xkb_options in its config.
if command -v gsettings >/dev/null 2>&1; then
    echo "Setting Caps<->Esc swap for GNOME..."
    gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']" || true
fi

echo "Installing VSCode settings..."
cp "$DEV_ENV/env/.config/vscode/settings.json"    "$CONFIG/Code/User/settings.json"
cp "$DEV_ENV/env/.config/vscode/keybindings.json" "$CONFIG/Code/User/keybindings.json"

# ---------------------------------------------------------------------------
# 3. Git-aware bash prompt
# ---------------------------------------------------------------------------
echo "Installing git-aware bash prompt..."
cp "$DEV_ENV/env/.bashrc.d/git-prompt.sh" "$CONFIG/bashrc.d/git-prompt.sh"

# Source it from ~/.bashrc exactly once.
if ! grep -qF "bashrc.d/git-prompt.sh" "$HOME/.bashrc"; then
    {
        echo ''
        echo '# machine repo: git-aware prompt'
        echo '[ -f "$HOME/.config/bashrc.d/git-prompt.sh" ] && . "$HOME/.config/bashrc.d/git-prompt.sh"'
    } >> "$HOME/.bashrc"
fi

# ---------------------------------------------------------------------------
# 4. Git identity
# ---------------------------------------------------------------------------
git config --global user.email "me@mattwall.dev"
git config --global user.name "devmwall"

echo
echo "Done. Log out and pick 'Sway' at the login screen (or run 'sway' from a TTY)."
echo "Open a new terminal to get the git-aware prompt."
