
<h2 align="center">Starship</h2>

<p>Starship themes are provided as standalone configs. Pick a theme and point <code>STARSHIP_CONFIG</code> to it.</p>

<h3>Quick Start</h3>

<pre><code>export STARSHIP_CONFIG="$PWD/prompts/starship/themes/x.toml"

# zsh
eval "$(starship init zsh)"
</code></pre>

<p>Use <a href="./starship/starship.toml">starship.toml</a> as a base config if you want to customize modules manually.</p>

<h3>Remote Install</h3>

<p>This script downloads the full <code>prompts/starship</code> folder (themes and <code>starship.toml</code>) and adds a helper function to your shell config.</p>

<pre><code>curl -fsSL https://raw.githubusercontent.com/xscriptor/terminal/main/prompts/starship/install.sh | bash</code></pre>

<p>After install, switch themes with:</p>

<pre><code>xscriptor_starship_theme tokio</code></pre>

<p>The function updates the line below in your shell config to point at the selected theme:</p>

<pre><code>export STARSHIP_CONFIG="/path/to/starship/themes/x.toml"</code></pre>

<p>Optional environment variables:</p>

<ul>
  <li><code>XSC_STARSHIP_DIR</code> (install location)</li>
  <li><code>XSC_STARSHIP_REF</code> (git ref, default: main)</li>
  <li><code>XSC_STARSHIP_SHELL_RC</code> (shell config file)</li>
</ul>

<h3>Themes</h3>

<table>
  <tr>
    <th align="left">Theme</th>
    <th align="left">Config</th>
  </tr>
  <tr><td>x</td><td><a href="./starship/themes/x.toml">x.toml</a></td></tr>
  <tr><td>madrid</td><td><a href="./starship/themes/madrid.toml">madrid.toml</a></td></tr>
  <tr><td>lahabana</td><td><a href="./starship/themes/lahabana.toml">lahabana.toml</a></td></tr>
  <tr><td>seul</td><td><a href="./starship/themes/seul.toml">seul.toml</a></td></tr>
  <tr><td>miami</td><td><a href="./starship/themes/miami.toml">miami.toml</a></td></tr>
  <tr><td>paris</td><td><a href="./starship/themes/paris.toml">paris.toml</a></td></tr>
  <tr><td>tokio</td><td><a href="./starship/themes/tokio.toml">tokio.toml</a></td></tr>
  <tr><td>oslo</td><td><a href="./starship/themes/oslo.toml">oslo.toml</a></td></tr>
  <tr><td>helsinki</td><td><a href="./starship/themes/helsinki.toml">helsinki.toml</a></td></tr>
  <tr><td>berlin</td><td><a href="./starship/themes/berlin.toml">berlin.toml</a></td></tr>
  <tr><td>london</td><td><a href="./starship/themes/london.toml">london.toml</a></td></tr>
  <tr><td>praha</td><td><a href="./starship/themes/praha.toml">praha.toml</a></td></tr>
  <tr><td>bogota</td><td><a href="./starship/themes/bogota.toml">bogota.toml</a></td></tr>
</table>