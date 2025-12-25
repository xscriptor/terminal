# Xscriptor GNOME Terminal Themes

This folder contains GNOME Terminal profiles (via dconf) and an installer that loads Xscriptor themes, ensures dependencies, and adds aliases to quickly switch the default profile.

## Files
- `install.sh`: Installs profiles and adds aliases for switching the default profile.
- `themes/*.sh`: Optional scripts that apply colors to the default profile using dconf.
- `dconf/*.dconf`: Profile dumps ready to import with `dconf load`:
  - `xscriptor-theme.dconf`
  - `xscriptor-theme-light.dconf`
  - `x-retro.dconf`
  - `x-dark-candy.dconf`
  - `x-candy-pop.dconf`
  - `x-sense.dconf`
  - `x-summer-night.dconf`
  - `x-nord.dconf`
  - `x-nord-inverted.dconf`
  - `x-greyscale.dconf`
  - `x-greyscale-inverted.dconf`
  - `x-dark-colors.dconf`
  - `x-persecution.dconf`

## Requirements
- GNOME Terminal.
- `dconf` and `gsettings`.
- `sed`, `bash` or `zsh`.
- `curl` or `wget`.

## Installation
- One-liner:
```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/gnome-terminal/install.sh | bash
```

or

- Download the repo, go to the folder and run the installer:
  - `chmod +x install.sh && ./install.sh`
- What the installer does:
  - Detects your package manager and installs missing dependencies (`dconf-cli`, `glib2/gsettings`, `sed`, `curl/wget`).
  - Imports profiles from `dconf/*.dconf` (local or remote if not present locally).
  - Ensures all theme UUIDs are listed in `org.gnome.Terminal.ProfilesList`.
  - Sets Xscriptor profile as the default.
  - Adds shell aliases to change the default active profile.

## Aliases
- After installation, the following aliases are added:
  - `gtxscriptor`, `gtxscriptorlight`, `gtxretro`, `gtxdark`, `gtxdarkcandy`, `gtxcandy`, `gtxcandypop`, `gtxsense`, `gtxsummer`, `gtxnord`, `gtxnordinverted`, `gtxgreyscale`, `gtxgreyscaleinv`, `gtxpersecution`
- Usage:
  - `gtxscriptor` → sets the Xscriptor profile as the default profile in GNOME Terminal.
- Reload your shell:
  - `source ~/.bashrc` or `source ~/.zshrc`

## Notes
- Profiles are stored in dconf under `/org/gnome/terminal/legacy/profiles:/`.
- You can select the profile manually in GNOME Terminal: Preferences → Profiles.
- If profiles don’t appear, restart GNOME Terminal, or verify that `dconf` is available.

## Troubleshooting
- Aliases not available:
  - Reload your shell rc file (`~/.bashrc`/`~/.zshrc`) or start a new session.
- Profiles not visible:
  - Ensure `dconf load` ran without errors; check permissions and paths.
- Changes not applied:
  - Verify the default profile with `gsettings get org.gnome.Terminal.ProfilesList default`.
