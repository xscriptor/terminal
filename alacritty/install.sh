#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="$HOME/.config/alacritty/colors"
mkdir -p "$DEST_DIR"
cp "$SCRIPT_DIR/alacritty.toml" "$DEST_DIR/xscriptor.toml"
MAIN="$HOME/.config/alacritty/alacritty.toml"
if [ -f "$MAIN" ]; then
  if ! grep -q "$DEST_DIR/xscriptor.toml" "$MAIN"; then
    if ! grep -q "^import" "$MAIN"; then
      printf '\nimport = ["%s"]\n' "$DEST_DIR/xscriptor.toml" >> "$MAIN"
    fi
  fi
else
  printf 'import = ["%s"]\n' "$DEST_DIR/xscriptor.toml" > "$MAIN"
fi

