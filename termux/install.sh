#!/usr/bin/env sh
set -e
TARGET_DIR="$HOME/.termux"
THEMES_DIR="$TARGET_DIR/themes"
COLORS="$TARGET_DIR/colors.properties"
RAW_BASE="https://raw.githubusercontent.com/xscriptordev/terminal/main/termux/themes"
mkdir -p "$THEMES_DIR"
fetch_cmd() {
  if command -v curl >/dev/null 2>&1; then
    echo "curl"
  elif command -v wget >/dev/null 2>&1; then
    echo "wget"
  else
    echo ""
  fi
}
ensure_fetch() {
  CMD="$(fetch_cmd)"
  if [ -z "$CMD" ] && command -v pkg >/dev/null 2>&1; then
    pkg update -y >/dev/null 2>&1 || true
    pkg install -y curl >/dev/null 2>&1 || pkg install -y wget >/dev/null 2>&1 || true
  fi
}
fetch_file() {
  URL="$1"
  DEST="$2"
  CMD="$(fetch_cmd)"
  [ -z "$CMD" ] && exit 1
  if [ "$CMD" = "curl" ]; then
    curl -fsSL -o "$DEST" "$URL"
  else
    wget -qO "$DEST" "$URL"
  fi
}
ensure_fetch
NAMES="xscriptor-theme xscriptor-theme-light x-retro x-dark-one x-candy-pop x-sense x-summer-night x-nord x-nord-inverted x-greyscale x-greyscale-inverted x-dark-colors x-persecution"
for name in $NAMES; do
  fetch_file "$RAW_BASE/$name.properties" "$THEMES_DIR/$name.properties"
done
if [ -f "$THEMES_DIR/xscriptor-theme.properties" ]; then
  cp -f "$THEMES_DIR/xscriptor-theme.properties" "$COLORS"
fi
append_aliases() {
  RC="$1"
  [ -f "$RC" ] || touch "$RC"
  sed -i '/^tmx() {/,/^}/d' "$RC" || true
  sed -i -E '/^alias tmx[a-zA-Z0-9]+=/d' "$RC" || true
  {
    echo 'tmx() {'
    echo '  name="$1"'
    echo '  [ -z "$name" ] && echo "usage: tmx <theme-name>" && return 1'
    echo '  src="$HOME/.termux/themes/${name}.properties"'
    echo '  [ ! -f "$src" ] && echo "theme not found: $name" && return 1'
    echo '  cp -f "$src" "$HOME/.termux/colors.properties"'
    echo '  termux-reload-settings >/dev/null 2>&1 || true'
    echo '}'
    echo 'alias tmxscriptor="tmx xscriptor-theme"'
    echo 'alias tmxscriptorlight="tmx xscriptor-theme-light"'
    echo 'alias tmxretro="tmx x-retro"'
    echo 'alias tmxdarkone="tmx x-dark-one"'
    echo 'alias tmxcandypop="tmx x-candy-pop"'
    echo 'alias tmxsense="tmx x-sense"'
    echo 'alias tmxsummer="tmx x-summer-night"'
    echo 'alias tmxnord="tmx x-nord"'
    echo 'alias tmxnordinverted="tmx x-nord-inverted"'
    echo 'alias tmxgreyscale="tmx x-greyscale"'
    echo 'alias tmxgreyscaleinv="tmx x-greyscale-inverted"'
    echo 'alias tmxdarkcolors="tmx x-dark-colors"'
    echo 'alias tmxpersecution="tmx x-persecution"'
  } >> "$RC"
}
if command -v bash >/dev/null 2>&1; then
  append_aliases "$HOME/.bashrc"
fi
if command -v zsh >/dev/null 2>&1; then
  append_aliases "$HOME/.zshrc"
fi
echo "Themes installed in $THEMES_DIR"
echo "Default theme applied: xscriptor-theme"
echo "Reload settings with: termux-reload-settings"
echo 'Use "tmx <theme-name>" or aliases like "tmxscriptor" to switch themes'
