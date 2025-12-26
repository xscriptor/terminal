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

## Usage
- Switch theme with the provided function or aliases:

```bash
weztheme xscriptor-theme
weztheme x-nord
# or aliases:
wezxscriptor
wezxnord
```

- Revert to the config default:

```bash
weztheme default
```

## Available Themes
- xscriptor-theme, xscriptor-theme-light, x-retro, x-summer-night, x-candy-pop
- x-dark-one, x-dark-colors, x-sense, x-nord, x-nord-inverted
- x-greyscale, x-greyscale-inverted, x-persecution

## Requirements
- WezTerm installed and its CLI available (`wezterm cli ...`).
- curl or wget for the installer.
