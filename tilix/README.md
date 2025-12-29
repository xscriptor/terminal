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
- Location: [tilix/themes](./themes/)
- Format: `.json` Tilix color schemes
- Available themes include:
  - x, madrid, lahabana, seul, miami, paris, tokio, oslo,
    helsinki, berlin, london, praha, bogota

## Notes
- The palette maps standard color slots (color0–color15).
- Background, foreground, and cursor colors are defined per theme.
