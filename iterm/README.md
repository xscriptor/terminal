# Xscriptor iTerm2 Themes

This folder contains iTerm2 color presets for the Xscriptor themes. Presets are importable `.itermcolors` files that add schemes to iTerm2’s Color Presets.

## Files
Location: `./themes`
- `xscriptor-theme.itermcolors`
- `xscriptor-theme-light.itermcolors`
- `x-retro.itermcolors`
- `x-summer-night.itermcolors`
- `x-candy-pop.itermcolors`
- `x-dark-candy.itermcolors`
- `x-sense.itermcolors`
- `x-nord.itermcolors`
- `x-nord-inverted.itermcolors`
- `x-greyscale.itermcolors`
- `x-greyscale-inverted.itermcolors`
- `x-dark-colors.itermcolors`
- `x-persecution.itermcolors`

## Requirements
- macOS with iTerm2 installed
- `curl` or `wget`

## Installation
- One-liner:
```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/iterm/install.sh | bash
```
or
- Local run:
```bash
cd iterm
chmod +x install.sh && ./install.sh
```

What it does:
- Uses local `.itermcolors` files from `./themes` if present, otherwise downloads them from the repository.
- Imports each preset by opening it with the system (`open`), adding it to iTerm2’s Color Presets.
- Does not modify your iTerm2 profiles or preferences; selection is manual.

## Using the Themes
- Open iTerm2 → Preferences → Profiles → Colors.
- Click `Color Presets…` → select the imported preset.
- Optional: set the profile as default under `Profiles`.

## Notes
- iTerm2 stores color settings per profile; presets are imported then applied manually to a profile.
- If import does not appear, quit and reopen iTerm2 after running the installer.
- For preset details and behavior, see iTerm2 documentation.
