#!/bin/bash

# Xscriptor Theme Installer for Konsole (KDE)
# This script installs the Xscriptor theme for Konsole

set -e

echo "Installing Xscriptor theme for Konsole..."

if ! command -v konsole &> /dev/null; then
    echo "Error: Konsole is not installed on this system."
    echo "Please install Konsole first: sudo apt install konsole"
    exit 1
fi

COLORSCHEMES_DIR="$HOME/.local/share/konsole"
mkdir -p "$COLORSCHEMES_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SCHEME_SRC="$SCRIPT_DIR/xscriptor.colorscheme"
if [ ! -f "$SCHEME_SRC" ]; then
  echo "Error: colorscheme file not found: $SCHEME_SRC"
  exit 1
fi

cp -f "$SCHEME_SRC" "$COLORSCHEMES_DIR/"

echo "Installed: $COLORSCHEMES_DIR/$(basename "$SCHEME_SRC")"
echo "Open Konsole → Settings → Edit Current Profile → Appearance and select 'Xscriptor'."
