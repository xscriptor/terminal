#!/bin/bash

# Xscriptor Theme Installer for XFCE Terminal
# This script installs the Xscriptor theme for XFCE Terminal

set -e

echo "Installing Xscriptor theme for XFCE Terminal..."

# Check if XFCE Terminal is installed
if ! command -v xfce4-terminal &> /dev/null; then
    echo "Error: XFCE Terminal is not installed on this system."
    echo "Please install XFCE Terminal first: sudo apt install xfce4-terminal"
    exit 1
fi

# Create XFCE Terminal colorschemes directory if it doesn't exist
COLORSCHEMES_DIR="$HOME/.local/share/xfce4/terminal/colorschemes"
mkdir -p "$COLORSCHEMES_DIR"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy the theme file
THEME_FILE="$SCRIPT_DIR/xscriptor-theme.theme"
if [ ! -f "$THEME_FILE" ]; then
    echo "Error: Theme file not found at $THEME_FILE"
    exit 1
fi

cp "$THEME_FILE" "$COLORSCHEMES_DIR/"
echo "Theme file copied to $COLORSCHEMES_DIR/"

# Set appropriate permissions
chmod 644 "$COLORSCHEMES_DIR/xscriptor-theme.theme"

echo "Xscriptor theme installed successfully!"
echo ""
echo "To apply the theme:"
echo "1. Open XFCE Terminal"
echo "2. Go to Edit > Preferences"
echo "3. Go to the Colors tab"
echo "4. In the Presets dropdown, select 'Xscriptor Theme'"
echo "5. Click Close"
echo ""
echo "The theme will be applied immediately to new terminal windows."