<h1 align="center">Terminal Xscriptor</h1>

<div align="center">

![android](https://xscriptordev.github.io/badges/os/android.svg) ![linux](https://xscriptordev.github.io/badges/os/linux.svg) ![macos](https://xscriptordev.github.io/badges/os/macos.svg) ![windows](https://xscriptordev.github.io/badges/os/windows.svg) ![mit](https://xscriptordev.github.io/badges/licenses/mit.svg)

My own collection of terminal themes and color schemes designed for a consistent look & feel across Windows, MacOs & Linux.

</div>

<p align="center"><img src="./assets/icon.png" width="100" alt="Xscriptor logo" /></p>

# Previews

<p align="center">
  <a href="./powershell/previews/preview2.jpg">
    <img src="./powershell/previews/preview2.jpg" alt="Main preview" width="850"/>
  </a>
</p>

<details>
  <summary>More previews</summary>

  <table>
    <tr>
      <td align="center">
        <a href="./ghostty/previews/preview1.jpg">
          <img src="./ghostty/previews/preview1.jpg" alt="Preview 2" width="380"/>
        </a>
      </td>
      <td align="center">
        <a href="./kitty/previews/preview2.jpg">
          <img src="./kitty/previews/preview2.jpg" alt="Preview 3" width="380"/>
        </a>
      </td>
      <td align="center">
        <a href="./ptyxis/previews/preview2.jpg">
          <img src="./ptyxis/previews/preview2.jpg" alt="Preview 3" width="380"/>
        </a>
      </td>
      <td align="center">
        <a href="./konsole/previews/preview2.jpg">
          <img src="./konsole/previews/preview2.jpg" alt="Preview 3" width="380"/>
        </a>
      </td>
    </tr>
  </table>
</details>


## All the supported terminals:

- To make this easy to install, I've created a script for each terminal, you can execute remote install using `wget` or `curl` or download the script and run it manually. You can see the details in each terminal's README.

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


## Contributions

- Contributions to the code, suggestions, and additional themes are welcome.
- To propose changes, open an issue or pull request in this repository.
- See the license in [LICENSE](./LICENSE).
