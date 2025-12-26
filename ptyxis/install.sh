#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$SCRIPT_DIR/themes"
DEST_DIR="$HOME/.local/share/org.gnome.Ptyxis/palettes"

RAW_BASE="https://raw.githubusercontent.com/xscriptordev/terminal/main/ptyxis"
THEMES_FILES="xscriptor-theme.palette xscriptor-theme-light.palette x-retro.palette x-dark-candy.palette x-candy-pop.palette x-sense.palette x-summer-night.palette x-nord.palette x-nord-inverted.palette x-greyscale.palette x-greyscale-inverted.palette x-dark-colors.palette x-persecution.palette x-dark-one.palette"

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
      for pkg in "$@"; do
        case "$pkg" in
          curl|wget|sed)
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

ensure_deps() {
  MISSING=""
  command -v sed >/dev/null 2>&1 || MISSING="$MISSING sed"
  if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
    MISSING="$MISSING curl"
  fi
  if [ -n "$MISSING" ]; then
    install_pkgs $MISSING || true
  fi
}

sed_in_place() {
  EXP="$1"
  FILE="$2"
  if sed --version >/dev/null 2>&1; then
    sed -i -E "$EXP" "$FILE"
  else
    sed -i '' -E "$EXP" "$FILE"
  fi
}

set_primary_palette() {
  NAME="$1"
  [ -d "$DEST_DIR" ] || return 0
  for f in "$DEST_DIR"/*.palette; do
    [ -f "$f" ] && sed_in_place 's/^Primary\s*=\s*true/Primary=false/' "$f"
  done
  FILE="$DEST_DIR/$NAME.palette"
  [ -f "$FILE" ] && sed_in_place 's/^Primary\s*=.*/Primary=true/' "$FILE"
}

append_aliases() {
  RC="$1"
  [ -f "$RC" ] || touch "$RC"
  if sed --version >/dev/null 2>&1; then
    sed -i '/^ptyx() {/,/^}/d' "$RC" || true
    sed -i -E '/^alias ptyx[a-zA-Z0-9]+=/d' "$RC" || true
  else
    sed -i '' '/^ptyx() {/,/^}/d' "$RC" || true
    sed -i '' -E '/^alias ptyx[a-zA-Z0-9]+=/d' "$RC" || true
  fi
  {
    echo 'ptyx() {'
    echo '  name="$1"'
    echo '  dir="$HOME/.local/share/org.gnome.Ptyxis/palettes"'
    echo '  file="$dir/${name}.palette"'
    echo '  if [ ! -f "$file" ]; then'
    echo '    echo "Palette not found: $file"'
    echo '    return 1'
    echo '  fi'
    echo '  if sed --version >/dev/null 2>&1; then'
    echo '    for f in "$dir"/*.palette; do [ -f "$f" ] && sed -i -E "s/^Primary\\s*=\\s*true/Primary=false/" "$f"; done'
    echo '    sed -i -E "s/^Primary\\s*=.*/Primary=true/" "$file"'
    echo '  else'
    echo '    for f in "$dir"/*.palette; do [ -f "$f" ] && sed -i "" -E "s/^Primary\\s*=\\s*true/Primary=false/" "$f"; done'
    echo '    sed -i "" -E "s/^Primary\\s*=.*/Primary=true/" "$file"'
    echo '  fi'
    echo '}'
    echo 'alias ptyxscriptor="ptyx xscriptor-theme"'
    echo 'alias ptyxscriptorlight="ptyx xscriptor-theme-light"'
    echo 'alias ptyxretro="ptyx x-retro"'
    echo 'alias ptyxdarkcandy="ptyx x-dark-candy"'
    echo 'alias ptyxcandypop="ptyx x-candy-pop"'
    echo 'alias ptyxsense="ptyx x-sense"'
    echo 'alias ptyxsummer="ptyx x-summer-night"'
    echo 'alias ptyxnord="ptyx x-nord"'
    echo 'alias ptyxnordinverted="ptyx x-nord-inverted"'
    echo 'alias ptyxgreyscale="ptyx x-greyscale"'
    echo 'alias ptyxgreyscaleinv="ptyx x-greyscale-inverted"'
    echo 'alias ptyxdarkcolors="ptyx x-dark-colors"'
    echo 'alias ptyxpersecution="ptyx x-persecution"'
    echo 'alias ptyxdarkone="ptyx x-dark-one"'
  } >> "$RC"
}

ensure_deps || true
mkdir -p "$DEST_DIR"

USE_REMOTE=0
if [ ! -d "$SRC_DIR" ] || [ -z "$(ls -1 "$SRC_DIR"/*.palette 2>/dev/null)" ]; then
  USE_REMOTE=1
fi

if [ "$USE_REMOTE" -eq 0 ]; then
  for f in "$SRC_DIR"/*.palette; do
    [ -f "$f" ] && cp -f "$f" "$DEST_DIR/$(basename "$f")"
  done
else
  for name in $THEMES_FILES; do
    fetch_file "$RAW_BASE/themes/$name" "$DEST_DIR/$name"
  done
fi

set_primary_palette "xscriptor-theme"

if command -v bash >/dev/null 2>&1; then
  append_aliases "$HOME/.bashrc"
fi
if command -v zsh >/dev/null 2>&1; then
  append_aliases "$HOME/.zshrc"
fi
