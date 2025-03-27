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
dnf update -y

# Install core packages
dnf install -y \
    i3 \
    neovim \
    tmux \
    gimp \
    python3 \
    python3-pip \
    NetworkManager-tui \
    rofi

dnf copr enable pgdev/ghostty
dnf install ghostty


# Visual Studio Code (VSCode) installation
rpm --import https://packages.microsoft.com/keys/microsoft.asc
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
dnf install -y code

# Create configuration directories
mkdir -p "$ORIGINAL_HOME/.config/i3"
mkdir -p "$ORIGINAL_HOME/.config/nvim"
mkdir -p "$ORIGINAL_HOME/.config/Code/User"
mkdir -p "$ORIGINAL_HOME/.config/ghostty/"

# Copy configuration files with debug output
echo "Copying i3 config:"
echo "Source: $DEV_ENV/env/.config/i3/config"
echo "Destination: $ORIGINAL_HOME/.config/i3/config"
cp "$DEV_ENV/env/.config/i3/config" "$ORIGINAL_HOME/.config/i3/config"

echo "Copying neovim config:"
echo "Source: $DEV_ENV/env/.config/nvim/init.lua"
echo "Destination: $ORIGINAL_HOME/.config/nvim/init.lua"
cp "$DEV_ENV/env/.config/nvim/init.lua" "$ORIGINAL_HOME/.config/nvim/init.lua"

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

# Ensure correct ownership
chown -R $ORIGINAL_USER:$ORIGINAL_USER "$ORIGINAL_HOME/.config/i3"
chown -R $ORIGINAL_USER:$ORIGINAL_USER "$ORIGINAL_HOME/.config/nvim"
chown -R $ORIGINAL_USER:$ORIGINAL_USER "$ORIGINAL_HOME/.config/Code"
chown -R $ORIGINAL_USER:$ORIGINAL_USER "$ORIGINAL_HOME/.config/config"

echo "Setup complete!"
