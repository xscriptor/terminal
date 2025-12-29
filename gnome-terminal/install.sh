#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DCONF_DIR="$SCRIPT_DIR/dconf"

UUID_X="6e8b5e50-1c2a-4a22-9a10-000000000001"
UUID_XMADRID="6e8b5e50-1c2a-4a22-9a10-000000000002"
UUID_XLAHABANA="6e8b5e50-1c2a-4a22-9a10-000000000003"
UUID_XSEUL="6e8b5e50-1c2a-4a22-9a10-000000000004"
UUID_XMIAMI="6e8b5e50-1c2a-4a22-9a10-000000000005"
UUID_XPARIS="6e8b5e50-1c2a-4a22-9a10-000000000006"
UUID_XTOKIO="6e8b5e50-1c2a-4a22-9a10-000000000007"
UUID_XOSLO="6e8b5e50-1c2a-4a22-9a10-000000000008"
UUID_XHELSINKI="6e8b5e50-1c2a-4a22-9a10-000000000009"
UUID_XBERLIN="6e8b5e50-1c2a-4a22-9a10-00000000000a"
UUID_XLONDON="6e8b5e50-1c2a-4a22-9a10-00000000000b"
UUID_XPRAGA="6e8b5e50-1c2a-4a22-9a10-00000000000c"
UUID_XBOGOTA="6e8b5e50-1c2a-4a22-9a10-00000000000d"

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
CITY_NAMES="x xmadrid xlahabana xseul xmiami xparis xtokio xoslo xhelsinki xberlin xlondon xpraga xbogota"

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
  for city in $CITY_NAMES; do
    file="$SRC_DCONF_DIR/${city}.dconf"
    if [ -f "$file" ]; then
      load_theme_dconf "$file" && COUNT_LOADED=$((COUNT_LOADED+1))
    else
      echo "Theme not found locally: ${city}.dconf"
    fi
  done
else
  echo "Downloading dconf themes from remote repository..."
  for city in $CITY_NAMES; do
    target="$TMPDL/${city}.dconf"
    if ! fetch_file "$RAW_BASE/dconf/${city}.dconf" "$target"; then
      echo "Theme not available remotely: ${city}.dconf"
      continue
    fi
    load_theme_dconf "$target" && COUNT_LOADED=$((COUNT_LOADED+1))
  done
fi
echo "Loaded $COUNT_LOADED GNOME Terminal theme profiles"
rm -rf "$TMPDL"

for UUID in \
  "$UUID_X" "$UUID_XMADRID" "$UUID_XLAHABANA" "$UUID_XSEUL" "$UUID_XMIAMI" \
  "$UUID_XPARIS" "$UUID_XTOKIO" "$UUID_XOSLO" "$UUID_XHELSINKI" "$UUID_XBERLIN" "$UUID_XLONDON" \
  "$UUID_XPRAGA" "$UUID_XBOGOTA"
do
  ensure_uuid_in_list "$UUID"
done
echo "Ensured all theme UUIDs are present in the ProfilesList"

set_default_profile "$UUID_X"
echo "Default GNOME Terminal profile set to x ($UUID_X)"

append_aliases() {
  RC="$1"
  [ -f "$RC" ] || touch "$RC"
  sed -i '/^gtx() {/,/^}/d' "$RC" || true
  sed -i -E '/^alias gtx[a-zA-Z0-9]+=/d' "$RC" || true
  {
    echo 'gtx() {'
    echo '  name="$1"'
    echo '  case "$name" in'
    echo '    x) uuid="'"$UUID_X"'" ;;'
    echo '    xmadrid) uuid="'"$UUID_XMADRID"'" ;;'
    echo '    xlahabana) uuid="'"$UUID_XLAHABANA"'" ;;'
    echo '    xseul) uuid="'"$UUID_XSEUL"'" ;;'
    echo '    xmiami) uuid="'"$UUID_XMIAMI"'" ;;'
    echo '    xparis) uuid="'"$UUID_XPARIS"'" ;;'
    echo '    xtokio) uuid="'"$UUID_XTOKIO"'" ;;'
    echo '    xoslo) uuid="'"$UUID_XOSLO"'" ;;'
    echo '    xhelsinki) uuid="'"$UUID_XHELSINKI"'" ;;'
    echo '    xberlin) uuid="'"$UUID_XBERLIN"'" ;;'
    echo '    xlondon) uuid="'"$UUID_XLONDON"'" ;;'
    echo '    xpraga) uuid="'"$UUID_XPRAGA"'" ;;'
    echo '    xbogota) uuid="'"$UUID_XBOGOTA"'" ;;'
    echo '    *) echo "Unknown theme name: $name"; return 1 ;;'
    echo '  esac'
    echo '  gsettings set org.gnome.Terminal.ProfilesList default "'"'\$uuid'"'"'
    echo '}'
    echo 'alias gtxx="gtx x"'
    echo 'alias gtxmadrid="gtx xmadrid"'
    echo 'alias gtxlahabana="gtx xlahabana"'
    echo 'alias gtxseul="gtx xseul"'
    echo 'alias gtxmiami="gtx xmiami"'
    echo 'alias gtxparis="gtx xparis"'
    echo 'alias gtxtokio="gtx xtokio"'
    echo 'alias gtxoslo="gtx xoslo"'
    echo 'alias gtxhelsinki="gtx xhelsinki"'
    echo 'alias gtxberlin="gtx xberlin"'
    echo 'alias gtxlondon="gtx xlondon"'
    echo 'alias gtxpraga="gtx xpraga"'
    echo 'alias gtxbogota="gtx xbogota"'
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
