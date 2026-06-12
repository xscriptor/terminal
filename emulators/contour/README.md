# Xscriptor Contour Themes

<p align="center">
  <img src="https://raw.githubusercontent.com/xscriptor/terminal/main/previews/contour/preview.jpg" alt="Preview" width="900"/>
</p>

## Files

<ul>
  <li><code>themes/*.yaml</code>: Color scheme definitions for Contour terminal.</li>
</ul>

## Installation

<p>Contour stores all color schemes inside <code>~/.config/contour/contour.yml</code> under the <code>color_schemes:</code> key.</p>

<p>Open your <code>contour.yml</code> and add the desired theme under <code>color_schemes:</code>:</p>

<pre><code>color_schemes:
  x:
    default:
      background: '#050505'
      foreground: '#f7f1ff'
    normal:
      black:   '#0a0a0a'
      red:     '#fc618d'
      green:   '#7bd88f'
      yellow:  '#fce566'
      blue:    '#fd9353'
      magenta: '#948ae3'
      cyan:    '#5ad4e6'
      white:   '#f7f1ff'
    bright:
      black:   '#0f0f0f'
      red:     '#fc618d'
      green:   '#7bd88f'
      yellow:  '#fce566'
      blue:    '#fd9353'
      magenta: '#948ae3'
      cyan:    '#5ad4e6'
      white:   '#f7f1ff'
    cursor:
      default: '#f7f1ff'
      text: CellBackground</code></pre>

<p>Then activate it in your profile or via the config:</p>

<pre><code>profile:
  color_scheme: x</code></pre>

<p>Reload Contour with <code>SIGHUP</code> or restart it.</p>

## Themes

<ul>
  <li><code>x.yaml</code>, <code>madrid.yaml</code>, <code>lahabana.yaml</code>, <code>miami.yaml</code>, <code>paris.yaml</code>, <code>tokio.yaml</code>, <code>oslo.yaml</code>, <code>helsinki.yaml</code>, <code>berlin.yaml</code>, <code>london.yaml</code>, <code>praha.yaml</code>, <code>bogota.yaml</code></li>
</ul>
