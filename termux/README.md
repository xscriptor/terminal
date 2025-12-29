# Xscriptor Termux

Themes and quick setup for Termux.

## Quick Install
- One‑liner:

```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/termux/install.sh | bash
# or
curl -fsSL https://raw.githubusercontent.com/xscriptordev/terminal/main/termux/install.sh | bash
```

## What It Does
- Downloads themes to `~/.termux/themes`.
- Applies `x` by default to `~/.termux/colors.properties`.
- Creates the `tmx` function and aliases to switch themes.
- Tries to reload settings via `termux-reload-settings`.

## Usage
- Switch theme: `tmx <theme-name>`
  - Examples: `tmx x`, `tmx madrid`, `tmx oslo`, `tmx praha`
- Quick aliases:
  - `tmxx`, `tmxxmadrid`, `tmxxlahabana`, `tmxxmiami`, `tmxxparis`, `tmxxtokio`, `tmxxoslo`, `tmxxhelsinki`, `tmxxberlin`, `tmxxlondon`, `tmxxpraha`, `tmxxbogota`
- Reload settings: `termux-reload-settings`
- If aliases don’t show up, reload your shell:
  - `source ~/.bashrc` or `source ~/.zshrc`

## Files
- Installer: [install.sh](./install.sh)
- Themes: `~/.termux/themes/*.properties`

## Notes
- Termux uses `~/.termux/colors.properties` for colors.
- On some devices, restarting Termux or running `termux-reload-settings` is needed after switching themes.
