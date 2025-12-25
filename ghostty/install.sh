#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_THEMES_DIR="$SCRIPT_DIR/themes"
TARGET_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty"
TARGET_THEMES_DIR="$TARGET_CONFIG_DIR/themes"
MAIN="$TARGET_CONFIG_DIR/config"
MAC_CONF="$HOME/Library/Application Support/com.mitchellh.ghostty/config"

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
  echo "Using package manager: $PM"
  case "$PM" in
    brew)
      brew update
      for pkg in "$@"; do
        case "$pkg" in
          ghostty)
            brew install --cask ghostty
            ;;
          fontconfig|curl|wget|sed|unzip)
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

ensure_unzip() {
  command -v unzip >/dev/null 2>&1 && { echo "unzip is already installed"; return 0; }
  PM="$(detect_pm)" || { echo "No supported package manager found to install unzip"; return 1; }
  SUDO="$(sudo_cmd)"
  echo "Installing unzip with $PM..."
  case "$PM" in
    brew)
      brew install unzip || true
      ;;
    apt-get)
      $SUDO apt-get update
      $SUDO apt-get install -y unzip || true
      ;;
    dnf)
      $SUDO dnf install -y unzip || true
      ;;
    pacman)
      $SUDO pacman -S --needed --noconfirm unzip || true
      ;;
    zypper)
      $SUDO zypper refresh
      $SUDO zypper install -y unzip || true
      ;;
    yum)
      $SUDO yum install -y unzip || true
      ;;
    apk)
      $SUDO apk update
      $SUDO apk add unzip || true
      ;;
    *)
      echo "Could not install unzip automatically"
      ;;
  esac
}

ensure_unzip || true

MISSING=""
command -v ghostty >/dev/null 2>&1 || MISSING="$MISSING ghostty"
command -v sed >/dev/null 2>&1 || MISSING="$MISSING sed"
command -v fc-list >/dev/null 2>&1 || MISSING="$MISSING fontconfig"
if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
  MISSING="$MISSING curl"
fi
command -v unzip >/dev/null 2>&1 || MISSING="$MISSING unzip"

if [ -n "$MISSING" ]; then
  echo "Installing missing packages:$MISSING"
  install_pkgs $MISSING || { echo "Error installing required packages:$MISSING"; exit 1; }
fi

font_installed() {
  command -v fc-list >/dev/null 2>&1 || return 1
  fc-list : family | grep -Ei '\bhack\b.*nerd' >/dev/null 2>&1
}

install_font_macos() {
  echo "Installing Hack Nerd Font on macOS..."
  brew tap homebrew/cask-fonts >/dev/null 2>&1 || true
  brew install --cask font-hack-nerd-font
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

install_font_linux() {
  DEST="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/NerdFonts/Hack"
  mkdir -p "$DEST"
  TMPDIR="$(mktemp -d)"
  ZIP1="$TMPDIR/Hack.zip"
  echo "Downloading Nerd Font to: $DEST"
  fetch_file "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip" "$ZIP1" || true
  if [ -s "$ZIP1" ]; then
    if unzip -tq "$ZIP1" >/dev/null 2>&1; then
      echo "Extracting Hack.zip..."
      set +e
      unzip -o "$ZIP1" -d "$DEST" >/dev/null 2>&1
      USTATUS=$?
      set -e
      if [ "$USTATUS" -ne 0 ]; then
        echo "Error extracting Hack.zip, continuing without installing the font"
      else
        echo "Extraction completed"
      fi
    else
      echo "Invalid Hack.zip (possible HTML response/rate limit). Skipping extraction."
    fi
  else
    echo "Hack.zip not downloaded (empty file). Skipping extraction."
  fi
  COUNT="$(ls -1 "$DEST" 2>/dev/null | wc -l | tr -d ' ')"
  echo "Installed font files: $COUNT in $DEST"
  echo "Updating font cache..."
  fc-cache -f "$DEST" >/dev/null 2>&1 || true
  echo "Font cache updated"
  rm -rf "$TMPDIR"
}

echo "Checking Hack Nerd Font..."
if font_installed; then
  echo "Font already installed and detected by fontconfig"
else
  OS="$(uname -s)"
  echo "Font not detected, installing on $OS..."
  case "$OS" in
    Darwin)
      install_font_macos
      ;;
    *)
      install_font_linux
      ;;
  esac
  if font_installed; then
    echo "Font installed successfully"
  else
    echo "Warning: font not detected after installation. Check $HOME/.local/share/fonts or the system font manager."
  fi
fi

RAW_BASE="https://raw.githubusercontent.com/xscriptordev/terminal/main/ghostty"
THEMES_FILES="xscriptor-theme.ini xscriptor-theme-light.ini x-retro.ini x-dark-candy.ini x-candy-pop.ini x-sense.ini x-summer-night.ini x-nord.ini x-nord-inverted.ini x-greyscale.ini x-greyscale-inverted.ini x-dark-colors.ini x-persecution.ini"

mkdir -p "$TARGET_CONFIG_DIR"
mkdir -p "$TARGET_THEMES_DIR"

USE_REMOTE=0
if [ ! -d "$SRC_THEMES_DIR" ] || [ -z "$(ls -1 "$SRC_THEMES_DIR"/*.ini 2>/dev/null)" ] || [ ! -f "$SCRIPT_DIR/config" ]; then
  USE_REMOTE=1
fi

if [ "$USE_REMOTE" -eq 0 ]; then
  echo "Using local themes in $SRC_THEMES_DIR"
  for f in "$SRC_THEMES_DIR"/*.ini; do
    [ -f "$f" ] && cp -f "$f" "$TARGET_THEMES_DIR/$(basename "$f")"
  done
  COUNT_T="$(ls -1 "$TARGET_THEMES_DIR" 2>/dev/null | wc -l | tr -d ' ')"
  echo "Themes installed: $COUNT_T in $TARGET_THEMES_DIR"
else
  echo "Downloading themes from remote repository..."
  for name in $THEMES_FILES; do
    fetch_file "$RAW_BASE/themes/$name" "$TARGET_THEMES_DIR/$name"
  done
  COUNT_T="$(ls -1 "$TARGET_THEMES_DIR" 2>/dev/null | wc -l | tr -d ' ')"
  echo "Themes installed (remote): $COUNT_T in $TARGET_THEMES_DIR"
fi

if [ -f "$MAIN" ]; then
  TS="$(date +%s)"
  cp "$MAIN" "$MAIN.bak.$TS"
  echo "Backup created: $MAIN.bak.$TS"
fi
if [ "$USE_REMOTE" -eq 0 ]; then
  cp -f "$SCRIPT_DIR/config" "$MAIN"
else
  fetch_file "$RAW_BASE/config" "$MAIN"
fi
echo "Configuration file written: $MAIN"

if [ "$(uname -s)" = "Darwin" ]; then
  mkdir -p "$(dirname "$MAC_CONF")"
  cp -f "$MAIN" "$MAC_CONF"
  echo "Configuration file written (macOS App Support): $MAC_CONF"
fi

sed -i -E 's#^theme[[:space:]]*=.*#theme = xscriptor-theme.ini#' "$MAIN" || true
grep -q '^theme[[:space:]]*=' "$MAIN" || {
  echo "theme = xscriptor-theme.ini" >> "$MAIN"
}
echo "Default theme set: xscriptor-theme.ini"

append_aliases() {
  RC="$1"
  [ -f "$RC" ] || touch "$RC"
  sed -i '/^ghx() {/,/^}/d' "$RC" || true
  sed -i -E '/^alias ghx[a-zA-Z0-9]+=/d' "$RC" || true
  {
    echo 'ghx() {'
    echo '  name="$1"'
    echo '  file="$HOME/.config/ghostty/config"'
    echo '  sed -i -E "s#^theme[[:space:]]*=.*#theme = ${name}.ini#" "$file"'
    echo '  grep -q "^theme[[:space:]]*=" "$file" || echo "theme = ${name}.ini" >> "$file"'
    echo '}'
    echo 'alias ghxscriptor="ghx xscriptor-theme"'
    echo 'alias ghxscriptorlight="ghx xscriptor-theme-light"'
    echo 'alias ghxsense="ghx x-sense"'
    echo 'alias ghxsummer="ghx x-summer-night"'
    echo 'alias ghxretro="ghx x-retro"'
    echo 'alias ghxdark="ghx x-dark-colors"'
    echo 'alias ghxdarkcandy="ghx x-dark-candy"'
    echo 'alias ghxcandy="ghx x-dark-candy"'
    echo 'alias ghxcandypop="ghx x-candy-pop"'
    echo 'alias ghxnord="ghx x-nord"'
    echo 'alias ghxnordinverted="ghx x-nord-inverted"'
    echo 'alias ghxgreyscale="ghx x-greyscale"'
    echo 'alias ghxgreyscaleinv="ghx x-greyscale-inverted"'
    echo 'alias ghxpersecution="ghx x-persecution"'
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
echo "Ghostty installation completed."
