#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_THEMES_DIR="$SCRIPT_DIR/themes"
TARGET_CONFIG_DIR="$HOME/.config/foot"
TARGET_THEMES_DIR="$TARGET_CONFIG_DIR/themes"
MAIN="$TARGET_CONFIG_DIR/foot.ini"

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
          foot)
            brew install foot
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

MISSING=""
command -v foot >/dev/null 2>&1 || MISSING="$MISSING foot"
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
    if unzip -tq "$ZIP1" >/dev/null 2>&1; then
      echo "Extrayendo Hack.zip..."
      set +e
      unzip -o "$ZIP1" -d "$DEST" >/dev/null 2>&1
      USTATUS=$?
      set -e
      if [ "$USTATUS" -ne 0 ]; then
        echo "Error al extraer Hack.zip, se continúa sin instalar la fuente"
      else
        echo "Extracción completada"
      fi
    else
      echo "Archivo Hack.zip inválido (posible respuesta HTML/Rate limit). Se omite extracción."
    fi
  else
    echo "No se descargó Hack.zip (archivo vacío). Se omite extracción."
  fi
  COUNT="$(ls -1 "$DEST" 2>/dev/null | wc -l | tr -d ' ')"
  echo "Archivos de fuente instalados: $COUNT en $DEST"
  echo "Actualizando caché de fuentes..."
  fc-cache -f "$DEST" >/dev/null 2>&1 || true
  echo "Caché de fuentes actualizada"
  rm -rf "$TMPDIR"
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

RAW_BASE="https://raw.githubusercontent.com/xscriptordev/terminal/dev/foot"
THEMES_FILES="xscriptor-theme.ini xscriptor-theme-light.ini x-retro.ini x-dark-candy.ini x-candy-pop.ini x-sense.ini x-summer-night.ini x-nord.ini x-nord-inverted.ini x-greyscale.ini x-greyscale-inverted.ini x-dark-colors.ini x-persecution.ini"

mkdir -p "$TARGET_CONFIG_DIR"
mkdir -p "$TARGET_THEMES_DIR"

USE_REMOTE=0
if [ ! -d "$SRC_THEMES_DIR" ] || [ -z "$(ls -1 "$SRC_THEMES_DIR"/*.ini 2>/dev/null)" ] || [ ! -f "$SCRIPT_DIR/foot.ini" ]; then
  USE_REMOTE=1
fi

if [ "$USE_REMOTE" -eq 0 ]; then
  echo "Usando temas locales en $SRC_THEMES_DIR"
  for f in "$SRC_THEMES_DIR"/*.ini; do
    [ -f "$f" ] && cp -f "$f" "$TARGET_THEMES_DIR/$(basename "$f")"
  done
  COUNT_T="$(ls -1 "$TARGET_THEMES_DIR" 2>/dev/null | wc -l | tr -d ' ')"
  echo "Temas instalados: $COUNT_T en $TARGET_THEMES_DIR"
else
  echo "Descargando temas desde repositorio remoto..."
  for name in $THEMES_FILES; do
    fetch_file "$RAW_BASE/themes/$name" "$TARGET_THEMES_DIR/$name"
  done
  COUNT_T="$(ls -1 "$TARGET_THEMES_DIR" 2>/dev/null | wc -l | tr -d ' ')"
  echo "Temas instalados (remoto): $COUNT_T en $TARGET_THEMES_DIR"
fi

if [ -f "$MAIN" ]; then
  TS="$(date +%s)"
  cp "$MAIN" "$MAIN.bak.$TS"
  echo "Respaldo creado: $MAIN.bak.$TS"
fi
if [ "$USE_REMOTE" -eq 0 ]; then
  cp -f "$SCRIPT_DIR/foot.ini" "$MAIN"
else
  fetch_file "$RAW_BASE/foot.ini" "$MAIN"
fi
echo "Archivo de configuración escrito: $MAIN"

sed -i -E 's#^include=.*#include=~/.config/foot/themes/xscriptor-theme.ini#' "$MAIN" || true
grep -q '^include=' "$MAIN" || {
  if grep -q '^\[main\]' "$MAIN"; then
    sed -i '/^\[main\]/a include=~\/.config\/foot\/themes\/xscriptor-theme.ini' "$MAIN"
  else
    {
      echo "[main]"
      echo "include=~/.config/foot/themes/xscriptor-theme.ini"
    } >> "$MAIN"
  fi
}
echo "Tema por defecto establecido: themes/xscriptor-theme.ini"

append_aliases() {
  RC="$1"
  [ -f "$RC" ] || touch "$RC"
  sed -i '/^footx() {/,/^}/d' "$RC" || true
  sed -i -E '/^alias footx[a-zA-Z0-9]+=/d' "$RC" || true
  {
    echo 'footx() {'
    echo '  name="$1"'
    echo '  file="$HOME/.config/foot/foot.ini"'
    echo '  sed -i -E "s#^include=.*#include=~/.config/foot/themes/${name}.ini#" "$file"'
    echo '  if ! grep -q "^include=" "$file"; then'
    echo '    if grep -q "^\[main\]" "$file"; then'
    echo '      sed -i "/^\[main\]/a include=~/.config/foot/themes/${name}.ini" "$file"'
    echo '    else'
    echo '      { echo "[main]"; echo "include=~/.config/foot/themes/${name}.ini"; } >> "$file"'
    echo '    fi'
    echo '  fi'
    echo '}'
    echo 'alias footxscriptor="footx xscriptor-theme"'
    echo 'alias footxscriptorlight="footx xscriptor-theme-light"'
    echo 'alias footxsense="footx x-sense"'
    echo 'alias footxsummer="footx x-summer-night"'
    echo 'alias footxretro="footx x-retro"'
    echo 'alias footxdark="footx x-dark-colors"'
    echo 'alias footxdarkcandy="footx x-dark-candy"'
    echo 'alias footxcandy="footx x-dark-candy"'
    echo 'alias footxcandypop="footx x-candy-pop"'
    echo 'alias footxnord="footx x-nord"'
    echo 'alias footxnordinverted="footx x-nord-inverted"'
    echo 'alias footxgreyscale="footx x-greyscale"'
    echo 'alias footxgreyscaleinv="footx x-greyscale-inverted"'
    echo 'alias footxpersecution="footx x-persecution"'
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
echo "Instalación de Foot finalizada."
