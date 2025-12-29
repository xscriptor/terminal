#!/usr/bin/env sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_DIR="$SCRIPT_DIR/themes"
RAW_BASE="https://raw.githubusercontent.com/xscriptordev/terminal/main/warp/themes"

detect_target() {
  OS="$(uname -s)"
  case "$OS" in
    Darwin)
      echo "$HOME/.warp/themes"
      ;;
    *)
      echo "${XDG_DATA_HOME:-$HOME/.local/share}/warp-terminal/themes"
      ;;
  esac
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
  [ -z "$CMD" ] && { echo "No curl/wget found"; exit 1; }
  if [ "$CMD" = "curl" ]; then
    curl -fsSL -o "$DEST" "$URL"
  else
    wget -qO "$DEST" "$URL"
  fi
}

TARGET_DIR="$(detect_target)"
mkdir -p "$TARGET_DIR"

NAMES="x madrid lahabana seul miami paris tokio oslo helsinki berlin london praha bogota"

USE_REMOTE=0
if [ ! -d "$SRC_DIR" ] || [ -z "$(ls -1 "$SRC_DIR"/*.yaml 2>/dev/null)" ]; then
  USE_REMOTE=1
fi

if [ "$USE_REMOTE" -eq 0 ]; then
  for name in $NAMES; do
    src="$SRC_DIR/$name.yaml"
    if [ -f "$src" ]; then
      cp -f "$src" "$TARGET_DIR/$(basename "$src")"
    else
      echo "Warning: local theme not found: $name.yaml"
    fi
  done
else
  for name in $NAMES; do
    fetch_file "$RAW_BASE/$name.yaml" "$TARGET_DIR/$name.yaml" || echo "Warning: remote theme not found: $name.yaml"
  done
fi

echo "Warp themes installed to: $TARGET_DIR"
echo "Open Warp → Settings → Appearance → Theme and pick your theme."
