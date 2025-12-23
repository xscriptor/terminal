#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="$HOME/.termux"
mkdir -p "$DEST_DIR"
cp "$SCRIPT_DIR/colors.properties" "$DEST_DIR/colors.properties"
if command -v termux-reload-settings >/dev/null 2>&1; then
  termux-reload-settings
fi

