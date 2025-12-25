# Xscriptor Foot Themes

This folder contains a set of Foot themes and a tuned `foot.ini` that includes the default Xscriptor theme and a minimal, predictable configuration (font, padding, DPI behavior).

## Files
- `foot.ini`: Base config that includes `themes/xscriptor-theme.ini` by default.
- `install.sh`: Installs themes and configuration, ensures dependencies, and sets shell aliases for quick theme switching.
- `themes/*.ini`: Theme files ready to be included by Foot:
  - `xscriptor-theme.ini`
  - `xscriptor-theme-light.ini`
  - `x-retro.ini`
  - `x-dark-candy.ini`
  - `x-candy-pop.ini`
  - `x-sense.ini`
  - `x-summer-night.ini`
  - `x-nord.ini`
  - `x-nord-inverted.ini`
  - `x-greyscale.ini`
  - `x-greyscale-inverted.ini`
  - `x-dark-colors.ini`
  - `x-persecution.ini`

## Requirements
- Foot (Wayland terminal) with `foot.ini` support.
- `sed`, `zsh` or `bash`.
- `fontconfig` (`fc-list`), `curl` or `wget`, `unzip`.
- A Nerd Font installed, specifically `Hack Nerd Font` (installer tries to install it automatically).

## Installation
- One-liner:
```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/foot/install.sh | bash
```

or

- Download the repo, go to the folder and run the installer:
  - `chmod +x install.sh && ./install.sh`
- What it does:
  - Detects your package manager and installs any missing dependencies (`foot`, `sed`, `fontconfig`, `curl/wget`, `unzip`).
  - Verifies `Hack Nerd Font`; if missing, downloads and installs it (Linux/macOS).
  - Copies all `themes/*.ini` into `~/.config/foot/themes` (or downloads them from the repo if not present locally).
  - Backs up any existing config to `~/.config/foot/foot.ini.bak.<timestamp>`.
  - Installs the provided `foot.ini` to `~/.config/foot/foot.ini`.
  - Ensures the include line is set to `~/.config/foot/themes/xscriptor-theme.ini`.
  - Appends shell aliases to `~/.bashrc` and `~/.zshrc`.
- Reload your shell session:
  - `source ~/.bashrc` or `source ~/.zshrc`

## Switching Themes
- Generic function:
  - `footx <theme_basename>`
  - Example: `footx x-nord` sets `include=~/.config/foot/themes/x-nord.ini`.
- Ready-to-use aliases:
  - `footxscriptor`, `footxscriptorlight`
  - `footxsense`, `footxsummer`, `footxretro`
  - `footxdark`, `footxdarkcandy`, `footxcandy`, `footxcandypop`
  - `footxnord`, `footxnordinverted`
  - `footxgreyscale`, `footxgreyscaleinv`
  - `footxpersecution`

## Default Configuration Highlights
- `[main]`:
  - `include=~/.config/foot/themes/xscriptor-theme.ini`
  - `term=foot`
  - `font=Hack Nerd Font:pixelsize=10, Noto Color Emoji:pixelsize=10`
  - `font-bold=Hack Nerd Font:weight=bold:pixelsize=10`
  - `font-italic=Hack Nerd Font:slant=italic:pixelsize=10`
  - `font-bold-italic=Hack Nerd Font:weight=bold:slant=italic:pixelsize=10`
  - `pad=0x0`
  - `dpi-aware=no`
  - `font-size-adjustment=1px`

## Notes
- Theme include path must be absolute or start with `~/` in Foot; the installer writes `include=~/.config/foot/themes/<file>.ini` under `[main]`.
- Aliases replace the `include=` line with `sed`. If you have custom includes, ensure a single `include=` line exists in `[main]` or at top-level.
- If the font family differs on your system, adjust `font` entries in `~/.config/foot/foot.ini`. Use `fc-list : family style` to inspect available fonts.
- If you run Foot in server mode (`foot --server` with `footclient`), open a new window for changes to take effect.

## Troubleshooting
- Aliases not found:
  - Run `source ~/.bashrc` or `source ~/.zshrc`.
- Font missing or not detected:
  - Re-run the installer or change `font=...` to any installed Nerd Font; verify with `fc-list`.
- Theme change not visible:
  - Ensure `include=...` exists in `[main]` and points to a valid theme file; open a new Foot window.
