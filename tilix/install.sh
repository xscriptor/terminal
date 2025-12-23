#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="$HOME/.config/tilix/schemes"
mkdir -p "$DEST_DIR"
cp "$SCRIPT_DIR/xscriptor.json" "$DEST_DIR/Xscriptor.json"

