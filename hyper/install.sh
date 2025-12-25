#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

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

echo "Installing Xscriptor Hyper themes as a local plugin..."
mkdir -p "$PLUGINS_LOCAL_DIR/themes"
cp -f "$SCRIPT_DIR/index.js" "$PLUGINS_LOCAL_DIR/index.js"
cp -f "$SCRIPT_DIR/package.json" "$PLUGINS_LOCAL_DIR/package.json"
cp -f "$SCRIPT_DIR/themes/"*.js "$PLUGINS_LOCAL_DIR/themes/" 2>/dev/null || true

if [ ! -f "$CONFIG_PATH" ]; then
  echo "Creating Hyper config at $CONFIG_PATH"
  cat > "$CONFIG_PATH" <<'EOF'
module.exports = {
  config: {},
  plugins: [],
  localPlugins: []
}
EOF
fi

add_local_plugin() {
  if grep -q "hyper-xscriptor-themes" "$CONFIG_PATH"; then
    return 0
  fi
  if grep -q "localPlugins" "$CONFIG_PATH"; then
    if sed --version >/dev/null 2>&1; then
      sed -i -E "s/localPlugins:\s*\[([^]]*)\]/localPlugins: [\1, 'hyper-xscriptor-themes']/" "$CONFIG_PATH" || true
    else
      sed -i '' -E "s/localPlugins:\s*\[([^]]*)\]/localPlugins: [\1, 'hyper-xscriptor-themes']/" "$CONFIG_PATH" || true
    fi
  fi
  if ! grep -q "hyper-xscriptor-themes" "$CONFIG_PATH"; then
    if sed --version >/dev/null 2>&1; then
      sed -i "/module.exports\s*=\s*{/a\\
  localPlugins: ['hyper-xscriptor-themes'],\\
  config: { xscriptorTheme: 'xscriptor-theme' },
" "$CONFIG_PATH" || true
    else
      sed -i '' "/module.exports\s*=\s*{/a\\
  localPlugins: ['hyper-xscriptor-themes'],\\
  config: { xscriptorTheme: 'xscriptor-theme' },
" "$CONFIG_PATH" || true
    fi
  fi
}

add_local_plugin

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

append_aliases() {
  RC="$1"
  [ -f "$RC" ] || touch "$RC"
  remove_aliases "$RC"
  {
    echo 'hyperx() {'
    echo '  name="$1"'
    echo '  if [ -d "$HOME/Library/Application Support/Hyper" ]; then'
    echo '    CONFIG="$HOME/Library/Application Support/Hyper/.hyper.js"'
    echo '  elif [ -n "$APPDATA" ] && [ -d "$APPDATA/Hyper" ]; then'
    echo '    CONFIG="$APPDATA/Hyper/.hyper.js"'
    echo '  elif [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/Hyper" ]; then'
    echo '    CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/Hyper/.hyper.js"'
    echo '  else'
    echo '    CONFIG="$HOME/.hyper.js"'
    echo '  fi'
    echo '  [ -f "$CONFIG" ] || { echo "Hyper config not found: $CONFIG"; return 1; }'
    echo '  if sed --version >/dev/null 2>&1; then'
    echo "    sed -i -E \"s/(xscriptorTheme:\\s*['\\\"]).*(['\\\"])|\\$/\\1\\\${name}\\2/\" \"\\$CONFIG\" || sed -i -E \"s/(config:\\s*\\{)/\\1 xscriptorTheme: '\\\${name}',/\" \"\\$CONFIG\""
    echo '  else'
    echo "    sed -i '' -E \"s/(xscriptorTheme:\\s*['\\\"]).*(['\\\"])|\\$/\\1\\\${name}\\2/\" \"\\$CONFIG\" || sed -i '' -E \"s/(config:\\s*\\{)/\\1 xscriptorTheme: '\\\${name}',/\" \"\\$CONFIG\""
    echo '  fi'
    echo '  if command -v hyper >/dev/null 2>&1; then'
    echo '    (hyper >/dev/null 2>&1 &)'
    echo '  elif [ "$(uname)" = "Darwin" ]; then'
    echo '    open -a Hyper || true'
    echo '  else'
    echo '    echo "Theme set to ${name}. Restart Hyper to apply."'
    echo '  fi'
    echo '}'
    echo "alias hyperxscriptor=\"hyperx xscriptor-theme\""
    echo "alias hyperxscriptorlight=\"hyperx xscriptor-theme-light\""
    echo "alias hyperxretro=\"hyperx x-retro\""
    echo "alias hyperxdarkone=\"hyperx x-dark-one\""
    echo "alias hyperxcandypop=\"hyperx x-candy-pop\""
    echo "alias hyperxsense=\"hyperx x-sense\""
    echo "alias hyperxsummer=\"hyperx x-summer-night\""
    echo "alias hyperxnord=\"hyperx x-nord\""
    echo "alias hyperxnordinverted=\"hyperx x-nord-inverted\""
    echo "alias hyperxgreyscale=\"hyperx x-greyscale\""
    echo "alias hyperxgreyscaleinv=\"hyperx x-greyscale-inverted\""
    echo "alias hyperxdark=\"hyperx x-dark-colors\""
    echo "alias hyperxpersecution=\"hyperx x-persecution\""
  } >> "$RC"
}

if command -v bash >/dev/null 2>&1; then
  append_aliases "$HOME/.bashrc"
  echo "Aliases added to ~/.bashrc"
fi
if command -v zsh >/dev/null 2>&1; then
  append_aliases "$HOME/.zshrc"
  echo "Aliases added to ~/.zshrc"
fi

echo "Done. Restart Hyper to load the plugin."
echo "To switch theme, use aliases like 'hyperxscriptor' or set config.xscriptorTheme in your ~/.hyper.js."
