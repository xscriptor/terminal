#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="$HOME/.config/ghostty/themes"
mkdir -p "$DEST_DIR"
cp "$SCRIPT_DIR/xscriptor.ini" "$DEST_DIR/xscriptor.ini"
CONF="$HOME/.config/ghostty/config"
mkdir -p "$(dirname "$CONF")"
THEME_PATH="$DEST_DIR/xscriptor.ini"
if [ -f "$CONF" ]; then
  awk 'BEGIN{replaced=0}
    /^theme[[:space:]]*=/ { print "theme = \""'"$THEME_PATH"'"\""; replaced=1; next }
    { print }
    END { if (!replaced) print "theme = \""'"$THEME_PATH"'"\"" }' "$CONF" > "$CONF.tmp" && mv "$CONF.tmp" "$CONF"
else
  printf 'theme = "%s"\n' "$THEME_PATH" > "$CONF"
fi
