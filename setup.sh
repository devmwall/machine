#!/bin/bash
# Preserve the original user's home directory when running with sudo
ORIGINAL_USER=$(logname)
ORIGINAL_HOME=$(eval echo ~$ORIGINAL_USER)
DEV_ENV="$ORIGINAL_HOME/dev/machine"

echo "Debug: Running setup for user $ORIGINAL_USER"
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

# Ensure sudo privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo" 
   exit 1
fi

# Update system
dnf update -y

# Install core packages
dnf install -y \
    i3 \
    neovim \
    tmux \
    gimp \
    python3 \
    python3-pip \
    NetworkManager-tui

# Visual Studio Code (VSCode) installation
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf install -y code

# Create configuration directories
mkdir -p "$HOME/.config/i3"
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/Code/User"

# Copy configuration files
cp "$DEV_ENV/env/.config/i3/config" "$HOME/.config/i3/config"
cp "$DEV_ENV/env/.config/nvim/init.lua" "$HOME/.config/nvim/init.lua"
cp "$DEV_ENV/env/.config/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
cp "$DEV_ENV/env/.config/vscode/keybindings.json" "$HOME/.config/Code/User/keybindings.json"

echo "Setup complete!"