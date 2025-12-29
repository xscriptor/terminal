# Xscriptor PowerShell / Windows Terminal / WSL Themes

---

## Previews

<p align="center">
  <img src="./previews/preview2.jpg" alt="Preview" width="900"/>
</p>
<p align="center">
  <img src="./previews/preview3.jpg" alt="Preview" width="900"/>
</p>
<p align="center">
  <img src="./previews/preview.png" alt="Preview" width="400"/>
  <img src="./previews/preview1.png" alt="Preview" width="400"/>
</p>
<p align="center">
<img src="./previews/preview4.jpg" alt="Preview" width="900"/>
</p>


## Quick Install

- Open PowerShell
- Run:
  ```powershell
  Set-ExecutionPolicy Bypass -Scope Process -Force
  .\powershell\install.ps1
  ```
- This imports all themes from [themes](https://github.com/xscriptordev/terminal/tree/main/powershell/themes) into Windows Terminal and sets “x” for PowerShell profiles
- Restart Windows Terminal (or PowerShell if launched inside it)

## Remote Install

- Remote install (Windows PowerShell 5.1):
  ```powershell
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Set-ExecutionPolicy Bypass -Scope Process -Force
  iex (iwr 'https://raw.githubusercontent.com/xscriptordev/terminal/main/powershell/install.ps1' -UseBasicParsing).Content
  ```
- Remote install (PowerShell 7+):
  ```powershell
  Set-ExecutionPolicy Bypass -Scope Process -Force
  irm 'https://raw.githubusercontent.com/xscriptordev/terminal/main/powershell/install.ps1' -Raw | iex
  ```
- Default one-liner:
  ```powershell
  Set-ExecutionPolicy Bypass -Scope Process -Force
  irm https://raw.githubusercontent.com/xscriptordev/terminal/main/powershell/install.ps1 | iex
  ```
- Alternative (PS 5.1, download to TEMP and run):
  ```powershell
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Set-ExecutionPolicy Bypass -Scope Process -Force
  $localPath = "$env:TEMP\install-xscriptor.ps1"
  Invoke-WebRequest 'https://raw.githubusercontent.com/xscriptordev/terminal/main/powershell/install.ps1' -OutFile $localPath -UseBasicParsing
  & $localPath
  ```
- With a specific scheme:
  ```powershell
  Set-ExecutionPolicy Bypass -Scope Process -Force
  $u='https://raw.githubusercontent.com/xscriptordev/terminal/main/powershell/install.ps1'; $p="$env:TEMP\\install.ps1"; iwr $u -UseBasicParsing -OutFile $p; & $p -SetSchemeName 'xoslo'
  ```
- Notes:
  - The installer detects your settings.json automatically (Store/WinGet)
  - If the local themes directory is not present, it downloads themes from the repo and imports them

### Choose a specific theme
- Pass the exact scheme name:
  ```powershell
  Set-ExecutionPolicy Bypass -Scope Process -Force
  .\powershell\install.ps1 -SetSchemeName "xoslo"
  ```
- Available names include:
  - x, xmadrid
  - xlahabana, xseul
  - xmiami, xparis, xtokio
  - xoslo, xhelsinki
  - xberlin, xlondon
  - xpraga, xbogota

## Manual Install

- Open Windows Terminal settings.json:
  - Store path: `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`
  - WinGet path: `%LOCALAPPDATA%\Microsoft\Windows Terminal\settings.json`
- Copy the “schemes” object from any file in [themes](https://github.com/xscriptordev/terminal/tree/main/powershell/themes) into the top-level `"schemes": []` array of your settings.json
- In your PowerShell profile, set:
  ```json
  "colorScheme": "x"
  ```
- Optionally set defaults:
  ```json
  "profiles": { "defaults": { "colorScheme": "x" } }
  ```
- Save and restart Windows Terminal

## Themes

- Dark:
  - [x.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/x.json)
  - [xlahabana.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/xlahabana.json)
  - [xseul.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/xseul.json)
  - [xmiami.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/xmiami.json)
  - [xparis.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/xparis.json)
  - [xtokio.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/xtokio.json)
  - [xpraga.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/xpraga.json)
  - [xbogota.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/xbogota.json)
- Light:
  - [xmadrid.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/xmadrid.json)
- Nord:
  - [xoslo.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/xoslo.json)
  - [xhelsinki.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/xhelsinki.json)
- Greyscale:
  - [xberlin.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/xberlin.json)
  - [xlondon.json](https://github.com/xscriptordev/terminal/blob/main/powershell/themes/xlondon.json)

## Notes

- The installer automatically detects settings.json location (Store/WinGet)
- It replaces existing schemes with the same name to keep them in sync
- Set profiles.defaults.colorScheme to apply your choice to all new profiles
