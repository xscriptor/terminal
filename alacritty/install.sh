#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_THEMES_DIR="$SCRIPT_DIR/themes"
TARGET_CONFIG_DIR="$HOME/.config/alacritty"
TARGET_THEMES_DIR="$TARGET_CONFIG_DIR/themes"
MAIN="$TARGET_CONFIG_DIR/alacritty.toml"

REQ=1
for cmd in alacritty sed; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "$cmd not found"; REQ=0; }
done
if [ "$REQ" -ne 1 ]; then
  exit 1
fi
if command -v fc-list >/dev/null 2>&1; then
  fc-list : family | grep -i 'anonymice.*nerd' >/dev/null 2>&1 || echo "AnonymicePro Nerd Font not found"
else
  echo "fc-list not found"
fi

mkdir -p "$TARGET_CONFIG_DIR"
mkdir -p "$TARGET_THEMES_DIR"

for f in "$SRC_THEMES_DIR"/*.toml; do
  [ -f "$f" ] && cp -f "$f" "$TARGET_THEMES_DIR/$(basename "$f")"
done

if [ -f "$MAIN" ]; then
  TS="$(date +%s)"
  cp "$MAIN" "$MAIN.bak.$TS"
fi
cp -f "$SCRIPT_DIR/alacritty.toml" "$MAIN"

sed -i -E 's#^import = \[.*\]#import = ["themes/xscriptor-theme.toml"]#' "$MAIN" || true

append_aliases() {
  RC="$1"
  [ -f "$RC" ] || touch "$RC"
  sed -i '/^alax() {/,/^}/d' "$RC" || true
  sed -i -E '/^alias alax[a-zA-Z0-9]+=/d' "$RC" || true
  {
    echo 'alax() {'
    echo '  name="$1"'
    echo '  sed -i -E "s#^import = \\[.*\\]#import = [\\\"themes/${name}.toml\\\"]#" "$HOME/.config/alacritty/alacritty.toml"'
    echo '}'
    echo 'alias alaxscriptor="alax xscriptor-theme"'
    echo 'alias alaxscriptorlight="alax xscriptor-theme-light"'
    echo 'alias alaxsense="alax x-sense"'
    echo 'alias alaxsummer="alax x-summer-night"'
    echo 'alias alaxretro="alax x-retro"'
    echo 'alias alaxdark="alax x-dark-colors"'
    echo 'alias alaxdarkcandy="alax x-dark-candy"'
    echo 'alias alaxcandy="alax x-dark-candy"'
    echo 'alias alaxcandypop="alax x-candy-pop"'
    echo 'alias alaxnord="alax x-nord"'
    echo 'alias alaxnordinverted="alax x-nord-inverted"'
    echo 'alias alaxgreyscale="alax x-greyscale"'
    echo 'alias alaxgreyscaleinv="alax x-greyscale-inverted"'
    echo 'alias alaxpersecution="alax x-persecution"'
  } >> "$RC"
}

if command -v bash >/dev/null 2>&1; then
  append_aliases "$HOME/.bashrc"
fi
if command -v zsh >/dev/null 2>&1; then
  append_aliases "$HOME/.zshrc"
fi
