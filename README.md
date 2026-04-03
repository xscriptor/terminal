<h1 align="center">Terminal Xscriptor</h1>

<div align="center">

![android](https://xscriptor.github.io/badges/os/android.svg) ![linux](https://xscriptor.github.io/badges/os/linux.svg) ![macos](https://xscriptor.github.io/badges/os/macos.svg) ![windows](https://xscriptor.github.io/badges/os/windows.svg) ![mit](https://xscriptor.github.io/badges/licenses/mit.svg)

My own collection of terminal themes and color schemes designed for a consistent look and feel across Windows, macOS, and Linux.

</div>

<p align="center"><img src="./assets/icon.png" width="100" alt="Terminal Xscriptor logo" /></p>

<h2 align="center">Table of Contents</h2>

<ul>
  <li><a href="#previews">Previews</a></li>
  <li><a href="#supported-terminals">Supported Terminals</a></li>
  <li><a href="#related-files">Related Files</a></li>
</ul>

<hr>

<h2 align="center" id="previews">Previews</h2>

<p align="center">
  <a href="./powershell/previews/preview2.jpg">
    <img src="./powershell/previews/preview2.jpg" alt="Main preview" width="850"/>
  </a>
</p>

<details>
  <summary>Click here to see more previews</summary>

  <table>
    <tr>
      <td align="center">
        <a href="./ghostty/previews/preview1.jpg">
          <img src="./ghostty/previews/preview1.jpg" alt="Ghostty Preview" width="380"/>
        </a>
      </td>
      <td align="center">
        <a href="./kitty/previews/preview2.jpg">
          <img src="./kitty/previews/preview2.jpg" alt="Kitty Preview" width="380"/>
        </a>
      </td>
      <td align="center">
        <a href="./ptyxis/previews/preview2.jpg">
          <img src="./ptyxis/previews/preview2.jpg" alt="Ptyxis Preview" width="380"/>
        </a>
      </td>
      <td align="center">
        <a href="./konsole/previews/preview2.jpg">
          <img src="./konsole/previews/preview2.jpg" alt="Konsole Preview" width="380"/>
        </a>
      </td>
    </tr>
  </table>
</details>

<hr>

<h2 align="center" id="supported-terminals">Supported Terminals</h2>

<h3>Universal Installer</h3>

<p>You can use the universal installer to automatically configure the theme for your preferred terminal emulator. Just run the following command and select your terminal from the menu:</p>

<pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/install.sh | bash</code></pre>

<p>Alternatively, to make this easy to install manually, you can execute the remote install script directly for each terminal. You can see the details in each terminal's documentation.</p>

<details>
  <summary>View Installation Instructions for Supported Terminals</summary>

  <ul>
    <li>
      <a href="./alacritty/README.md">Alacritty</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/alacritty/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./foot/README.md">Foot</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/foot/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./ghostty/README.md">Ghostty</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/ghostty/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./gnome-terminal/README.md">GNOME Terminal</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/gnome-terminal/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./hyper/README.md">Hyper</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/hyper/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./iterm/README.md">iTerm2</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/iterm/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./kitty/README.md">Kitty</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/kitty/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./konsole/README.md">Konsole</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/konsole/install.sh | bash</code></pre>
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
iex (iwr 'https://raw.githubusercontent.com/xscriptor/terminal/main/powershell/install.ps1' -UseBasicParsing).Content</code></pre>
      Remote install (PowerShell 7+):
      <pre><code>Set-ExecutionPolicy Bypass -Scope Process -Force
irm 'https://raw.githubusercontent.com/xscriptor/terminal/main/powershell/install.ps1' -Raw | iex</code></pre>
      Default one-liner:
      <pre><code>Set-ExecutionPolicy Bypass -Scope Process -Force
irm https://raw.githubusercontent.com/xscriptor/terminal/main/powershell/install.ps1 | iex</code></pre>
    </li>
    <li>
      <a href="./ptyxis/README.md">Ptyxis</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/ptyxis/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./putty/README.md">PuTTY (Windows)</a>
    </li>
    <li>
      <a href="./terminal.app/README.md">Terminal.app (macOS)</a>
    </li>
    <li>
      <a href="./terminator/README.md">Terminator</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/terminator/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./termux/README.md">Termux (Android)</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/termux/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./tilix/README.md">Tilix</a>
    </li>
    <li>
      <a href="./warp/README.md">Warp</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/warp/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./wezterm/README.md">WezTerm</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/wezterm/install.sh | bash</code></pre>
    </li>
    <li>
      <a href="./xfce/README.md">XFCE Terminal</a>
      <pre><code>wget -qO- https://raw.githubusercontent.com/xscriptor/terminal/main/xfce/install.sh | bash</code></pre>
    </li>
  </ul>
  <p>Note: In some directories you will find an <code>install.sh</code> script you can run to simplify theme installation for the terminal you use.</p>
</details>

<hr>

<h2 align="center" id="related-files">Related Files</h2>

<ul>
  <li><a href="./CONTRIBUTING.md">CONTRIBUTING.md</a></li>
  <li><a href="./CODE_OF_CONDUCT.md">CODE_OF_CONDUCT.md</a></li>
  <li><a href="./SECURITY.md">SECURITY.md</a></li>
  <li><a href="./SUPPORT.md">SUPPORT.md</a></li>
  <li><a href="./LICENSE">LICENSE</a></li>
</ul>

<br>

<p align="center"><strong>About the Developer</strong></p>

<div align="center">

[X](https://github.com/xscriptor) | [XWeb](https://dev.xscriptor.com)

</div>