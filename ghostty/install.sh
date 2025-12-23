#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="$HOME/.config/ghostty/themes"
mkdir -p "$DEST_DIR"
cp "$SCRIPT_DIR/xscriptor.ini" "$DEST_DIR/xscriptor"
CONF="$HOME/.config/ghostty/config"
mkdir -p "$(dirname "$CONF")"
THEME_NAME="xscriptor"
if [ -f "$CONF" ]; then
  awk 'BEGIN{replaced=0}
    /^theme[[:space:]]*=/ { print "theme = \""'"$THEME_NAME"'"\""; replaced=1; next }
    { print }
    END { if (!replaced) print "theme = \""'"$THEME_NAME"'"\"" }' "$CONF" > "$CONF.tmp" && mv "$CONF.tmp" "$CONF"
else
  printf 'theme = "%s"\n' "$THEME_NAME" > "$CONF"
fi
