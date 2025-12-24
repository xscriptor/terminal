#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_THEMES_DIR="$SCRIPT_DIR/themes"
TARGET_CONFIG_DIR="$HOME/.config/alacritty"
TARGET_THEMES_DIR="$TARGET_CONFIG_DIR/themes"
MAIN="$TARGET_CONFIG_DIR/alacritty.toml"

detect_pm() {
  for pm in apt-get dnf pacman zypper yum apk brew; do
    command -v "$pm" >/dev/null 2>&1 && { echo "$pm"; return 0; }
  done
  return 1
}

sudo_cmd() {
  if [ "$(id -u)" -eq 0 ]; then
    echo ""
  elif command -v sudo >/dev/null 2>&1; then
    echo "sudo"
  elif command -v doas >/dev/null 2>&1; then
    echo "doas"
  else
    echo ""
  fi
}

install_pkgs() {
  PM="$(detect_pm)" || { echo "No supported package manager found"; return 1; }
  SUDO="$(sudo_cmd)"
  case "$PM" in
    brew)
      brew update
      for pkg in "$@"; do
        case "$pkg" in
          alacritty)
            brew install --cask alacritty
            ;;
          fontconfig|curl|wget|sed)
            brew install "$pkg"
            ;;
          *)
            brew install "$pkg"
            ;;
        esac
      done
      ;;
    apt-get)
      $SUDO apt-get update
      $SUDO apt-get install -y "$@"
      ;;
    dnf)
      $SUDO dnf install -y "$@"
      ;;
    pacman)
      $SUDO pacman -S --needed --noconfirm "$@"
      ;;
    zypper)
      $SUDO zypper refresh
      $SUDO zypper install -y "$@"
      ;;
    yum)
      $SUDO yum install -y "$@"
      ;;
    apk)
      $SUDO apk update
      $SUDO apk add "$@"
      ;;
    *)
      return 1
      ;;
  esac
}

MISSING=""
command -v alacritty >/dev/null 2>&1 || MISSING="$MISSING alacritty"
command -v sed >/dev/null 2>&1 || MISSING="$MISSING sed"
command -v fc-list >/dev/null 2>&1 || MISSING="$MISSING fontconfig"
if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
  MISSING="$MISSING curl"
fi

if [ -n "$MISSING" ]; then
  install_pkgs $MISSING || { echo "Failed to install required packages: $MISSING"; exit 1; }
fi

if command -v fc-list >/dev/null 2>&1; then
  fc-list : family | grep -i 'anonymice.*nerd' >/dev/null 2>&1 || echo "AnonymicePro Nerd Font not found"
fi

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

RAW_BASE="https://raw.githubusercontent.com/xscriptordev/terminal/dev/alacritty"
THEMES_FILES="xscriptor-theme.toml xscriptor-theme-light.toml x-retro.toml x-dark-candy.toml x-candy-pop.toml x-sense.toml x-summer-night.toml x-nord.toml x-nord-inverted.toml x-greyscale.toml x-greyscale-inverted.toml x-dark-colors.toml x-persecution.toml"

mkdir -p "$TARGET_CONFIG_DIR"
mkdir -p "$TARGET_THEMES_DIR"

USE_REMOTE=0
if [ ! -d "$SRC_THEMES_DIR" ] || [ -z "$(ls -1 "$SRC_THEMES_DIR"/*.toml 2>/dev/null)" ] || [ ! -f "$SCRIPT_DIR/alacritty.toml" ]; then
  USE_REMOTE=1
fi

if [ "$USE_REMOTE" -eq 0 ]; then
  for f in "$SRC_THEMES_DIR"/*.toml; do
    [ -f "$f" ] && cp -f "$f" "$TARGET_THEMES_DIR/$(basename "$f")"
  done
else
  for name in $THEMES_FILES; do
    fetch_file "$RAW_BASE/themes/$name" "$TARGET_THEMES_DIR/$name"
  done
fi

if [ -f "$MAIN" ]; then
  TS="$(date +%s)"
  cp "$MAIN" "$MAIN.bak.$TS"
fi
if [ "$USE_REMOTE" -eq 0 ]; then
  cp -f "$SCRIPT_DIR/alacritty.toml" "$MAIN"
else
  fetch_file "$RAW_BASE/alacritty.toml" "$MAIN"
fi

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
