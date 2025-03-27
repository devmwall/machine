#!/bin/bash

# Preserve the original user's home directory when running with sudo
ORIGINAL_USER=$(logname)
ORIGINAL_HOME="/home/$ORIGINAL_USER"
DEV_ENV="$ORIGINAL_HOME/dev/machine"

echo "Debug: Running backup for user $ORIGINAL_USER"
echo "Debug: Using DEV_ENV path: $DEV_ENV"

# Check if DEV_ENV is set
if [ -z "$DEV_ENV" ]; then
    echo "Error: DEV_ENV environment variable is not set."
    echo "Please set DEV_ENV to the path of your development repository."
    echo "Example: export DEV_ENV=/path/to/your/dev/repo"
    exit 1
fi

# Verify DEV_ENV is a valid directory
if [ ! -d "$DEV_ENV" ]; then
    echo "Error: DEV_ENV directory does not exist."
    echo "Please create the directory or check the path: $DEV_ENV"
    exit 1
fi

# Ensure configuration directories exist
mkdir -p "$DEV_ENV/env/.config/i3"
mkdir -p "$DEV_ENV/env/.config/nvim"
mkdir -p "$DEV_ENV/env/.config/vscode"

# Backup i3 config
cp "$ORIGINAL_HOME/.config/i3/config" "$DEV_ENV/env/.config/i3/config"

# Backup Neovim config
cp "$ORIGINAL_HOME/.config/nvim/init.lua" "$DEV_ENV/env/.config/nvim/init.lua"

# Backup VSCode settings
cp "$ORIGINAL_HOME/.config/Code/User/settings.json" "$DEV_ENV/env/.config/vscode/settings.json"
cp "$ORIGINAL_HOME/.config/Code/User/keybindings.json" "$DEV_ENV/env/.config/vscode/keybindings.json"

echo "Configs backed up successfully to $DEV_ENV/env/.config!"
EOF