# Xscriptor Theme for GNOME Terminal

A sleek dark theme for GNOME Terminal with optimized colors for coding and terminal work.

## Installation

Run the installation script:

```bash
chmod +x install.sh
./install.sh
```

The script will:
- Create a new terminal profile with X theme colors
- Set it as the default profile (optional)
- Apply all theme settings automatically

## Manual Installation

1. Import the theme configuration:
   ```bash
   dconf load /org/gnome/terminal/legacy/profiles:/ < xscriptor-theme-gnome.dconf
   ```

2. Open GNOME Terminal preferences and select the "Xscriptor Theme" profile

## Features

- Dark background with high contrast
- Carefully selected 16-color palette
- Optimized for readability
- Compatible with most terminal applications

## Requirements

- GNOME Terminal
- `dconf` utility

Restart GNOME Terminal to apply changes.