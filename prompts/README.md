<h1 align="center">Prompts</h1>

<p>Custom prompt themes for <a href="https://starship.rs">Starship</a>, <a href="https://ohmyposh.dev">Oh My Posh</a>, <a href="https://spaceship-prompt.sh">Spaceship</a>, and <a href="./bash/README.md">Bash/Zsh PS1</a>, all generated from the <a href="../colors.md">X colour palettes</a>.</p>

<h2 align="center">Supported</h2>

<table>
  <tr>
    <th align="left">Engine</th>
    <th align="left">Directory</th>
  </tr>
  <tr><td><strong>Starship</strong></td><td><a href="./starship/README.md">prompts/starship/</a></td></tr>
  <tr><td><strong>Oh My Posh</strong></td><td><a href="./ohmyposh/README.md">prompts/ohmyposh/</a></td></tr>
  <tr><td><strong>Spaceship</strong></td><td><a href="./spaceship/README.md">prompts/spaceship/</a></td></tr>
  <tr><td><strong>Bash / Zsh PS1</strong></td><td><a href="./bash/README.md">prompts/bash/</a></td></tr>
</table>

<h2 align="center">Canonical Colour Mapping</h2>

<p>All themes — both Starship and Oh My Posh — follow the same ANSI 16-colour to prompt-element mapping, ensuring perfect consistency across all palettes.</p>

<table>
  <tr>
    <th>ANSI</th>
    <th>Prompt element</th>
    <th>Starship module</th>
    <th>Oh My Posh segment</th>
  </tr>
  <tr><td><code>color0</code></td><td>Dark background</td><td>username/hostname/git/cmd/status/battery bg</td><td>session/git/executiontime/status/battery bg</td></tr>
  <tr><td><code>color1</code></td><td>Red (error, accent)</td><td>time bg, character error, root user, status fg</td><td>time bg, status fg, battery low</td></tr>
  <tr><td><code>color2</code></td><td>Green (success)</td><td>character success</td><td>text (prompt char) success</td></tr>
  <tr><td><code>color3</code></td><td>Yellow (user, battery)</td><td>username fg, battery full</td><td>battery high fg</td></tr>
  <tr><td><code>color4</code></td><td>Orange</td><td>— (reserved)</td><td>—</td></tr>
  <tr><td><code>color5</code></td><td>Purple</td><td>os bg</td><td>os bg</td></tr>
  <tr><td><code>color6</code></td><td>Cyan (directory, langs)</td><td>directory bg/fg, language fg, cmd_duration fg</td><td>path bg/fg, language fg</td></tr>
  <tr><td><code>color7</code></td><td>White (host, git)</td><td>hostname fg, git branch/status fg</td><td>session fg, git fg</td></tr>
  <tr><td><code>color8</code></td><td>Gray (lang bg)</td><td>all language module backgrounds</td><td>node/rust/go/python bg</td></tr>
  <tr><td><code>color9–15</code></td><td>Bright variants</td><td>same as dim counterparts</td><td>same as dim counterparts</td></tr>
  <tr><td><code>background</code></td><td>Terminal bg</td><td>—</td><td><code>terminal_background</code></td></tr>
  <tr><td><code>foreground</code></td><td>Terminal fg</td><td>—</td><td>—</td></tr>
</table>

<h2 align="center">Gallery</h2>

<p>All 13 palettes produce the same prompt layout; only the colours change according to the mapping above.</p>

<table>
  <tr>
    <th align="left">Theme</th>
    <th align="left">Starship</th>
    <th align="left">Oh My Posh</th>
  </tr>
  <tr><td>x</td><td><a href="./starship/themes/x.toml">x.toml</a></td><td><a href="./ohmyposh/themes/x.json">x.json</a></td></tr>
  <tr><td>madrid</td><td><a href="./starship/themes/madrid.toml">madrid.toml</a></td><td><a href="./ohmyposh/themes/madrid.json">madrid.json</a></td></tr>
  <tr><td>lahabana</td><td><a href="./starship/themes/lahabana.toml">lahabana.toml</a></td><td><a href="./ohmyposh/themes/lahabana.json">lahabana.json</a></td></tr>
  <tr><td>miami</td><td><a href="./starship/themes/miami.toml">miami.toml</a></td><td><a href="./ohmyposh/themes/miami.json">miami.json</a></td></tr>
  <tr><td>paris</td><td><a href="./starship/themes/paris.toml">paris.toml</a></td><td><a href="./ohmyposh/themes/paris.json">paris.json</a></td></tr>
  <tr><td>tokio *</td><td><a href="./starship/themes/tokio.toml">tokio.toml</a></td><td><a href="./ohmyposh/themes/tokio.json">tokio.json</a></td></tr>
  <tr><td>oslo</td><td><a href="./starship/themes/oslo.toml">oslo.toml</a></td><td><a href="./ohmyposh/themes/oslo.json">oslo.json</a></td></tr>
  <tr><td>helsinki</td><td><a href="./starship/themes/helsinki.toml">helsinki.toml</a></td><td><a href="./ohmyposh/themes/helsinki.json">helsinki.json</a></td></tr>
  <tr><td>berlin</td><td><a href="./starship/themes/berlin.toml">berlin.toml</a></td><td><a href="./ohmyposh/themes/berlin.json">berlin.json</a></td></tr>
  <tr><td>london</td><td><a href="./starship/themes/london.toml">london.toml</a></td><td><a href="./ohmyposh/themes/london.json">london.json</a></td></tr>
  <tr><td>praha</td><td><a href="./starship/themes/praha.toml">praha.toml</a></td><td><a href="./ohmyposh/themes/praha.json">praha.json</a></td></tr>
  <tr><td>bogota</td><td><a href="./starship/themes/bogota.toml">bogota.toml</a></td><td><a href="./ohmyposh/themes/bogota.json">bogota.json</a></td></tr>
</table>

<p><em>* tokio uses the <strong>x</strong> palette but splits information across left and right prompts.</em></p>

<h2 align="center">Builder</h2>

<p>All prompt themes are auto-generated from <code>colors.md</code> using a template engine. To add a new palette or fix colours, edit <code>colors.md</code> and run:</p>

<pre><code>python3 prompts/builder/build.py</code></pre>

<p>The builder reads the palettes from <code>colors.md</code>, applies the canonical colour mapping, and renders templates into <code>builder/test/</code> for review. See the <a href="./builder/README.md">builder documentation</a> for the full workflow.</p>
