# Xscriptor Alacritty Themes

This folder contains a set of Alacritty themes and a pre-tuned `alacritty.toml` that imports the default Xscriptor theme and includes a highly customized configuration (window opacity, decorations, fonts, cursor, scrolling, selection, mouse, shell).

## Files
- `alacritty.toml`: Base config that imports `themes/xscriptor-theme.toml` by default.
- `install.sh`: Installs themes and configuration, and sets shell aliases for quick theme switching.
- `themes/*.toml`: Theme files ready to be imported by Alacritty:
  - `xscriptor-theme.toml`
  - `xscriptor-theme-light.toml`
  - `x-retro.toml`
  - `x-dark-candy.toml`
  - `x-candy-pop.toml`
  - `x-sense.toml`
  - `x-summer-night.toml`
  - `x-nord.toml`
  - `x-nord-inverted.toml`
  - `x-greyscale.toml`
  - `x-greyscale-inverted.toml`
  - `x-dark-colors.toml`
  - `x-persecution.toml`

## Requirements
- Alacritty with TOML config support.
- `sed`, `zsh` or `bash`.
- A Nerd Font installed, specifically `AnonymicePro Nerd Font` (config uses it as default).

## Installation
- Run the installer from this folder:
  - `./install.sh`
- What it does:
  - Copies all `themes/*.toml` into `~/.config/alacritty/themes`.
  - Backs up any existing config to `~/.config/alacritty/alacritty.toml.bak.<timestamp>`.
  - Installs the provided `alacritty.toml` to `~/.config/alacritty/alacritty.toml`.
  - Ensures the import line is set to `themes/xscriptor-theme.toml`.
  - Appends shell aliases to `~/.bashrc` and `~/.zshrc`.
- Reload your shell session:
  - `source ~/.bashrc` or `source ~/.zshrc`

## Switching Themes
- Generic function:
  - `alax <theme_basename>`
  - Example: `alax x-nord` sets `import = ["themes/x-nord.toml"]`.
- Ready-to-use aliases:
  - `alaxscriptor`, `alaxscriptorlight`
  - `alaxsense`, `alaxsummer`, `alaxretro`
  - `alaxdark`, `alaxdarkcandy`, `alaxcandy`, `alaxcandypop`
  - `alaxnord`, `alaxnordinverted`
  - `alaxgreyscale`, `alaxgreyscaleinv`
  - `alaxpersecution`
- Changes apply immediately thanks to live config reload.

## Default Configuration Highlights
- Import: `import = ["themes/xscriptor-theme.toml"]`
- Window:
  - `opacity = 0.92`
  - `decorations = "None"`
  - `dynamic_padding = true`, `padding.x = 6`, `padding.y = 6`
  - `startup_mode = "Windowed"`, dynamic title enabled
- Font:
  - `AnonymicePro Nerd Font`, `size = 13.0`
  - Fallbacks: `Symbols Nerd Font`, `Noto Color Emoji`, `DejaVu Sans Mono`
- Cursor:
  - `Beam`, blinking on, thickness `0.12`
- Scrolling:
  - `history = 10000`, `multiplier = 3`
- Selection:
  - `save_to_clipboard = true`
- Mouse:
  - `hide_when_typing = true`
- Shell:
  - `zsh` (`/usr/bin/zsh`, args `-l`)
- Env:
  - `TERM = "alacritty"`, `COLORTERM = "truecolor"`

## Notes
- Theme import path is relative to `~/.config/alacritty/alacritty.toml`. The installer sets it to `themes/<file>.toml`.
- Aliases replace the `import = [...]` line with `sed`. If you have custom imports, ensure a single `import = [...]` line exists.
- If the font family name differs on your system, update `[font]` in `~/.config/alacritty/alacritty.toml` accordingly.

## Troubleshooting
- Aliases not found:
  - Run `source ~/.bashrc` or `source ~/.zshrc`.
- Font missing:
  - Install `AnonymicePro Nerd Font`, or change `font.normal.family` to a font available on your system (`fc-list : family style` can help).
- Theme change not visible:
  - Ensure `live_config_reload = true` is present in the config.

