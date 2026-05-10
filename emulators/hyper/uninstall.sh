#!/usr/bin/env sh
set -e

detect_config() {
  if [ -d "$HOME/Library/Application Support/Hyper" ]; then
    echo "$HOME/Library/Application Support/Hyper/.hyper.js"
    return 0
  fi
  if [ -n "$APPDATA" ] && [ -d "$APPDATA/Hyper" ]; then
    echo "$APPDATA/Hyper/.hyper.js"
    return 0
  fi
  if [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/Hyper" ]; then
    echo "${XDG_CONFIG_HOME:-$HOME/.config}/Hyper/.hyper.js"
    return 0
  fi
  echo "$HOME/.hyper.js"
}

CONFIG_PATH="$(detect_config)"
CONFIG_DIR="$(dirname "$CONFIG_PATH")"
PLUGINS_LOCAL_DIR="$CONFIG_DIR/.hyper_plugins/local/hyper-xscriptor-themes"

echo "Starting Hyper themes uninstaller..."

remove_aliases() {
  RC="$1"
  [ -f "$RC" ] || return 0
  if sed --version >/dev/null 2>&1; then
    sed -i '/^hyperx() {/,/^}/d' "$RC" || true
    sed -i -E '/^alias hyperx[[:alnum:]]+=/d' "$RC" || true
  else
    sed -i '' '/^hyperx() {/,/^}/d' "$RC" || true
    sed -i '' -E '/^alias hyperx[[:alnum:]]+=/d' "$RC" || true
  fi
}

remove_aliases "$HOME/.bashrc" && echo "Removed aliases from ~/.bashrc" || true
remove_aliases "$HOME/.zshrc" && echo "Removed aliases from ~/.zshrc" || true

if [ -d "$PLUGINS_LOCAL_DIR" ]; then
  rm -rf "$PLUGINS_LOCAL_DIR"
  echo "Removed local plugin directory: $PLUGINS_LOCAL_DIR"
fi

if [ -f "$CONFIG_PATH" ]; then
  if sed --version >/dev/null 2>&1; then
    sed -i -E "/localPlugins:\s*\[[^]]*hyper-xscriptor-themes[^]]*]/d" "$CONFIG_PATH" || true
    sed -i -E "s/,?\s*'hyper-xscriptor-themes'//g" "$CONFIG_PATH" || true
    sed -i -E "/xscriptorTheme:\s*'[^']*'/d" "$CONFIG_PATH" || true
  else
    sed -i '' -E "/localPlugins:\s*\[[^]]*hyper-xscriptor-themes[^]]*]/d" "$CONFIG_PATH" || true
    sed -i '' -E "s/,?\s*'hyper-xscriptor-themes'//g" "$CONFIG_PATH" || true
    sed -i '' -E "/xscriptorTheme:\s*'[^']*'/d" "$CONFIG_PATH" || true
  fi
  echo "Updated Hyper config: $CONFIG_PATH"
else
  echo "Hyper config not found: $CONFIG_PATH"
fi

echo "Hyper themes uninstall completed."
