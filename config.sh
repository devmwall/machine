#!/bin/bash

# Main setup script: setup.sh
#!/bin/bash

# Preserve the original user's home directory when running with sudo
ORIGINAL_USER=$(logname)
ORIGINAL_HOME="/home/$ORIGINAL_USER"
DEV_ENV="$ORIGINAL_HOME/dev/machine"

echo "Debug: Running setup for user $ORIGINAL_USER"
echo "Debug: Using DEV_ENV path: $DEV_ENV"
echo "Debug: Using HOME path: $ORIGINAL_HOME"

# Verify DEV_ENV is a valid directory
if [ ! -d "$DEV_ENV" ]; then
    echo "Error: DEV_ENV directory does not exist."
    echo "Attempted directory: $DEV_ENV"
    exit 1
fi

# Update system
# Install core packages
#!/usr/bin/env bash

# Create configuration directories
mkdir -p "$ORIGINAL_HOME/.config/i3"
mkdir -p "$ORIGINAL_HOME/.config/nvim"
mkdir -p "$ORIGINAL_HOME/.config/Code/User"
mkdir -p "$ORIGINAL_HOME/.config/ghostty/"
mkdir -p "$ORIGINAL_HOME/.config/keyboard/"
mkdir -p "$ORIGINAL_HOME/.config/hypr/"


# Copy configuration files with debug output
echo "Copying i3 config:"
echo "Source: $DEV_ENV/env/.config/i3/config"
echo "Destination: $ORIGINAL_HOME/.config/i3/config"
cp "$DEV_ENV/env/.config/i3/config" "$ORIGINAL_HOME/.config/i3/config"

echo "Copying neovim config:"
echo "Source: $DEV_ENV/env/.config/nvim/."
echo "Destination: $ORIGINAL_HOME/.config/nvim/"
cp -a "$DEV_ENV/env/.config/nvim/." "$ORIGINAL_HOME/.config/nvim/"
cp -a "$DEV_ENV/env/.config/hypr/." "$ORIGINAL_HOME/.config/hypr/"
cp -a "$DEV_ENV/env/.config/wal/." "$ORIGINAL_HOME/.config/wal/"

echo "Copying VSCode settings:"
echo "Source: $DEV_ENV/env/.config/vscode/settings.json"
echo "Destination: $ORIGINAL_HOME/.config/Code/User/settings.json"
cp "$DEV_ENV/env/.config/vscode/settings.json" "$ORIGINAL_HOME/.config/Code/User/settings.json"

echo "Copying VSCode keybindings:"
echo "Source: $DEV_ENV/env/.config/vscode/keybindings.json"
echo "Destination: $ORIGINAL_HOME/.config/Code/User/keybindings.json"
cp "$DEV_ENV/env/.config/vscode/keybindings.json" "$ORIGINAL_HOME/.config/Code/User/keybindings.json"

echo "Copying Ghostty config:"
echo "Source: $DEV_ENV/env/.config/ghostty/config"
echo "Destination: $ORIGINAL_HOME/.config/ghostty/config"
cp "$DEV_ENV/env/.config/ghostty/config" "$ORIGINAL_HOME/.config/ghostty/config"

echo "Copying Keyboard config:"
echo "Source: $DEV_ENV/.config/keyboard/"
echo "Destination: $ORIGINAL_HOME/.config/keyboard/"
cp -a "$DEV_ENV/env/.config/keyboard/." "$ORIGINAL_HOME/.config/keyboard/"
cp -a "$DEV_ENV/env/.config/waybar/." "$ORIGINAL_HOME/.config/waybar/"
cp -a "$DEV_ENV/env/.config/wal/." "$ORIGINAL_HOME/.config/wal/"


cp -a "$DEV_ENV/env/.local/." "$ORIGINAL_HOME/.local"

chmod +x $ORIGINAL_HOME/.local/scripts/hdmi

# Ensure correct ownership
chown -R $ORIGINAL_USER:$ORIGINAL_USER "$ORIGINAL_HOME/.config/i3"
chown -R $ORIGINAL_USER:$ORIGINAL_USER "$ORIGINAL_HOME/.config/nvim"
chown -R $ORIGINAL_USER:$ORIGINAL_USER "$ORIGINAL_HOME/.config/Code"
chown -R $ORIGINAL_USER:$ORIGINAL_USER "$ORIGINAL_HOME/.config/ghostty"
chown -R $ORIGINAL_USER:$ORIGINAL_USER "$ORIGINAL_HOME/.config/keyboard"

echo "Setup complete!"
