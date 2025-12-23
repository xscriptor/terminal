#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONF="$HOME/.config/terminator/config"
mkdir -p "$(dirname "$CONF")"
if [ -f "$CONF" ]; then
  if ! grep -q '\[\[xscriptor\]\]' "$CONF"; then
    cat "$SCRIPT_DIR/config" >> "$CONF"
  fi
else
  cp "$SCRIPT_DIR/config" "$CONF"
fi

