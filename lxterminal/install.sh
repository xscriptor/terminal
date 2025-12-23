#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="$HOME/.config/lxterminal"
mkdir -p "$DEST_DIR"
cp "$SCRIPT_DIR/lxterminal.conf" "$DEST_DIR/lxterminal.conf"

