# Xscriptor Hyper Themes

Theme plugin for Hyper using `decorateConfig`, with a curated set of palettes aligned with the rest of this repository.

## Files
- `index.js`: Plugin entry. Implements `decorateConfig` and selects a theme.
- `themes/*.js`: Theme palettes:
  - `xscriptor-theme`
  - `xscriptor-theme-light`
  - `x-retro`
  - `x-dark-one`
  - `x-candy-pop`
  - `x-sense`
  - `x-summer-night`
  - `x-nord`
  - `x-nord-inverted`
  - `x-greyscale`
  - `x-greyscale-inverted`
  - `x-dark-colors`
  - `x-persecution`
- `package.json`: Plugin metadata for publishing.
- `install.sh`: Installs the plugin locally and enables it in Hyper's config.

## Requirements
- Hyper installed.
- `bash`/`zsh` and `sed` available to run the installer.

## Installation
- One-liner:
```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/hyper/install.sh | bash
```
or
- Local install:
```bash
cd hyper
chmod +x install.sh && ./install.sh
```

What the installer does:
- Detects the correct Hyper config path (macOS, Linux, Windows).
- Copies `index.js`, `package.json` and all `themes/*.js` to Hyper’s local plugins folder:
  - `~/<App Support>/Hyper/.hyper_plugins/local/hyper-xscriptor-themes`
- Adds `localPlugins: ['hyper-xscriptor-themes']` to your `.hyper.js`.
- Ensures `config: { xscriptorTheme: 'xscriptor-theme' }` is present.
- Adds shell aliases with prefix `hyperx` to `~/.bashrc` and `~/.zshrc` for fast switching.

## Switching Themes
- In your Hyper config (`.hyper.js`) set the theme inside the `config` block:
```js
module.exports = {
  config: {
    xscriptorTheme: 'x-nord' // choose any from the list above
  },
  localPlugins: ['hyper-xscriptor-themes']
}
```
- Alternatively, set an environment variable before launching Hyper:
```bash
export XSCRIPTOR_HYPER_THEME=x-nord
```

## Aliases
- The installer adds shell aliases to switch quickly:
  - `hyperxscriptor`, `hyperxscriptorlight`, `hyperxretro`, `hyperxdarkone`, `hyperxcandypop`, `hyperxsense`, `hyperxsummer`, `hyperxnord`, `hyperxnordinverted`, `hyperxgreyscale`, `hyperxgreyscaleinv`, `hyperxdark`, `hyperxpersecution`
- Usage example:
  - `hyperxnord` → writes `xscriptorTheme: 'x-nord'` to your `.hyper.js` and opens Hyper automatically (CLI or `open -a Hyper` on macOS).
  - Reload your shell if aliases do not appear: `source ~/.bashrc` or `source ~/.zshrc`.

## Uninstall
- Remote one‑liner:
```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/hyper/uninstall.sh | bash
# or
curl -fsSL https://raw.githubusercontent.com/xscriptordev/terminal/main/hyper/uninstall.sh | bash
```
- Local:
```bash
chmod +x uninstall.sh && ./uninstall.sh
```

## Notes
- The plugin uses `decorateConfig(config)` and merges the selected theme into the user’s `config` object.
- Palettes map to Hyper’s ANSI 16 colors consistently across terminals in this repo.
- If your `.hyper.js` already has content, the installer appends the plugin safely. Review changes if you keep a heavily customized config.
- Config locations (per Hyper docs):
  - macOS: `~/Library/Application Support/Hyper/.hyper.js`
  - Linux: `~/.config/Hyper/.hyper.js` (or `$XDG_CONFIG_HOME/Hyper/.hyper.js`)
  - Windows: `%APPDATA%/Hyper/.hyper.js`

## Troubleshooting
- Plugin not loaded:
  - Ensure `localPlugins` contains `hyper-xscriptor-themes`. Restart Hyper.
- Theme not applied:
  - Confirm `config.xscriptorTheme` is set and matches one of the provided names.
- Broken config after install:
  - Check `.hyper.js` syntax. Restore from a backup if needed and re-run the installer.
