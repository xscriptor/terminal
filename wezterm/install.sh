#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="$HOME/.config/wezterm/colors"
mkdir -p "$DEST_DIR"
cp "$SCRIPT_DIR/xscriptor.lua" "$DEST_DIR/xscriptor.lua"
MAIN="$HOME/.config/wezterm/wezterm.lua"
if [ ! -f "$MAIN" ]; then
  printf 'local config = {}\nconfig.colors = require("colors.xscriptor")\nreturn config\n' > "$MAIN"
fi

