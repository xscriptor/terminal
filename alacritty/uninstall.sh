#!/usr/bin/env sh
set -e

TARGET_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/alacritty"
TARGET_THEMES_DIR="$TARGET_CONFIG_DIR/themes"
MAIN="$TARGET_CONFIG_DIR/alacritty.toml"
THEMES_FILES="xscriptor-theme.toml xscriptor-theme-light.toml x-retro.toml x-dark-candy.toml x-candy-pop.toml x-sense.toml x-summer-night.toml x-nord.toml x-nord-inverted.toml x-greyscale.toml x-greyscale-inverted.toml x-dark-colors.toml x-persecution.toml x.toml xmadrid.toml xlahabana.toml xseul.toml xmiami.toml xparis.toml xtokio.toml xoslo.toml xhelsinki.toml xberlin.toml xlondon.toml xpraga.toml xbogota.toml"

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

remove_aliases() {
  RC="$1"
  [ -f "$RC" ] || return 0
  sed -i '/^alax() {/,/^}/d' "$RC" || true
  sed -i -E '/^alias alax[a-zA-Z0-9]+=/d' "$RC" || true
}

remove_aliases "$HOME/.bashrc" || true
remove_aliases "$HOME/.zshrc" || true
echo "Removed Alacritty aliases from shell RC files"

mkdir -p "$TARGET_THEMES_DIR"
REMOVED=0
for name in $THEMES_FILES; do
  if [ -f "$TARGET_THEMES_DIR/$name" ]; then
    rm -f "$TARGET_THEMES_DIR/$name"
    REMOVED=$((REMOVED+1))
  fi
done
echo "Removed $REMOVED Alacritty theme files from $TARGET_THEMES_DIR"

restore_config_file() {
  FILE="$1"
  [ -f "$FILE" ] || { echo "Config not found: $FILE"; return 0; }
  LATEST="$(ls -1t "$FILE".bak.* 2>/dev/null | head -1 || true)"
  if [ -n "$LATEST" ] && [ -f "$LATEST" ]; then
    cp -f "$LATEST" "$FILE"
    echo "Restored backup: $LATEST -> $FILE"
    return 0
  fi
  if grep -Eq '^import[[:space:]]*=\s*\[.*(xscriptor-theme\.toml|xscriptor-theme-light\.toml|x-retro\.toml|x-dark-candy\.toml|x-candy-pop\.toml|x-sense\.toml|x-summer-night\.toml|x-nord\.toml|x-nord-inverted\.toml|x-greyscale\.toml|x-greyscale-inverted\.toml|x-dark-colors\.toml|x-persecution\.toml|x\.toml|xmadrid\.toml|xlahabana\.toml|xseul\.toml|xmiami\.toml|xparis\.toml|xtokio\.toml|xoslo\.toml|xhelsinki\.toml|xberlin\.toml|xlondon\.toml|xpraga\.toml|xbogota\.toml).*\]' "$FILE"; then
    sed -i -E '/^import[[:space:]]*=/d' "$FILE"
    echo "Removed import line from $FILE"
  else
    echo "Left config unchanged: $FILE"
  fi
}

restore_config_file "$MAIN"

PM="$(detect_pm)" || PM=""
SUDO="$(sudo_cmd)"
printf "Do you also want to uninstall Alacritty? [y/N] "
read -r REPLY_ALA
case "$REPLY_ALA" in
  y|Y)
    if [ -n "$PM" ]; then
      echo "Uninstalling Alacritty with $PM..."
      case "$PM" in
        brew)
          brew uninstall --cask alacritty || true
          ;;
        apt-get)
          $SUDO apt-get remove --purge -y alacritty || true
          ;;
        dnf)
          $SUDO dnf remove -y alacritty || true
          ;;
        pacman)
          $SUDO pacman -Rns --noconfirm alacritty || true
          ;;
        zypper)
          $SUDO zypper remove -y alacritty || true
          ;;
        yum)
          $SUDO yum remove -y alacritty || true
          ;;
        apk)
          $SUDO apk del alacritty || true
          ;;
        *)
          echo "Unsupported package manager for automatic uninstall"
          ;;
      esac
    else
      echo "No supported package manager found to uninstall Alacritty"
    fi
    ;;
  *)
    echo "Keeping Alacritty installed"
    ;;
esac

printf "Do you also want to uninstall Hack Nerd Font? [y/N] "
read -r REPLY_FONT
case "$REPLY_FONT" in
  y|Y)
    OS="$(uname -s)"
    case "$OS" in
      Darwin)
        echo "Uninstalling Hack Nerd Font (macOS, Homebrew cask)..."
        brew uninstall --cask font-hack-nerd-font || true
        ;;
      *)
        DEST="${XDG_DATA_HOME:-$HOME/.local/share}/fonts/NerdFonts/Hack"
        if [ -d "$DEST" ]; then
          echo "Removing fonts at: $DEST"
          rm -rf "$DEST"
          echo "Updating font cache..."
          fc-cache -f >/dev/null 2>&1 || true
          echo "Font cache updated"
        else
          echo "Hack Nerd Font directory not found: $DEST"
        fi
        ;;
    esac
    ;;
  *)
    echo "Keeping Hack Nerd Font installed"
    ;;
esac

echo "Alacritty uninstall completed."
