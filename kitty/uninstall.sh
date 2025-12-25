#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kitty"
TARGET_THEMES_DIR="$TARGET_CONFIG_DIR/themes"
MAIN="$TARGET_CONFIG_DIR/kitty.conf"
THEMES_FILES="xscriptor-theme.conf xscriptor-theme-light.conf x-retro.conf x-dark-one.conf x-candy-pop.conf x-sense.conf x-summer-night.conf x-nord.conf x-nord-inverted.conf x-greyscale.conf x-greyscale-inverted.conf x-dark-colors.conf x-persecution.conf"
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
echo "Starting Kitty uninstaller..."
remove_aliases() {
  RC="$1"
  [ -f "$RC" ] || return 0
  sed -i '/^kix() {/,/^}/d' "$RC" || true
  sed -i -E '/^alias kix[a-zA-Z0-9]+=/d' "$RC" || true
}
remove_aliases "$HOME/.bashrc" && echo "Removed aliases from ~/.bashrc" || true
remove_aliases "$HOME/.zshrc" && echo "Removed aliases from ~/.zshrc" || true
mkdir -p "$TARGET_THEMES_DIR"
REMOVED=0
for name in $THEMES_FILES; do
  if [ -f "$TARGET_THEMES_DIR/$name" ]; then
    rm -f "$TARGET_THEMES_DIR/$name"
    REMOVED=$((REMOVED+1))
  fi
done
echo "Removed $REMOVED theme files from $TARGET_THEMES_DIR"
restore_config_file() {
  FILE="$1"
  [ -f "$FILE" ] || { echo "Config not found: $FILE"; return 0; }
  LATEST="$(ls -1t "$FILE".bak.* 2>/dev/null | head -1 || true)"
  if [ -n "$LATEST" ] && [ -f "$LATEST" ]; then
    cp -f "$LATEST" "$FILE"
    echo "Restored backup: $LATEST -> $FILE"
    return 0
  fi
  sed -i -E '/^include[[:space:]]+themes\/(xscriptor-theme\.conf|xscriptor-theme-light\.conf|x-retro\.conf|x-dark-one\.conf|x-candy-pop\.conf|x-sense\.conf|x-summer-night\.conf|x-nord\.conf|x-nord-inverted\.conf|x-greyscale\.conf|x-greyscale-inverted\.conf|x-dark-colors\.conf|x-persecution\.conf)[[:space:]]*$/d' "$FILE"
  echo "Removed theme include lines from $FILE"
}
restore_config_file "$MAIN"
PM="$(detect_pm)" || PM=""
SUDO="$(sudo_cmd)"
printf "Do you also want to uninstall Kitty? [y/N] "
read -r REPLY_KITTY
case "$REPLY_KITTY" in
  y|Y)
    if [ -n "$PM" ]; then
      echo "Uninstalling Kitty with $PM..."
      case "$PM" in
        brew)
          brew uninstall kitty || true
          ;;
        apt-get)
          $SUDO apt-get remove --purge -y kitty || true
          ;;
        dnf)
          $SUDO dnf remove -y kitty || true
          ;;
        pacman)
          $SUDO pacman -Rns --noconfirm kitty || true
          ;;
        zypper)
          $SUDO zypper remove -y kitty || true
          ;;
        yum)
          $SUDO yum remove -y kitty || true
          ;;
        apk)
          $SUDO apk del kitty || true
          ;;
        *)
          echo "Unsupported package manager for automatic uninstall"
          ;;
      esac
    else
      echo "No supported package manager found to uninstall Kitty"
    fi
    ;;
  *)
    echo "Keeping Kitty installed"
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
echo "Kitty uninstall completed."
