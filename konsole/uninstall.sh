#!/usr/bin/env sh
set -e

TARGET_THEMES_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/konsole"
ALT_THEMES_DIR="$HOME/.kde/share/apps/konsole"
THEMES_FILES="x.colorscheme madrid.colorscheme lahabana.colorscheme seul.colorscheme miami.colorscheme paris.colorscheme tokio.colorscheme oslo.colorscheme helsinki.colorscheme berlin.colorscheme london.colorscheme praha.colorscheme bogota.colorscheme"

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

echo "Starting Konsole uninstaller..."

remove_aliases() {
  RC="$1"
  [ -f "$RC" ] || return 0
  if sed --version >/dev/null 2>&1; then
    sed -i '/^knx() {/,/^}/d' "$RC" || true
    sed -i '/^alias knx[[:alnum:]]\{1,\}=/d' "$RC" || true
  else
    sed -i '' '/^knx() {/,/^}/d' "$RC" || true
    sed -i '' '/^alias knx[[:alnum:]]\{1,\}=/d' "$RC" || true
  fi
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

if [ -d "$ALT_THEMES_DIR" ]; then
  REMOVED_ALT=0
  for name in $THEMES_FILES; do
    if [ -f "$ALT_THEMES_DIR/$name" ]; then
      rm -f "$ALT_THEMES_DIR/$name"
      REMOVED_ALT=$((REMOVED_ALT+1))
    fi
  done
  [ "$REMOVED_ALT" -gt 0 ] && echo "Removed $REMOVED_ALT theme files from $ALT_THEMES_DIR" || true
fi

if command -v konsoleprofile >/dev/null 2>&1; then
  konsoleprofile "colors=Breeze" || konsoleprofile "ColorScheme=Breeze" || true
fi

PM="$(detect_pm)" || PM=""
SUDO="$(sudo_cmd)"
printf "Do you also want to uninstall Konsole? [y/N] "
read -r REPLY_KONSOLE
case "$REPLY_KONSOLE" in
  y|Y)
    if [ -n "$PM" ]; then
      echo "Uninstalling Konsole with $PM..."
      case "$PM" in
        brew)
          brew uninstall konsole || true
          ;;
        apt-get)
          $SUDO apt-get remove --purge -y konsole || true
          ;;
        dnf)
          $SUDO dnf remove -y konsole || true
          ;;
        pacman)
          $SUDO pacman -Rns --noconfirm konsole || true
          ;;
        zypper)
          $SUDO zypper remove -y konsole || true
          ;;
        yum)
          $SUDO yum remove -y konsole || true
          ;;
        apk)
          $SUDO apk del konsole || true
          ;;
        *)
          echo "Unsupported package manager for automatic uninstall"
          ;;
      esac
    else
      echo "No supported package manager found to uninstall Konsole"
    fi
    ;;
  *)
    echo "Keeping Konsole installed"
    ;;
esac

echo "Konsole uninstall completed."
