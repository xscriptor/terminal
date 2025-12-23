#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="$HOME/.config/foot"
mkdir -p "$DEST_DIR"
cp "$SCRIPT_DIR/foot.ini" "$DEST_DIR/foot.ini"

