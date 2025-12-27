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

## Apply a Theme
- XFCE Terminal → Edit → Preferences → Colors → Presets → select the scheme.
