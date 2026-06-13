#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/xscriptor/terminal"
REF="${XSC_STARSHIP_REF:-main}"
DEST_DIR="${XSC_STARSHIP_DIR:-$HOME/.config/xscriptor/starship}"

SHELL_NAME="$(basename "${SHELL:-}")"
CONFIG_FILE="${XSC_STARSHIP_SHELL_RC:-}"
if [[ -z "$CONFIG_FILE" ]]; then
  case "$SHELL_NAME" in
    zsh)
      CONFIG_FILE="$HOME/.zshrc"
      ;;
    bash)
      CONFIG_FILE="$HOME/.bashrc"
      ;;
    *)
      CONFIG_FILE=""
      ;;
  esac
fi

fetch_archive() {
  local url="$1"
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$url"
    return 0
  fi
  if command -v wget >/dev/null 2>&1; then
    wget -qO- "$url"
    return 0
  fi
  echo "Error: curl or wget is required." >&2
  return 1
}

sed_in_place() {
  local file="$1"
  local pattern="$2"
  local replace="$3"
  sed -i.bak -e "s|$pattern|$replace|" "$file"
  rm -f "$file.bak"
}

update_export_line() {
  local file="$1"
  local theme_path="$2"
  if [[ -f "$file" ]]; then
    if grep -q '^export STARSHIP_CONFIG=' "$file"; then
      sed_in_place "$file" '^export STARSHIP_CONFIG=.*' "export STARSHIP_CONFIG=\"$theme_path\""
    else
      printf '\nexport STARSHIP_CONFIG="%s"\n' "$theme_path" >> "$file"
    fi
  else
    printf 'export STARSHIP_CONFIG="%s"\n' "$theme_path" > "$file"
  fi
}

append_function_block() {
  local file="$1"
  remove_block "$file" "# xscriptor-starship-v2" "# xscriptor-starship-v2-end"
  cat >> "$file" <<'EOF'

# xscriptor-starship-v2
xscriptor_starship_set() {
  local theme_path="$1"
  local config_file="${XSC_STARSHIP_SHELL_RC:-}"
  if [[ -z "$config_file" ]]; then
    local shell_name
    shell_name="$(basename "${SHELL:-}")"
    case "$shell_name" in
      zsh)
        config_file="$HOME/.zshrc"
        ;;
      bash)
        config_file="$HOME/.bashrc"
        ;;
      *)
        config_file=""
        ;;
    esac
  fi
  if [[ ! -f "$theme_path" ]]; then
    echo "Theme not found: $theme_path" >&2
    return 1
  fi
  export STARSHIP_CONFIG="$theme_path"
  if [[ -n "$config_file" ]]; then
    export XSC_STARSHIP_SHELL_RC="$config_file"
    if [[ -f "$config_file" ]]; then
      if grep -q '^export STARSHIP_CONFIG=' "$config_file"; then
        sed -i.bak -e "s|^export STARSHIP_CONFIG=.*|export STARSHIP_CONFIG=\"$theme_path\"|" "$config_file"
        rm -f "$config_file.bak"
      else
        printf '\nexport STARSHIP_CONFIG="%s"\n' "$theme_path" >> "$config_file"
      fi
    else
      printf 'export STARSHIP_CONFIG="%s"\n' "$theme_path" > "$config_file"
    fi
  fi
}

xscriptor_starship_theme() {
  local theme_name="${1:-x}"
  local theme_dir="${XSC_STARSHIP_DIR:-$HOME/.config/xscriptor/starship}"
  local theme_path="$theme_dir/themes/$theme_name.toml"
  xscriptor_starship_set "$theme_path"
}

xscriptor_starship_base() {
  local theme_dir="${XSC_STARSHIP_DIR:-$HOME/.config/xscriptor/starship}"
  local theme_path="$theme_dir/starship.toml"
  xscriptor_starship_set "$theme_path"
}

# xscriptor-starship-v2-end
EOF
}

append_alias_block() {
  local file="$1"
  remove_block "$file" "# xscriptor-starship-aliases" "# xscriptor-starship-aliases-end"
  cat >> "$file" <<'EOF'

# xscriptor-starship-aliases
alias ssbase='xscriptor_starship_base'
alias ssx='xscriptor_starship_theme x'
alias ssberlin='xscriptor_starship_theme berlin'
alias ssbogota='xscriptor_starship_theme bogota'
alias sshelsinki='xscriptor_starship_theme helsinki'
alias sslahabana='xscriptor_starship_theme lahabana'
alias sslondon='xscriptor_starship_theme london'
alias ssmadrid='xscriptor_starship_theme madrid'
alias ssmiami='xscriptor_starship_theme miami'
alias ssoslo='xscriptor_starship_theme oslo'
alias ssparis='xscriptor_starship_theme paris'
alias sspraha='xscriptor_starship_theme praha'
alias sstokio='xscriptor_starship_theme tokio'

# xscriptor-starship-aliases-end
EOF
}

remove_block() {
  local file="$1"
  local start_marker="$2"
  local end_marker="$3"
  if [[ ! -f "$file" ]]; then
    return 0
  fi
  if grep -q "$start_marker" "$file" 2>/dev/null; then
    sed -i.bak -e "/$start_marker/,/$end_marker/d" "$file"
    rm -f "$file.bak"
  fi
  if grep -q "$start_marker" "$file" 2>/dev/null; then
    sed -i.bak -e "/$start_marker/,/^$/d" "$file"
    rm -f "$file.bak"
  fi
}

remove_export_line() {
  local file="$1"
  local dest_dir="$2"
  if [[ ! -f "$file" ]]; then
    return 0
  fi
  awk -v dest="$dest_dir" '
    $0 ~ /^export STARSHIP_CONFIG=/ && index($0, dest) { next }
    { print }
  ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
}

uninstall_starship() {
  if [[ -n "$CONFIG_FILE" ]]; then
    remove_block "$CONFIG_FILE" "# xscriptor-starship-v2" "# xscriptor-starship-v2-end"
    remove_block "$CONFIG_FILE" "# xscriptor-starship-aliases" "# xscriptor-starship-aliases-end"
    remove_export_line "$CONFIG_FILE" "$DEST_DIR"
    echo "Updated config: $CONFIG_FILE"
  fi
  if [[ -d "$DEST_DIR" ]]; then
    rm -rf "$DEST_DIR"
    echo "Removed: $DEST_DIR"
  fi
}

main() {
  local tmp_dir
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' EXIT

  if [[ -z "$DEST_DIR" || "$DEST_DIR" == "/" ]]; then
    echo "Error: invalid install directory." >&2
    exit 1
  fi

  if [[ "${1:-}" == "--uninstall" || "${1:-}" == "uninstall" || "${1:-}" == "-u" ]]; then
    uninstall_starship
    return 0
  fi

  echo "Downloading Starship prompts (ref: $REF)..."
  fetch_archive "$REPO_URL/archive/refs/heads/$REF.tar.gz" | tar -xz -C "$tmp_dir"

  local repo_dir
  repo_dir="$(find "$tmp_dir" -maxdepth 1 -type d -name 'terminal-*' | head -n 1)"
  if [[ -z "$repo_dir" ]]; then
    echo "Error: repository archive not found after download." >&2
    exit 1
  fi

  local source_dir="$repo_dir/prompts/starship"
  if [[ ! -d "$source_dir" ]]; then
    echo "Error: prompts/starship not found in archive." >&2
    exit 1
  fi

  mkdir -p "$DEST_DIR"
  rm -rf "$DEST_DIR"/*
  cp -a "$source_dir/." "$DEST_DIR/"

  echo "Installed to: $DEST_DIR"

  if [[ -n "$CONFIG_FILE" ]]; then
    export XSC_STARSHIP_DIR="$DEST_DIR"
    export XSC_STARSHIP_SHELL_RC="$CONFIG_FILE"
    append_function_block "$CONFIG_FILE"
    append_alias_block "$CONFIG_FILE"
    update_export_line "$CONFIG_FILE" "$DEST_DIR/themes/x.toml"
    echo "Updated config: $CONFIG_FILE"
    echo "Use: xscriptor_starship_theme <theme>"
  else
    echo "Note: shell config not detected. Set XSC_STARSHIP_SHELL_RC and re-run if needed." >&2
  fi
}

main "$@"
