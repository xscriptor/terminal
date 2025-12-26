# Windows PowerShell / Windows Terminal Themes

---

## Previews

<p align="center">
  <img src="./previews/preview.png" alt="Preview" width="350"/>
  <img src="./previews/preview1.png" alt="Preview" width="500"/>
</p>

## Quick Install

- Open PowerShell
- Run:
  ```powershell
  Set-ExecutionPolicy Bypass -Scope Process -Force
  .\powershell\install.ps1
  ```
- This imports all themes from [themes](https://github.com/xscriptordev/terminal/tree/main/powershell/themes) into Windows Terminal and sets “Xscriptor” for PowerShell profiles
- Restart Windows Terminal (or PowerShell if launched inside it)

### Choose a specific theme
- Pass the exact scheme name:
  ```powershell
  Set-ExecutionPolicy Bypass -Scope Process -Force
  .\powershell\install.ps1 -SetSchemeName "X Nord"
  ```
- Available names include:
  - Xscriptor, Xscriptor Light
  - X Retro, X Dark One
  - X Candy Pop, X Sense, X Summer Night
  - X Nord, X Nord Inverted
  - X Greyscale, X Greyscale Inverted
  - X Dark Colors, X Persecution

## Manual Install

- Open Windows Terminal settings.json:
  - Store path: `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`
  - WinGet path: `%LOCALAPPDATA%\Microsoft\Windows Terminal\settings.json`
- Copy the “schemes” object from any file in [themes](https://github.com/xscriptordev/terminal/tree/main/powershell/themes) into the top-level `"schemes": []` array of your settings.json
- In your PowerShell profile, set:
  ```json
  "colorScheme": "Xscriptor"
  ```
- Optionally set defaults:
  ```json
  "profiles": { "defaults": { "colorScheme": "Xscriptor" } }
  ```
- Save and restart Windows Terminal

## Themes

- Dark:
  - [xscriptor-theme.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/xscriptor-theme.json)
  - [x-retro.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/x-retro.json)
  - [x-dark-one.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/x-dark-one.json)
  - [x-candy-pop.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/x-candy-pop.json)
  - [x-sense.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/x-sense.json)
  - [x-summer-night.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/x-summer-night.json)
  - [x-dark-colors.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/x-dark-colors.json)
  - [x-persecution.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/x-persecution.json)
- Light:
  - [xscriptor-theme-light.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/xscriptor-theme-light.json)
- Nord:
  - [x-nord.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/x-nord.json)
  - [x-nord-inverted.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/x-nord-inverted.json)
- Greyscale:
  - [x-greyscale.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/x-greyscale.json)
  - [x-greyscale-inverted.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/x-greyscale-inverted.json)

## Notes

- The installer automatically detects settings.json location (Store/WinGet)
- It replaces existing schemes with the same name to keep them in sync
- Set profiles.defaults.colorScheme to apply your choice to all new profiles
