#!/usr/bin/env sh
set -e
hex16() {
  c="${1#\#}"
  r="${c%??????}"; g="${c#??}"; g="${g%????}"; b="${c#??????}"
  printf '#%s%s%s%s%s%s' "$r$r" "$g$g" "$b$b"
}
if command -v gsettings >/dev/null 2>&1; then
  if gsettings list-schemas | grep -q '^guake\.style\.font$'; then
    p="#121215:#fc618d:#7bd88f:#fce566:#948ae3:#fc618d:#5ad4e6:#e6e6ec:#2a2a2e:#ff7aa1:#9be9ab:#fff18f:#b2abf0:#ff7aa1:#7fe0ef:#ffffff"
    PALETTE_16=""
    IFS=':'; for col in $p; do
      PALETTE_16="${PALETTE_16}$(hex16 "$col"):"
    done; IFS=' '; PALETTE_16="${PALETTE_16%:}"
    if gsettings list-keys guake.style.font | grep -q '^palette$'; then
      gsettings set guake.style.font palette "$PALETTE_16" || true
    fi
  elif gsettings list-schemas | grep -q '^guake\.style$'; then
    p="#121215:#fc618d:#7bd88f:#fce566:#948ae3:#fc618d:#5ad4e6:#e6e6ec:#2a2a2e:#ff7aa1:#9be9ab:#fff18f:#b2abf0:#ff7aa1:#7fe0ef:#ffffff"
    PALETTE_16=""
    IFS=':'; for col in $p; do
      PALETTE_16="${PALETTE_16}$(hex16 "$col"):"
    done; IFS=' '; PALETTE_16="${PALETTE_16%:}"
    if gsettings list-keys guake.style | grep -q '^palette$'; then
      gsettings set guake.style palette "$PALETTE_16" || true
    fi
  fi
fi
