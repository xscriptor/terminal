# Xscriptor WezTerm

Install curated WezTerm color themes and switch them at runtime with simple aliases.

## Quick Install
- From the cloned repository:

```bash
sh wezterm/install.sh
```

- Remote one‑liner:

```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/wezterm/install.sh | sh
# or
curl -fsSL https://raw.githubusercontent.com/xscriptordev/terminal/main/wezterm/install.sh | sh
```

## What It Does
- Copies all `.toml` theme files into `~/.config/wezterm/colors`.
- Adds shell aliases to quickly switch themes using WezTerm’s CLI.
- Leaves your WezTerm config untouched (apart from shell aliases); use our config or add the runtime switch hook as shown below.

## Uninstall
- Remote one‑liner:
```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/wezterm/uninstall.sh | sh
# or
curl -fsSL https://raw.githubusercontent.com/xscriptordev/terminal/main/wezterm/uninstall.sh | sh
```
- Local:
```bash
chmod +x uninstall.sh && ./uninstall.sh
```

## Usage
- Switch theme with the provided function or aliases:

```bash
weztheme x
weztheme oslo
# or aliases:
wezx
wezoslo
```

- Revert to the config default:

```bash
weztheme default
```

## Available Themes
- x, madrid, lahabana, seul, miami
- paris, tokio, oslo, helsinki
- berlin, london, praha, bogota

## Requirements
- WezTerm installed and its CLI available (`wezterm cli ...`).
- curl or wget for the installer.
