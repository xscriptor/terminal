# Xscriptor Warp Themes

Quickly install a curated set of Warp themes and use them from Warp’s Appearance settings.

## Quick Install
- One‑liner:

```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/warp/install.sh | sh
# or
curl -fsSL https://raw.githubusercontent.com/xscriptordev/terminal/main/warp/install.sh | sh
```

## What It Does
- Copies all theme YAML files into Warp’s themes directory.
- Uses local files if present; otherwise downloads from the repository.
- Does not change your current theme automatically — select it in Warp.

## Usage
- Open Warp → Settings → Appearance → Theme
- Pick any of the installed themes (e.g., “x”, “madrid”, “oslo”, “lahabana”).
- Restart Warp if the new themes don’t appear immediately.

## Notes
- Requires `curl` or `wget`.
- If running the installer from a cloned repo, it will copy local `warp/themes/*.yaml`.
- Remote install downloads the same set directly from GitHub.
