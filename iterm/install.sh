#!/usr/bin/env sh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_THEMES_DIR="$SCRIPT_DIR/themes"
RAW_BASE="https://raw.githubusercontent.com/xscriptordev/terminal/main/iterm/themes"
THEMES_FILES="x.itermcolors xmadrid.itermcolors xlahabana.itermcolors xseul.itermcolors xmiami.itermcolors xparis.itermcolors xtokio.itermcolors xoslo.itermcolors xhelsinki.itermcolors xberlin.itermcolors xlondon.itermcolors xpraga.itermcolors xbogota.itermcolors x-dark-one.itermcolors"

os="$(uname -s)"
[ "$os" = "Darwin" ] || { echo "This installer requires macOS to use iTerm2."; exit 1; }

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
  url="$1"
  dest="$2"
  cmd="$(fetch_cmd)"
  [ -z "$cmd" ] && { echo "curl or wget is required"; exit 1; }
  if [ "$cmd" = "curl" ]; then
    curl -fsSL -o "$dest" "$url"
  else
    wget -qO "$dest" "$url"
  fi
}

USE_REMOTE=0
for name in $THEMES_FILES; do
  [ -f "$SRC_THEMES_DIR/$name" ] || { USE_REMOTE=1; break; }
done

TMP_DIR="${TMPDIR:-/tmp}/xscriptor-iterm-$(date +%s)"
mkdir -p "$TMP_DIR"

if [ "$USE_REMOTE" -eq 0 ]; then
  echo "Using local files from $SRC_THEMES_DIR"
  for name in $THEMES_FILES; do
    [ -f "$SRC_THEMES_DIR/$name" ] && cp -f "$SRC_THEMES_DIR/$name" "$TMP_DIR/$name"
  done
else
  echo "Downloading themes from remote repository"
  for name in $THEMES_FILES; do
    fetch_file "$RAW_BASE/$name" "$TMP_DIR/$name"
  done
fi

COUNT="$(ls -1 "$TMP_DIR"/*.itermcolors 2>/dev/null | wc -l | tr -d ' ')"
echo "Prepared themes: $COUNT in $TMP_DIR"

for f in "$TMP_DIR"/*.itermcolors; do
  [ -f "$f" ] && { echo "Importing $(basename "$f") into iTerm2"; open "$f"; }
done

echo "Import completed. Select the preset in iTerm2: Preferences > Profiles > Colors > Color Presets."
