#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DCONF_DIR="$SCRIPT_DIR/dconf"

UUID_XSCRIPTOR="6e8b5e50-1c2a-4a22-9a10-000000000001"
UUID_XSCRIPTOR_LIGHT="6e8b5e50-1c2a-4a22-9a10-000000000002"
UUID_XRETRO="6e8b5e50-1c2a-4a22-9a10-000000000003"
UUID_XDARKCANDY="6e8b5e50-1c2a-4a22-9a10-000000000004"
UUID_XCANDYPOP="6e8b5e50-1c2a-4a22-9a10-000000000005"
UUID_XSENSE="6e8b5e50-1c2a-4a22-9a10-000000000006"
UUID_XSUMMER="6e8b5e50-1c2a-4a22-9a10-000000000007"
UUID_XNORD="6e8b5e50-1c2a-4a22-9a10-000000000008"
UUID_XNORDINV="6e8b5e50-1c2a-4a22-9a10-000000000009"
UUID_XGREYSCALE="6e8b5e50-1c2a-4a22-9a10-00000000000a"
UUID_XGREYSCALEINV="6e8b5e50-1c2a-4a22-9a10-00000000000b"
UUID_XDARKCOLORS="6e8b5e50-1c2a-4a22-9a10-00000000000c"
UUID_XPERSECUTION="6e8b5e50-1c2a-4a22-9a10-00000000000d"

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
          dconf|glib)
            brew install "$pkg" || true
            ;;
          *)
            brew install "$pkg" || true
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
command -v dconf >/dev/null 2>&1 || MISSING="$MISSING dconf-cli"
command -v gsettings >/dev/null 2>&1 || MISSING="$MISSING glib2"
command -v sed >/dev/null 2>&1 || MISSING="$MISSING sed"
if [ -n "$MISSING" ]; then
  echo "Installing missing packages:$MISSING"
  install_pkgs $MISSING || { echo "Error installing required packages:$MISSING"; exit 1; }
fi

RAW_BASE="https://raw.githubusercontent.com/xscriptordev/terminal/dev/gnome-terminal"
THEMES_DCONF="xscriptor-theme.dconf xscriptor-theme-light.dconf x-retro.dconf x-dark-candy.dconf x-candy-pop.dconf x-sense.dconf x-summer-night.dconf x-nord.dconf x-nord-inverted.dconf x-greyscale.dconf x-greyscale-inverted.dconf x-dark-colors.dconf x-persecution.dconf"

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

load_theme_dconf() {
  FILE="$1"
  if [ -f "$FILE" ]; then
    dconf load /org/gnome/terminal/ < "$FILE"
    return 0
  fi
  return 1
}

ensure_uuid_in_list() {
  UUID="$1"
  CURRENT="$(gsettings get org.gnome.Terminal.ProfilesList list)"
  if echo "$CURRENT" | grep -q "'$UUID'"; then
    NEW="$CURRENT"
  else
    if [ "$CURRENT" = "[]" ]; then
      NEW="['$UUID']"
    else
      NEW="$(echo "$CURRENT" | sed "s/]$/, '$UUID']/")"
    fi
  fi
  gsettings set org.gnome.Terminal.ProfilesList list "$NEW"
}

set_default_profile() {
  UUID="$1"
  gsettings set org.gnome.Terminal.ProfilesList default "'$UUID'"
}

TMPDL="$(mktemp -d)"
USE_REMOTE=0
if [ ! -d "$SRC_DCONF_DIR" ] || [ -z "$(ls -1 "$SRC_DCONF_DIR"/*.dconf 2>/dev/null)" ]; then
  USE_REMOTE=1
fi

COUNT_LOADED=0
if [ "$USE_REMOTE" -eq 0 ]; then
  echo "Using local dconf themes in $SRC_DCONF_DIR"
  for name in $THEMES_DCONF; do
    load_theme_dconf "$SRC_DCONF_DIR/$name" && COUNT_LOADED=$((COUNT_LOADED+1))
  done
else
  echo "Downloading dconf themes from remote repository..."
  for name in $THEMES_DCONF; do
    fetch_file "$RAW_BASE/dconf/$name" "$TMPDL/$name"
    load_theme_dconf "$TMPDL/$name" && COUNT_LOADED=$((COUNT_LOADED+1))
  done
fi
echo "Loaded $COUNT_LOADED GNOME Terminal theme profiles"
rm -rf "$TMPDL"

for UUID in \
  "$UUID_XSCRIPTOR" "$UUID_XSCRIPTOR_LIGHT" "$UUID_XRETRO" "$UUID_XDARKCANDY" "$UUID_XCANDYPOP" \
  "$UUID_XSENSE" "$UUID_XSUMMER" "$UUID_XNORD" "$UUID_XNORDINV" "$UUID_XGREYSCALE" "$UUID_XGREYSCALEINV" \
  "$UUID_XDARKCOLORS" "$UUID_XPERSECUTION"
do
  ensure_uuid_in_list "$UUID"
done
echo "Ensured all theme UUIDs are present in the ProfilesList"

set_default_profile "$UUID_XSCRIPTOR"
echo "Default GNOME Terminal profile set to Xscriptor ($UUID_XSCRIPTOR)"

append_aliases() {
  RC="$1"
  [ -f "$RC" ] || touch "$RC"
  sed -i '/^gtx() {/,/^}/d' "$RC" || true
  sed -i -E '/^alias gtx[a-zA-Z0-9]+=/d' "$RC" || true
  {
    echo 'gtx() {'
    echo '  name="$1"'
    echo '  case "$name" in'
    echo '    xscriptor-theme) uuid="'"$UUID_XSCRIPTOR"'" ;;'
    echo '    xscriptor-theme-light) uuid="'"$UUID_XSCRIPTOR_LIGHT"'" ;;'
    echo '    x-retro) uuid="'"$UUID_XRETRO"'" ;;'
    echo '    x-dark-candy) uuid="'"$UUID_XDARKCANDY"'" ;;'
    echo '    x-candy-pop) uuid="'"$UUID_XCANDYPOP"'" ;;'
    echo '    x-sense) uuid="'"$UUID_XSENSE"'" ;;'
    echo '    x-summer-night) uuid="'"$UUID_XSUMMER"'" ;;'
    echo '    x-nord) uuid="'"$UUID_XNORD"'" ;;'
    echo '    x-nord-inverted) uuid="'"$UUID_XNORDINV"'" ;;'
    echo '    x-greyscale) uuid="'"$UUID_XGREYSCALE"'" ;;'
    echo '    x-greyscale-inverted) uuid="'"$UUID_XGREYSCALEINV"'" ;;'
    echo '    x-dark-colors) uuid="'"$UUID_XDARKCOLORS"'" ;;'
    echo '    x-persecution) uuid="'"$UUID_XPERSECUTION"'" ;;'
    echo '    *) echo "Unknown theme name: $name"; return 1 ;;'
    echo '  esac'
    echo '  gsettings set org.gnome.Terminal.ProfilesList default "'"'\$uuid'"'"'
    echo '}'
    echo 'alias gtxscriptor="gtx xscriptor-theme"'
    echo 'alias gtxscriptorlight="gtx xscriptor-theme-light"'
    echo 'alias gtxsense="gtx x-sense"'
    echo 'alias gtxsummer="gtx x-summer-night"'
    echo 'alias gtxretro="gtx x-retro"'
    echo 'alias gtxdark="gtx x-dark-colors"'
    echo 'alias gtxdarkcandy="gtx x-dark-candy"'
    echo 'alias gtxcandy="gtx x-dark-candy"'
    echo 'alias gtxcandypop="gtx x-candy-pop"'
    echo 'alias gtxnord="gtx x-nord"'
    echo 'alias gtxnordinverted="gtx x-nord-inverted"'
    echo 'alias gtxgreyscale="gtx x-greyscale"'
    echo 'alias gtxgreyscaleinv="gtx x-greyscale-inverted"'
    echo 'alias gtxpersecution="gtx x-persecution"'
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

echo "GNOME Terminal themes installation completed."
