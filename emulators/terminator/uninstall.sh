#!/usr/bin/env sh
set -e

TARGET_CONFIG_DIR="$HOME/.config/terminator"
MAIN="$TARGET_CONFIG_DIR/config"

echo "Starting Terminator themes uninstaller..."

remove_aliases() {
  RC="$1"
  [ -f "$RC" ] || return 0
  if sed --version >/dev/null 2>&1; then
    sed -i '/^ttx() {/,/^}/d' "$RC" || true
    sed -i -E '/^alias ttx[[:alnum:]]\{1,\}=/d' "$RC" || true
  else
    sed -i '' '/^ttx() {/,/^}/d' "$RC" || true
    sed -i '' -E '/^alias ttx[[:alnum:]]\{1,\}=/d' "$RC" || true
  fi
}

remove_aliases "$HOME/.bashrc" && echo "Removed aliases from ~/.bashrc" || true
remove_aliases "$HOME/.zshrc" && echo "Removed aliases from ~/.zshrc" || true

restore_config_file() {
  FILE="$1"
  [ -f "$FILE" ] || { echo "Config not found: $FILE"; return 0; }
  LATEST="$(ls -1t "$FILE".bak.* 2>/dev/null | head -1 || true)"
  if [ -n "$LATEST" ] && [ -f "$LATEST" ]; then
    cp -f "$LATEST" "$FILE"
    echo "Restored backup: $LATEST -> $FILE"
    return 0
  fi
  echo "Left config unchanged: $FILE"
}

restore_config_file "$MAIN"

echo "Terminator themes uninstall completed."
