# Xscriptor Theme for Kitty Terminal

A modern and elegant dark theme for Kitty Terminal with carefully selected colors for optimal readability and visual appeal.

<p align="center">
  <img src="./preview.png" alt="Demostración" width="600"/>
</p>

## Installation:

### Automatic Installation

Run the installation script from the theme directory:

```bash
chmod +x install.sh
./install.sh
```

The script will:
- Detect your Kitty configuration directory
- Create a backup of existing configuration (if any)
- Install the theme configuration
- Update your `kitty.conf` to include the theme

### Manual Installation

1. Copy `xscriptor-theme-kitty.conf` to your Kitty config directory:
   - **Linux/macOS**: `~/.config/kitty/`
   - **Windows**: `%APPDATA%\kitty\`

2. Add this line to your `kitty.conf`:
   ```
   include xscriptor-theme-kitty.conf
   ```

3. Reload Kitty configuration: `Ctrl+Shift+F5`

*you can also copy the script and paste inside of kitty.conf*

---

## Theme Settings

The theme includes:
- **Background opacity**: 85% transparency
- **Dynamic opacity**: Adjustable with `Ctrl+Shift+A` (increase) / `Ctrl+Shift+X` (decrease)
- **Window decorations**: Titlebar hidden for clean look
- **Copy on select**: Enabled for improved workflow

