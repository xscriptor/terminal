#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="$HOME/.hyper.js"
if [ ! -f "$TARGET" ]; then
  cp "$SCRIPT_DIR/xscriptor.js" "$TARGET"
fi

