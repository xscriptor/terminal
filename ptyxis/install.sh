#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="$HOME/.config/ptyxis/palettes"
mkdir -p "$DEST_DIR"
for f in "$SCRIPT_DIR"/*.palette; do
  [ -f "$f" ] && cp "$f" "$DEST_DIR/"
done

