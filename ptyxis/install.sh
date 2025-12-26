#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="$HOME/.local/share/org.gnome.Ptyxis/palettes/"
SRC_DIR="$SCRIPT_DIR/themes"
mkdir -p "$DEST_DIR"
if [ -d "$SRC_DIR" ]; then
  for f in "$SRC_DIR"/*.palette; do
    [ -f "$f" ] && cp "$f" "$DEST_DIR/"
  done
fi
