# Xscriptor Tilix

Quickly use the Xscriptor color themes with Tilix by importing the provided JSON scheme files.

## Quick Install
- Create the user schemes folder and copy the themes:

```bash
mkdir -p ~/.config/tilix/schemes
cp /path/to/terminal/tilix/themes/*.json ~/.config/tilix/schemes
```

- Select the theme in Tilix:
  - Open Tilix → Preferences → Default → Color → Color scheme → choose your theme

## Themes
- Location: [tilix/themes](file:///Users/xscriptor/Documents/repos/xscriptordev/terminal/tilix/themes)
- Format: `.json` Tilix color schemes
- Available themes include:
  - xscriptor-theme, xscriptor-theme-light, x-retro, x-summer-night, x-candy-pop,
    x-dark-one, x-dark-colors, x-sense, x-nord, x-nord-inverted,
    x-greyscale, x-greyscale-inverted, x-persecution

## Notes
- The palette maps standard color slots (color0–color15).
- Background, foreground, and cursor colors are defined per theme.
