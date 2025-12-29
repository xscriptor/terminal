# Xscriptor Kitty Themes

This folder contains Kitty themes and a tuned `config` that sets the default Xscriptor theme and a predictable setup (hidden title bar, font, window padding, opacity, and mouse clipboard behavior).

## Files
- `config`: Base Kitty configuration that includes `themes/x.conf` and other defaults.
- `install.sh`: Installs themes and configuration, ensures dependencies, and adds shell aliases for fast theme switching.
- `themes/*.conf`: Theme files ready to be used by Kitty:
  - `x.conf`
  - `xmadrid.conf`
  - `xlahabana.conf`
  - `xseul.conf`
  - `xmiami.conf`
  - `xparis.conf`
  - `xtokio.conf`
  - `xoslo.conf`
  - `xhelsinki.conf`
  - `xberlin.conf`
  - `xlondon.conf`
  - `xpraga.conf`
  - `xbogota.conf`

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
- Writes `~/.config/kitty/kitty.conf` and includes `themes/x.conf` by default.
- Adds aliases to your shell for quick theme switching.

## Uninstall
- Remote one‑liner:
```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/kitty/uninstall.sh | bash
# or
curl -fsSL https://raw.githubusercontent.com/xscriptordev/terminal/main/kitty/uninstall.sh | bash
```
- Local:
```bash
chmod +x uninstall.sh && ./uninstall.sh
```

## Default Config
- Includes `themes/x.conf` by default.
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
- The installer adds shell aliases to switch quickly:
  - `kixx`, `kixmadrid`, `kixlahabana`, `kixseul`, `kixmiami`, `kixparis`, `kixtokio`, `kixoslo`, `kixhelsinki`, `kixberlin`, `kixlondon`, `kixpraga`, `kixbogota`
- Usage:
- `kixx` → sets `include themes/x.conf` in `~/.config/kitty/kitty.conf`
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
