# Xscriptor Terminator

Minimal Terminator setup with a complete config and themes.

## Quick Install
- One‑liner:

```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/terminator/install.sh | bash
```

or
- From repo: `chmod +x install.sh && ./install.sh`

## What You Get
- Writes `~/.config/terminator/config` (local or remote).
- Borderless window and no per-terminal titlebar.
- Transparent background (`background_darkness ≈ 0.85`).
- Default 2×2 layout using `xscriptor-theme`.
- All Xscriptor color profiles included (nord, greyscale, etc.).

## Use
- Start Terminator; default layout and theme apply.
- Change theme: edit `~/.config/terminator/config` (profile in `[layouts]` or `[[default]]`).
- Optional flags: `terminator -b -m -l default`.

## Notes
- Linux: installer can install Terminator; macOS: config only.
- Restart Terminator after editing the config.
