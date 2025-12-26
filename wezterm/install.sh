#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_THEMES_DIR="$SCRIPT_DIR/themes"
TARGET_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/wezterm"
TARGET_THEMES_DIR="$TARGET_CONFIG_DIR/colors"
RAW_BASE="https://raw.githubusercontent.com/xscriptordev/terminal/main/wezterm/themes"
THEMES_FILES="xscriptor-theme.toml xscriptor-theme-light.toml x-retro.toml x-dark-candy.toml x-candy-pop.toml x-sense.toml x-summer-night.toml x-nord.toml x-nord-inverted.toml x-greyscale.toml x-greyscale-inverted.toml x-dark-colors.toml x-dark-one.toml x-persecution.toml"

detect_pm() {
  for pm in brew apt-get dnf pacman zypper yum apk nix-env; do
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
  [ -z "$CMD" ] && { echo "curl or wget is required"; exit 1; }
  if [ "$CMD" = "curl" ]; then
    curl -fsSL -o "$DEST" "$URL"
  else
    wget -qO "$DEST" "$URL"
  fi
}

ensure_flatpak_wezterm() {
  SUDO="$(sudo_cmd)"
  if ! command -v flatpak >/dev/null 2>&1; then
    PM="$(detect_pm)" || PM=""
    case "$PM" in
      apt-get) $SUDO apt-get update && $SUDO apt-get install -y flatpak ;;
      dnf) $SUDO dnf install -y flatpak ;;
      pacman) $SUDO pacman -S --needed --noconfirm flatpak ;;
      zypper) $SUDO zypper refresh && $SUDO zypper install -y flatpak ;;
      yum) $SUDO yum install -y flatpak ;;
      apk) $SUDO apk update && $SUDO apk add flatpak || true ;;
      *) ;;
    esac
  fi
  if command -v flatpak >/dev/null 2>&1; then
    $SUDO flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo >/dev/null 2>&1 || true
    $SUDO flatpak install -y flathub org.wezfurlong.wezterm || return 1
    return 0
  fi
  return 1
}

ensure_wezterm_installed() {
  if command -v wezterm >/dev/null 2>&1; then
    echo "WezTerm already installed: $(wezterm --version 2>/dev/null || echo 'version unknown')"
    return 0
  fi
  echo "WezTerm not found; attempting installation..."
  PM="$(detect_pm)" || PM=""
  SUDO="$(sudo_cmd)"
  case "$PM" in
    brew)
      brew update
      brew install wezterm || true
      ;;
    apt-get)
      $SUDO apt-get update
      $SUDO apt-get install -y wezterm || ensure_flatpak_wezterm || true
      ;;
    dnf)
      $SUDO dnf install -y wezterm || ensure_flatpak_wezterm || true
      ;;
    pacman)
      $SUDO pacman -S --needed --noconfirm wezterm || ensure_flatpak_wezterm || true
      ;;
    zypper)
      $SUDO zypper refresh
      $SUDO zypper install -y wezterm || ensure_flatpak_wezterm || true
      ;;
    yum)
      $SUDO yum install -y wezterm || ensure_flatpak_wezterm || true
      ;;
    apk)
      $SUDO apk update
      $SUDO apk add wezterm || true
      ;;
    nix-env)
      nix-env -iA nixpkgs.wezterm || true
      ;;
    *)
      ensure_flatpak_wezterm || true
      ;;
  esac
  if command -v wezterm >/dev/null 2>&1; then
    echo "WezTerm installation completed."
    return 0
  fi
  if command -v flatpak >/dev/null 2>&1 && flatpak info org.wezfurlong.wezterm >/dev/null 2>&1; then
    echo "WezTerm (Flatpak) installed."
    return 0
  fi
  echo "Automatic installation failed. Please install WezTerm manually: https://wezfurlong.org/wezterm/"
  return 1
}

echo "Preparing WezTerm themes installation..."
ensure_wezterm_installed || true

mkdir -p "$TARGET_THEMES_DIR"

USE_REMOTE=0
if [ ! -d "$SRC_THEMES_DIR" ] || [ -z "$(ls -1 "$SRC_THEMES_DIR"/*.toml 2>/dev/null)" ]; then
  USE_REMOTE=1
fi

if [ "$USE_REMOTE" -eq 0 ]; then
  echo "Using local themes in $SRC_THEMES_DIR"
  for f in "$SRC_THEMES_DIR"/*.toml; do
    [ -f "$f" ] && cp -f "$f" "$TARGET_THEMES_DIR/$(basename "$f")"
  done
else
  echo "Downloading themes from remote repository"
  for name in $THEMES_FILES; do
    fetch_file "$RAW_BASE/$name" "$TARGET_THEMES_DIR/$name" || true
  done
fi

append_aliases() {
  RC="$1"
  [ -f "$RC" ] || touch "$RC"
  OS="$(uname -s)"
  if [ "$OS" = "Darwin" ]; then
    sed -i '' '/^weztheme() {/,/^}/d' "$RC" || true
    sed -i '' -E '/^alias wez[a-zA-Z0-9]+=/d' "$RC" || true
  else
    sed -i '/^weztheme() {/,/^}/d' "$RC" || true
    sed -i -E '/^alias wez[a-zA-Z0-9]+=/d' "$RC" || true
  fi
  {
    echo 'weztheme() {'
    echo '  name="$1"'
    echo '  [ -z "$name" ] && echo "usage: weztheme <theme-name>" && return 1'
    echo '  if command -v wezterm >/dev/null 2>&1; then'
    echo '    wezterm cli set-user-var theme "$name"'
    echo '  elif command -v flatpak >/dev/null 2>&1 && flatpak info org.wezfurlong.wezterm >/dev/null 2>&1; then'
    echo '    flatpak run org.wezfurlong.wezterm cli set-user-var theme "$name"'
    echo '  else'
    echo '    echo "WezTerm CLI not found; please install WezTerm."'
    echo '    return 1'
    echo '  fi'
    echo '}'
    echo 'alias wezxscriptor="weztheme xscriptor-theme"'
    echo 'alias wezxscriptorlight="weztheme xscriptor-theme-light"'
    echo 'alias wezretro="weztheme x-retro"'
    echo 'alias wezdarkcandy="weztheme x-dark-candy"'
    echo 'alias wezcandypop="weztheme x-candy-pop"'
    echo 'alias wezsense="weztheme x-sense"'
    echo 'alias wezsummer="weztheme x-summer-night"'
    echo 'alias wezxnord="weztheme x-nord"'
    echo 'alias wezxnordinverted="weztheme x-nord-inverted"'
    echo 'alias wezgreyscale="weztheme x-greyscale"'
    echo 'alias wezgreyscaleinv="weztheme x-greyscale-inverted"'
    echo 'alias wezdarkcolors="weztheme x-dark-colors"'
    echo 'alias wezdarkone="weztheme x-dark-one"'
    echo 'alias wezpersecution="weztheme x-persecution"'
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

COUNT_T="$(ls -1 "$TARGET_THEMES_DIR" 2>/dev/null | wc -l | tr -d ' ')"
echo "Themes installed in: $TARGET_THEMES_DIR ($COUNT_T files)"
echo "To switch theme: use 'weztheme <name>' or aliases like 'wezxscriptor', 'wezxnord'"
