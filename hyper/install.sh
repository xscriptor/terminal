#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RAW_BASE="https://raw.githubusercontent.com/xscriptordev/terminal/main/hyper"

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

fetch_cmd() {
  if command -v curl >/dev/null 2>&1; then
    echo "curl"
  elif command -v wget >/dev/null 2>&1; then
    echo "wget"
  else
    echo ""
  fi
}

fetch_file() {
  URL="$1"
  DEST="$2"
  CMD="$(fetch_cmd)"
  [ -z "$CMD" ] && return 1
  if [ "$CMD" = "curl" ]; then
    curl -fsSL -o "$DEST" "$URL"
  else
    wget -qO "$DEST" "$URL"
  fi
}

echo "Installing Xscriptor Hyper themes as a local plugin..."
mkdir -p "$PLUGINS_LOCAL_DIR/themes"

USE_REMOTE=0
[ -f "$SCRIPT_DIR/index.js" ] || USE_REMOTE=1
[ -f "$SCRIPT_DIR/package.json" ] || USE_REMOTE=1
[ -n "$(ls -1 "$SCRIPT_DIR/themes"/*.js 2>/dev/null)" ] || USE_REMOTE=1

if [ "$USE_REMOTE" -eq 0 ]; then
  cp -f "$SCRIPT_DIR/index.js" "$PLUGINS_LOCAL_DIR/index.js"
  cp -f "$SCRIPT_DIR/package.json" "$PLUGINS_LOCAL_DIR/package.json"
  cp -f "$SCRIPT_DIR/themes/"*.js "$PLUGINS_LOCAL_DIR/themes/" 2>/dev/null || true
else
  fetch_file "$RAW_BASE/index.js" "$PLUGINS_LOCAL_DIR/index.js" || true
  fetch_file "$RAW_BASE/package.json" "$PLUGINS_LOCAL_DIR/package.json" || true
  TMP_INDEX="${TMPDIR:-/tmp}/hyper-xscriptor-index-$(date +%s).js"
  cp -f "$PLUGINS_LOCAL_DIR/index.js" "$TMP_INDEX" 2>/dev/null || TMP_INDEX="$PLUGINS_LOCAL_DIR/index.js"
  if [ -f "$TMP_INDEX" ]; then
    grep -E "require\\('\\./themes/.+\\'" "$TMP_INDEX" | sed -E "s/.*themes\\/([^']+).*/\\1/" | while read -r f; do
      [ -n "$f" ] && fetch_file "$RAW_BASE/themes/$f.js" "$PLUGINS_LOCAL_DIR/themes/$f.js" || true
    done
  fi
fi

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
  config: { xscriptorTheme: 'x' },
" "$CONFIG_PATH" || true
    else
      sed -i '' "/module.exports\s*=\s*{/a\\
  localPlugins: ['hyper-xscriptor-themes'],\\
  config: { xscriptorTheme: 'x' },
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
    echo '  base="$name"'
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
    echo "    sed -i -E \"s/(xscriptorTheme:\\s*['\\\"]).*(['\\\"])|\\$/\\1\\\${base}\\2/\" \"\\$CONFIG\" || sed -i -E \"s/(config:\\s*\\{)/\\1 xscriptorTheme: '\\\${base}',/\" \"\\$CONFIG\""
    echo '  else'
    echo "    sed -i '' -E \"s/(xscriptorTheme:\\s*['\\\"]).*(['\\\"])|\\$/\\1\\\${base}\\2/\" \"\\$CONFIG\" || sed -i '' -E \"s/(config:\\s*\\{)/\\1 xscriptorTheme: '\\\${base}',/\" \"\\$CONFIG\""
    echo '  fi'
    echo '  if command -v hyper >/dev/null 2>&1; then'
    echo '    (hyper >/dev/null 2>&1 &)'
    echo '  elif [ "$(uname)" = "Darwin" ]; then'
    echo '    open -a Hyper || true'
    echo '  else'
    echo '    echo "Theme set to ${name}. Restart Hyper to apply."'
    echo '  fi'
    echo '}'
    echo "alias hyperxx=\"hyperx x\""
    echo "alias hyperxmadrid=\"hyperx xmadrid\""
    echo "alias hyperxlahabana=\"hyperx xlahabana\""
    echo "alias hyperxseul=\"hyperx xseul\""
    echo "alias hyperxmiami=\"hyperx xmiami\""
    echo "alias hyperxparis=\"hyperx xparis\""
    echo "alias hyperxtokio=\"hyperx xtokio\""
    echo "alias hyperxoslo=\"hyperx xoslo\""
    echo "alias hyperxhelsinki=\"hyperx xhelsinki\""
    echo "alias hyperxberlin=\"hyperx xberlin\""
    echo "alias hyperxlondon=\"hyperx xlondon\""
    echo "alias hyperxpraga=\"hyperx xpraga\""
    echo "alias hyperxbogota=\"hyperx xbogota\""
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
echo "To switch theme: use 'hyperx <name>' or aliases like 'hyperxx'."
