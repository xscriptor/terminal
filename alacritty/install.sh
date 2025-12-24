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
  echo "Usando gestor de paquetes: $PM"
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
command -v unzip >/dev/null 2>&1 || MISSING="$MISSING unzip"

if [ -n "$MISSING" ]; then
  echo "Instalando paquetes faltantes:$MISSING"
  install_pkgs $MISSING || { echo "Error al instalar paquetes requeridos:$MISSING"; exit 1; }
fi

font_installed() {
  command -v fc-list >/dev/null 2>&1 || return 1
  fc-list : family | grep -Ei '\bhack\b.*nerd' >/dev/null 2>&1
}

install_font_macos() {
  echo "Instalando Hack Nerd Font en macOS..."
  brew tap homebrew/cask-fonts >/dev/null 2>&1 || true
  brew install --cask font-hack-nerd-font
}

install_font_linux() {
  DEST="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/NerdFonts/Hack"
  mkdir -p "$DEST"
  TMPDIR="$(mktemp -d)"
  ZIP1="$TMPDIR/Hack.zip"
  echo "Descargando Nerd Font a: $DEST"
  fetch_file "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip" "$ZIP1" || true
  if [ -s "$ZIP1" ]; then
    echo "Extrayendo Hack.zip..."
    unzip -o "$ZIP1" -d "$DEST" >/dev/null 2>&1
  fi
  COUNT="$(ls -1 "$DEST" 2>/dev/null | wc -l | tr -d ' ')"
  echo "Archivos de fuente instalados: $COUNT en $DEST"
  echo "Actualizando caché de fuentes..."
  fc-cache -f "$DEST" >/dev/null 2>&1 || true
  echo "Caché de fuentes actualizada"
  rm -rf "$TMPDIR"
}

echo "Verificando Hack Nerd Font..."
if font_installed; then
  echo "Fuente ya instalada y detectada por fontconfig"
else
  OS="$(uname -s)"
  echo "Fuente no detectada, instalando en $OS..."
  case "$OS" in
    Darwin)
      install_font_macos
      ;;
    *)
      install_font_linux
      ;;
  esac
  if font_installed; then
    echo "Fuente instalada correctamente"
  else
    echo "Advertencia: la fuente no se detecta tras la instalación. Revise $HOME/.local/share/fonts o el gestor de fuentes del sistema."
  fi
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
  echo "Usando temas locales en $SRC_THEMES_DIR"
  for f in "$SRC_THEMES_DIR"/*.toml; do
    [ -f "$f" ] && cp -f "$f" "$TARGET_THEMES_DIR/$(basename "$f")"
  done
else
  echo "Descargando temas desde repositorio remoto..."
  for name in $THEMES_FILES; do
    fetch_file "$RAW_BASE/themes/$name" "$TARGET_THEMES_DIR/$name"
  done
fi

if [ -f "$MAIN" ]; then
  TS="$(date +%s)"
  cp "$MAIN" "$MAIN.bak.$TS"
  echo "Respaldo creado: $MAIN.bak.$TS"
fi
if [ "$USE_REMOTE" -eq 0 ]; then
  cp -f "$SCRIPT_DIR/alacritty.toml" "$MAIN"
else
  fetch_file "$RAW_BASE/alacritty.toml" "$MAIN"
fi
echo "Archivo de configuración escrito: $MAIN"

sed -i -E 's#^import = \[.*\]#import = ["themes/xscriptor-theme.toml"]#' "$MAIN" || true
echo "Tema por defecto establecido: themes/xscriptor-theme.toml"

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
  echo "Aliases añadidos a ~/.bashrc"
fi
if command -v zsh >/dev/null 2>&1; then
  append_aliases "$HOME/.zshrc"
  echo "Aliases añadidos a ~/.zshrc"
fi
