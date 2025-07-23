#!/bin/bash

# Usage: ./add_app_to_rofi.sh /path/to/AppImage

set -e

APPIMAGE_PATH="$1"
DEST_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"

if [[ ! -f "$APPIMAGE_PATH" ]]; then
    echo "Error: File not found: $APPIMAGE_PATH"
    exit 1
fi

mkdir -p "$DEST_DIR"
mkdir -p "$DESKTOP_DIR"

FILENAME=$(basename "$APPIMAGE_PATH")
APP_NAME="${FILENAME%%.AppImage}"
DEST_PATH="$DEST_DIR/$FILENAME"

echo "Moving AppImage to $DEST_PATH..."
mv "$APPIMAGE_PATH" "$DEST_PATH"
chmod +x "$DEST_PATH"

# Create .desktop file
DESKTOP_FILE="$DESKTOP_DIR/$APP_NAME.desktop"

echo "Creating .desktop file at $DESKTOP_FILE..."
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=$APP_NAME
Exec=$DEST_PATH
Icon=$APP_NAME
Type=Application
Categories=Utility;
Terminal=false
EOF

echo "Updating desktop database..."
update-desktop-database "$DESKTOP_DIR" || true

echo "Done. You can now launch '$APP_NAME' via Rofi."
