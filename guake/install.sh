#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
THEME_NAME="${1:-xscriptor-theme}"

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
  PM="$(detect_pm)" || { return 1; }
  SUDO="$(sudo_cmd)"
  case "$PM" in
    brew)
      brew update
      for pkg in "$@"; do brew install "$pkg" || true; done
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

duphex() {
  h="$1"
  r="${h%??????}"; g="${h#??}"; g="${g%????}"; b="${h#??????}"
  echo "#${r}${r}${g}${g}${b}${b}"
}

set_guake_colors() {
  name="$1"
  case "$name" in
    xscriptor-theme)
      BG="050505"; FG="f7f1ff"
      P="363537 fc618d 7bd88f fce566 fd9353 948ae3 5ad4e6 f7f1ff 69676c fc618d 7bd88f fce566 fd9353 948ae3 5ad4e6 f7f1ff"
      ;;
    xscriptor-theme-light)
      BG="fafafa"; FG="1a1a1a"
      P="333333 cc0033 009933 b8860b 0099cc 6633cc 0099cc 1a1a1a 666666 cc0033 009933 b8860b 0099cc 6633cc 0099cc 1a1a1a"
      ;;
    x-retro)
      BG="191919"; FG="f7f1ff"
      P="363537 fc618d 7bd88f e5ff9d fd9353 948ae3 5ad4e6 f7f1ff 69676c fc618d 7bd88f e5ff9d fd9353 948ae3 5ad4e6 f7f1ff"
      ;;
    x-dark-candy|x-candy-pop)
      BG="000000"; FG="f7f1ff"
      P="000000 ff4c8b 7fffd4 ffd84c 00ffa8 d36cff 47cfff f7f1ff 69676c ff4c8b 7fffd4 ffd84c 00ffa8 d36cff 47cfff f7f1ff"
      ;;
    x-greyscale)
      BG="000000"; FG="cccccc"
      P="000000 999999 bbbbbb dddddd 888888 aaaaaa cccccc ffffff 333333 bbbbbb dddddd ffffff aaaaaa cccccc eeeeee ffffff"
      ;;
    x-greyscale-inverted)
      BG="ffffff"; FG="333333"
      P="000000 333333 444444 555555 666666 777777 888888 999999 333333 444444 555555 666666 777777 888888 999999 aaaaaa"
      ;;
    x-dark-colors)
      BG="1a1a1a"; FG="ffffff"
      P="1a1a1a ff5555 b8e6a0 ffe4a3 bd93f9 ff9aa2 8be9fd ffffff 6272a4 ff6e6e b8e6a0 ffe4a3 d6acff ff9aa2 a4ffff ffffff"
      ;;
    x-sense)
      BG="11091c"; FG="f7f1ff"
      P="222222 fc618d 7bd88f fce566 a3f3ff c4bdff a3f3ff f7f1ff 525053 fc618d 7bd88f fce566 a3f3ff c4bdff a3f3ff f7f1ff"
      ;;
    x-nord)
      BG="181a1f"; FG="abb2bf"
      P="3f4451 e05561 8cc265 d18f52 4aa5f0 c162de 42b3c2 e6e6e6 4f5666 ff616e a5e075 f0a45d 4dc4ff de73ff 4cd1e0 ffffff"
      ;;
    x-nord-inverted)
      BG="f8fafe"; FG="544d40"
      P="c0bbae 1faa9e 733d9a 2e70ad b55a0f 3e9d21 bd4c3d 191919 b0a999 009e91 5a1f8a 0f5ba2 b23b00 218c00 b32e1f 000000"
      ;;
    x-summer-night)
      BG="191919"; FG="f7f1ff"
      P="363537 fc618d 7bd88f fce566 fd9353 948ae3 5ad4e6 f7f1ff 69676c fc618d 7bd88f fce566 fd9353 948ae3 5ad4e6 f7f1ff"
      ;;
    x-persecution)
      BG="140706"; FG="f7f1ff"
      P="222222 fc618d 7bd88f ffed89 47e6ff ff9999 47e6ff f7f1ff 525053 fc618d 7bd88f ffed89 47e6ff ff9999 47e6ff f7f1ff"
      ;;
    *)
      echo "Tema no reconocido: $name"
      echo "Temas disponibles: xscriptor-theme xscriptor-theme-light x-retro x-dark-candy x-candy-pop x-greyscale x-greyscale-inverted x-dark-colors x-sense x-nord x-nord-inverted x-summer-night x-persecution"
      exit 1
      ;;
  esac

  PAL=""
  i=0
  for c in $P; do
    hex="$(duphex "$c")"
    if [ $i -eq 0 ]; then
      PAL="$hex"
    else
      PAL="$PAL:$hex"
    fi
    i=$((i+1))
  done

  if command -v dconf >/dev/null 2>&1; then
    dconf write /org/guake/style/font/palette "'$PAL'" || true
    dconf write /org/guake/style/font/color "'$(duphex "$FG")'" || true
    dconf write /org/guake/style/background/color "'$(duphex "$BG")'" || true
  elif command -v gsettings >/dev/null 2>&1; then
    # Fall back to gsettings using likely keys; if they fail, continue silently
    gsettings set org.guake style-font-palette "$PAL" || true
    gsettings set org.guake style-font-color "$(duphex "$FG")" || true
    gsettings set org.guake style-background-color "$(duphex "$BG")" || true
  else
    echo "dconf/gsettings no disponibles; instala 'dconf-cli'"
    exit 1
  fi
  echo "Guake: aplicado tema '$name'"
}

ensure_deps() {
  MISSING=""
  command -v dconf >/dev/null 2>&1 || MISSING="$MISSING dconf-cli"
  command -v guake >/dev/null 2>&1 || MISSING="$MISSING guake"
  if [ -n "$MISSING" ]; then
    install_pkgs $MISSING || true
  fi
}

append_aliases() {
  RC="$1"
  [ -f "$RC" ] || touch "$RC"
  sed -i '/^gqx() {/,/^}/d' "$RC" 2>/dev/null || true
  sed -i -E '/^alias gq[a-zA-Z0-9]+=/d' "$RC" 2>/dev/null || true
  {
    echo 'gqx() {'
    echo '  name="$1"'
    echo '  sh -c "'"$SCRIPT_DIR"'/install.sh \"${name:-xscriptor-theme}\""'
    echo '}'
    echo 'alias gqxscriptor="gqx xscriptor-theme"'
    echo 'alias gqxscriptorlight="gqx xscriptor-theme-light"'
    echo 'alias gqxretro="gqx x-retro"'
    echo 'alias gqxdarkcandy="gqx x-dark-candy"'
    echo 'alias gqxcandypop="gqx x-candy-pop"'
    echo 'alias gqxgreyscale="gqx x-greyscale"'
    echo 'alias gqxgreyscaleinv="gqx x-greyscale-inverted"'
    echo 'alias gqxdarkcolors="gqx x-dark-colors"'
    echo 'alias gqxsense="gqx x-sense"'
    echo 'alias gqxnord="gqx x-nord"'
    echo 'alias gqxnordinverted="gqx x-nord-inverted"'
    echo 'alias gqxsummer="gqx x-summer-night"'
    echo 'alias gqxpersecution="gqx x-persecution"'
  } >> "$RC"
}

ensure_deps || true
set_guake_colors "$THEME_NAME"

if command -v bash >/dev/null 2>&1; then
  append_aliases "$HOME/.bashrc"
  echo "Aliases añadidos a ~/.bashrc"
fi
if command -v zsh >/dev/null 2>&1; then
  append_aliases "$HOME/.zshrc"
  echo "Aliases añadidos a ~/.zshrc"
fi

echo "Instalación de temas Guake completada."

