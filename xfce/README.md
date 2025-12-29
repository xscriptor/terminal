# Xscriptor XFCE Terminal

Install XFCE Terminal color schemes and apply them from Presets.

## Quick Install
- From the repository:

```bash
chmod +x xfce/install.sh && xfce/install.sh
```

- Remote one‑liner:

```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/xfce/install.sh | sh
# or
curl -fsSL https://raw.githubusercontent.com/xscriptordev/terminal/main/xfce/install.sh | sh
```

## What It Does
- Copies all `.theme` files to `~/.local/share/xfce4/terminal/colorschemes`.
- Uses local themes if present; otherwise downloads from the repository.
- Attempts to install `xfce4-terminal` and `curl/wget` if missing (based on your package manager).
 - City-based names are supported and map to legacy scheme files:
   - `x` → `xscriptor-theme`, `xmadrid` → `xscriptor-theme-light`, `xlahabana` → `x-retro`, `xseul` → `x-dark-candy`, `xmiami` → `x-candy-pop`, `xparis` → `x-sense`, `xtokio` → `x-summer-night`, `xoslo` → `x-nord`, `xhelsinki` → `x-nord-inverted`, `xberlin` → `x-greyscale`, `xlondon` → `x-greyscale-inverted`, `xpraga` → `x-dark-colors`, `xbogota` → `x-persecution`.

## Uninstall
- Remote one‑liner:
```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/xfce/uninstall.sh | sh
# or
curl -fsSL https://raw.githubusercontent.com/xscriptordev/terminal/main/xfce/uninstall.sh | sh
```
- Local:
```bash
chmod +x uninstall.sh && ./uninstall.sh
```

## Apply a Theme
- XFCE Terminal → Edit → Preferences → Colors → Presets → select the scheme.
