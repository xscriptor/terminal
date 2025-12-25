# Xscriptor Kitty Themes

This folder contains Kitty themes and a tuned `config` that sets the default Xscriptor theme and a predictable setup (hidden title bar, font, window padding, opacity, and mouse clipboard behavior).

## Files
- `config`: Base Kitty configuration that includes `themes/xscriptor-theme.conf` and other defaults.
- `install.sh`: Installs themes and configuration, ensures dependencies, and adds shell aliases for fast theme switching.
- `themes/*.conf`: Theme files ready to be used by Kitty:
  - `xscriptor-theme.conf`
  - `xscriptor-theme-light.conf`
  - `x-retro.conf`
  - `x-dark-one.conf`
  - `x-candy-pop.conf`
  - `x-sense.conf`
  - `x-summer-night.conf`
  - `x-nord.conf`
  - `x-nord-inverted.conf`
  - `x-greyscale.conf`
  - `x-greyscale-inverted.conf`
  - `x-dark-colors.conf`
  - `x-persecution.conf`

## Requirements
- Kitty installed.
- `sed`, `bash` or `zsh`.
- `fontconfig` (`fc-list`), `curl` or `wget`, `unzip`.
- A Nerd Font installed, specifically `Hack Nerd Font` (installer tries to install it automatically).

## Installation
- One-liner:
```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/kitty/install.sh | bash
```

or

- Download the repo, go to the folder and run the installer:
  - `chmod +x install.sh && ./install.sh`
- What the installer does:
  - Detects your package manager and installs any missing dependencies (`kitty`, `sed`, `fontconfig`, `curl/wget`, `unzip`).
  - Installs `Hack Nerd Font` automatically (Homebrew on macOS; download + extract on Linux).
  - Copies all themes to `~/.config/kitty/themes`.
  - Writes `~/.config/kitty/kitty.conf` and includes `themes/xscriptor-theme.conf` by default.
  - Adds aliases to your shell for quick theme switching.

## Default Config
- Includes `themes/xscriptor-theme.conf` by default.
- Hides window decorations and tab bar; minimal borders.
- Sets background opacity to `0.85` with dynamic opacity enabled.
- Window padding set to `8`.
- Font family `Hack Nerd Font` with `font_size 10.0`.
- Mouse and clipboard:
  - `copy_on_select yes`
  - Clipboard control enabled for primary and system clipboard.
  - Mouse mappings for select/word/line, paste from selection/clipboard.
- URL handling:
  - `detect_urls yes`, `open_url_with default`, `url_style curly`.

## Aliases
- After installation, these aliases are added to your shell:
  - `kixscriptor`, `kixscriptorlight`, `kixretro`, `kixdarkone`, `kixcandypop`, `kixsense`, `kixsummer`, `kixnord`, `kixnordinverted`, `kixgreyscale`, `kixgreyscaleinv`, `kixdark`, `kixpersecution`
- Usage:
  - `kixscriptor` → sets `include themes/xscriptor-theme.conf` in `~/.config/kitty/kitty.conf`
- Make sure to reload your shell:
  - `source ~/.bashrc` or `source ~/.zshrc`
- Reload Kitty configuration:
  - `Ctrl+Shift+F5`

## Notes
- Kitty looks up included files relative to the `kitty.conf` location; themes are expected in `~/.config/kitty/themes`.
- To change font family, run `kitty +list-fonts` and update `font_family` accordingly.
- If theme changes do not apply, ensure the `include themes/<name>.conf` line is present and reload the config.

## Troubleshooting
- Aliases not available:
  - Reload your shell rc file or restart the terminal.
- Font not detected:
  - Re-run the installer or set `font_family` to a Nerd Font you already have; confirm with `kitty +list-fonts`.
- Theme change not visible:
  - Ensure the theme file exists in `~/.config/kitty/themes` and the `include` line references it; reload Kitty or open a new window.
