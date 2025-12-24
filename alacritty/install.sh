#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_THEMES_DIR="$SCRIPT_DIR/themes"
TARGET_CONFIG_DIR="$HOME/.config/alacritty"
TARGET_THEMES_DIR="$TARGET_CONFIG_DIR/themes"
MAIN="$TARGET_CONFIG_DIR/alacritty.toml"

mkdir -p "$TARGET_THEMES_DIR"

for f in "$SRC_THEMES_DIR"/*.toml; do
  [ -f "$f" ] && cp "$f" "$TARGET_THEMES_DIR/$(basename "$f")"
done

if [ -f "$MAIN" ]; then
  TS="$(date +%s)"
  cp "$MAIN" "$MAIN.bak.$TS"
fi
cp "$SCRIPT_DIR/alacritty.toml" "$MAIN"

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

append_aliases "$HOME/.bashrc"
append_aliases "$HOME/.zshrc"
