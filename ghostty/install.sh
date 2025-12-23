#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="$HOME/.config/ghostty/themes"
mkdir -p "$DEST_DIR"
cp "$SCRIPT_DIR/xscriptor.ini" "$DEST_DIR/xscriptor.ini"
CONF="$HOME/.config/ghostty/config"
mkdir -p "$(dirname "$CONF")"
if [ -f "$CONF" ]; then
  if ! grep -q '^theme *= *xscriptor' "$CONF"; then
    printf '\ntheme = xscriptor\n' >> "$CONF"
  fi
else
  printf 'theme = xscriptor\n' > "$CONF"
fi

