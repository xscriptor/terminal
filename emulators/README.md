<h1 align="center">Emulators</h1>

<p>This section contains the terminal emulator themes, installers, and per-terminal setup notes. Use the universal installer for a guided setup, or jump straight to a specific terminal below.</p>

<h2 align="center">Universal Installer</h2>

<pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/install.sh | bash</code></pre>

<p>Windows-only terminals (PowerShell, MobaXterm, PuTTY) use their own install or import steps. See each terminal README for details.</p>

<details>
  <summary>View Installation Instructions for Supported Terminals</summary>

  <ul>
    <li>
      <a href="./alacritty/README.md">Alacritty</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/alacritty/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./foot/README.md">Foot</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/foot/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./ghostty/README.md">Ghostty</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/ghostty/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./gnome-terminal/README.md">GNOME Terminal</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/gnome-terminal/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./hyper/README.md">Hyper</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/hyper/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./iterm/README.md">iTerm2</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/iterm/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./kitty/README.md">Kitty</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/kitty/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./konsole/README.md">Konsole</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/konsole/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./mobaxterm/README.md">MobaXterm (Windows)</a>
    </li>
    <li>
      <a href="./powershell/README.md">PowerShell (Windows)</a>
      <br>
      Remote install (Windows PowerShell 5.1):
      <pre><code>[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-ExecutionPolicy Bypass -Scope Process -Force
iex (iwr 'https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/powershell/install.ps1' -UseBasicParsing).Content</code></pre>
      Remote install (PowerShell 7+):
      <pre><code>Set-ExecutionPolicy Bypass -Scope Process -Force
irm 'https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/powershell/install.ps1' -Raw | iex</code></pre>
      Default one-liner:
      <pre><code>Set-ExecutionPolicy Bypass -Scope Process -Force
irm https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/powershell/install.ps1 | iex</code></pre>
    </li>
    <li>
      <a href="./ptyxis/README.md">Ptyxis</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/ptyxis/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./putty/README.md">PuTTY (Windows)</a>
    </li>
    <li>
      <a href="./terminal.app/README.md">Terminal.app (macOS)</a>
    </li>
    <li>
      <a href="./terminator/README.md">Terminator</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/terminator/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./termux/README.md">Termux (Android)</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/termux/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./tilix/README.md">Tilix</a>
    </li>
    <li>
      <a href="./warp/README.md">Warp</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/warp/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./wezterm/README.md">WezTerm</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/wezterm/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./xfce/README.md">XFCE Terminal</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/emulators/xfce/install.sh | bash</code></pre>
    </li>
  </ul>
  <p>Note: In some directories you will find an <code>install.sh</code> script you can run to simplify theme installation for the terminal you use.</p>
</details>

<h2 align="center">Previews</h2>

<details>
  <summary>View terminal previews for each colour scheme</summary>
  <br>
  <table>
    <tr>
      <th align="center">x</th>
      <th align="center">madrid</th>
      <th align="center">lahabana</th>
    </tr>
    <tr>
      <td><img src="https://raw.githubusercontent.com/xscriptor/xassets/main/xrepos/terminal/emulators/previews/terminal_x.png" width="300" alt="x" /></td>
      <td><img src="https://raw.githubusercontent.com/xscriptor/xassets/main/xrepos/terminal/emulators/previews/terminal_madrid.png" width="300" alt="madrid" /></td>
      <td><img src="https://raw.githubusercontent.com/xscriptor/xassets/main/xrepos/terminal/emulators/previews/terminal_lahabana.png" width="300" alt="lahabana" /></td>
    </tr>
    <tr>
      <th align="center">miami</th>
      <th align="center">paris</th>
      <th align="center">tokio</th>
    </tr>
    <tr>
      <td><img src="https://raw.githubusercontent.com/xscriptor/xassets/main/xrepos/terminal/emulators/previews/terminal_miami.png" width="300" alt="miami" /></td>
      <td><img src="https://raw.githubusercontent.com/xscriptor/xassets/main/xrepos/terminal/emulators/previews/terminal_paris.png" width="300" alt="paris" /></td>
      <td><img src="https://raw.githubusercontent.com/xscriptor/xassets/main/xrepos/terminal/emulators/previews/terminal_tokio.png" width="300" alt="tokio" /></td>
    </tr>
    <tr>
      <th align="center">oslo</th>
      <th align="center">helsinki</th>
      <th align="center">berlin</th>
    </tr>
    <tr>
      <td><img src="https://raw.githubusercontent.com/xscriptor/xassets/main/xrepos/terminal/emulators/previews/terminal_oslo.png" width="300" alt="oslo" /></td>
      <td><img src="https://raw.githubusercontent.com/xscriptor/xassets/main/xrepos/terminal/emulators/previews/terminal_helsinki.png" width="300" alt="helsinki" /></td>
      <td><img src="https://raw.githubusercontent.com/xscriptor/xassets/main/xrepos/terminal/emulators/previews/terminal_berlin.png" width="300" alt="berlin" /></td>
    </tr>
    <tr>
      <th align="center">london</th>
      <th align="center">praha</th>
      <th align="center">bogota</th>
    </tr>
    <tr>
      <td><img src="https://raw.githubusercontent.com/xscriptor/xassets/main/xrepos/terminal/emulators/previews/terminal_london.png" width="300" alt="london" /></td>
      <td><img src="https://raw.githubusercontent.com/xscriptor/xassets/main/xrepos/terminal/emulators/previews/terminal_praha.png" width="300" alt="praha" /></td>
      <td><img src="https://raw.githubusercontent.com/xscriptor/xassets/main/xrepos/terminal/emulators/previews/terminal_bogota.png" width="300" alt="bogota" /></td>
    </tr>
  </table>
</details>