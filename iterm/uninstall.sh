#!/usr/bin/env sh
set -e

OS="$(uname -s)"
[ "$OS" = "Darwin" ] || { echo "This uninstaller is for macOS (iTerm2) only."; exit 1; }

PLIST="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
NAMES="xscriptor-theme xscriptor-theme-light x-retro x-summer-night x-candy-pop x-dark-candy x-sense x-nord x-nord-inverted x-greyscale x-greyscale-inverted x-dark-colors x-persecution"

detect_pm() {
  command -v brew >/dev/null 2>&1 && { echo "brew"; return 0; }
  return 1
}

ASSUME_YES=0
while [ $# -gt 0 ]; do
  case "$1" in
    -y|--yes) ASSUME_YES=1 ;;
  esac
  shift
done

echo "Starting iTerm2 presets uninstaller..."

if [ ! -f "$PLIST" ]; then
  echo "iTerm2 preferences not found: $PLIST"
  echo "If you haven't opened iTerm2 yet, open it once to generate the file."
else
  REMOVED=0
  for name in $NAMES; do
    /usr/libexec/PlistBuddy -c "Delete :'Custom Color Presets':'$name'" "$PLIST" >/dev/null 2>&1 && REMOVED=$((REMOVED+1)) || true
  done
  echo "Removed $REMOVED color presets in iTerm2"
fi

PM="$(detect_pm)" || PM=""
if [ "$ASSUME_YES" = "1" ] || [ "${ITERM_UNINSTALL_APP:-0}" = "1" ]; then
  REPLY_ITERM="y"
else
  if [ -t 0 ]; then
    printf "Do you also want to uninstall iTerm2 (Homebrew cask)? [y/N] "
    read -r REPLY_ITERM
  else
    REPLY_ITERM="n"
  fi
fi

case "$REPLY_ITERM" in
  y|Y)
    if [ "$PM" = "brew" ]; then
      echo "Uninstalling iTerm2 with Homebrew..."
      brew uninstall --cask iterm2 || true
    else
      echo "Homebrew not found; cannot uninstall iTerm2 automatically."
    fi
    ;;
  *)
    echo "Keeping iTerm2 installed"
    ;;
esac

echo "iTerm2 presets uninstall completed."

