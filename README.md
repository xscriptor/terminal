# Xscriptor Terminal schemes

A curated collection of **terminal themes and color schemes** designed for a consistent look & feel across **Windows**, **MacOs** & **Linux**.  
This repo includes configurations for PowerShell, Kitty, Gnome Terminal, Konsole, XFCE, and more.

## Supported:

- [Alacritty](./alacritty/README.md)

  ```bash
  wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/alacritty/install.sh | bash
  ```

- [Foot](./foot/README.md)

  ```bash
  wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/foot/install.sh | bash
  ```

- [Ghostty](./ghostty/README.md)

  ```bash
  wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/ghostty/install.sh | bash
  ```

- [GNOME Terminal](./gnome-terminal/README.md)

  ```bash
  wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/gnome-terminal/install.sh | bash
  ```

- [Hyper](./hyper/README.md)

  ```bash
  wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/hyper/install.sh | bash
  ```

- [iTerm2](./iterm/README.md)

  ```bash
  wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/iterm/install.sh | bash
  ```

- [Kitty](./kitty/README.md)

  ```bash
  wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/kitty/install.sh | bash
  ```

- [Konsole](./konsole/README.md)

  ```bash
  wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/konsole/install.sh | bash
  ```

- [MobaXterm (Windows)](./mobaxterm/README.md)

- [PowerShell (Windows)](./powershell/README.md)

  Remote install (Windows PowerShell 5.1):
  
  ```powershell
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Set-ExecutionPolicy Bypass -Scope Process -Force
  iex (iwr 'https://raw.githubusercontent.com/xscriptordev/terminal/main/powershell/install.ps1' -UseBasicParsing).Content
  ```

  Remote install (PowerShell 7+):
  
  ```powershell
  Set-ExecutionPolicy Bypass -Scope Process -Force
  irm 'https://raw.githubusercontent.com/xscriptordev/terminal/main/powershell/install.ps1' -Raw | iex
  ```

  Default one-liner:
  
  ```powershell
  Set-ExecutionPolicy Bypass -Scope Process -Force
  irm https://raw.githubusercontent.com/xscriptordev/terminal/main/powershell/install.ps1 | iex
  ```

- [Ptyxis](./ptyxis/README.md)

  ```bash
  wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/ptyxis/install.sh | bash
  ```

- [PuTTY (Windows)](./putty/README.md)

- [Terminal.app (macOS)](./terminal.app/README.md)

- [Terminator](./terminator/README.md)

  ```bash
  wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/terminator/install.sh | bash
  ```

- [Termux (Android)](./termux/README.md)

  ```bash
  wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/termux/install.sh | bash
  ```

- [Tilix](./tilix/README.md)

- [Warp](./warp/README.md)

  ```bash
  wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/warp/install.sh | bash
  ```

- [WezTerm](./wezterm/README.md)

  ```bash
  wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/wezterm/install.sh | bash
  ```

- [XFCE Terminal](./xfce/README.md)

  ```bash
  wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/xfce/install.sh | bash
  ```

Note: In some directories you'll find an `install.sh` script you can run to simplify theme installation for the terminal you use.

## *Previews*:

<p align="center">
  <img src="./assets/previews/preview.png" width="800"/>
</p>

## Contributions

- Contributions to the code, suggestions, and additional themes are welcome.
- To propose changes, open an issue or pull request in this repository.
- See the license in [LICENSE](./LICENSE).
