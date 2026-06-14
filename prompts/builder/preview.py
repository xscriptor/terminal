#!/usr/bin/env python3
"""
Preview Generator for Prompt Themes
Renders each Starship and Oh My Posh theme as a PNG image.
"""

import os
import re
import subprocess
import sys
import json
from PIL import Image, ImageDraw, ImageFont

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
STARSHIP_DIR = os.path.join(ROOT_DIR, 'prompts', 'starship')
OHMYPOSH_DIR = os.path.join(ROOT_DIR, 'prompts', 'ohmyposh')
PREVIEWS_DIR = os.path.join(ROOT_DIR, 'prompts', 'previews')
FONT_PATH = os.path.expanduser("~/.fonts/JetBrainsMonoNerdFont-Bold.ttf")
FONT_REGULAR = os.path.expanduser("~/.fonts/JetBrainsMonoNerdFont-Regular.ttf")

# ANSI color table (indexed 0-15, maps to terminal standard)
ANSI_COLORS = [
    (0, 0, 0), (170, 0, 0), (0, 170, 0), (170, 85, 0),
    (0, 0, 170), (170, 0, 170), (0, 170, 170), (170, 170, 170),
    (85, 85, 85), (255, 85, 85), (85, 255, 85), (255, 255, 85),
    (85, 85, 255), (255, 85, 255), (85, 255, 255), (255, 255, 255),
]


def hex_to_rgb(hex_str):
    hex_str = hex_str.lstrip('#')
    return tuple(int(hex_str[i:i+2], 16) for i in (0, 2, 4))


def parse_palettes():
    colors_path = os.path.join(ROOT_DIR, 'colors.md')
    with open(colors_path) as f:
        content = f.read()
    pattern = re.compile(
        r'<h2[^>]*>([^<]+)</h2>\s*```json\s*\n(\{.*?\n)```',
        re.DOTALL
    )
    themes = {}
    for name, json_text in pattern.findall(content):
        name = name.strip().lower()
        try:
            themes[name] = json.loads(json_text)
        except json.JSONDecodeError:
            pass
    return themes


def render_starship_prompt(theme_name):
    theme_path = os.path.join(ROOT_DIR, 'prompts', 'starship', 'themes', f'{theme_name}.toml')
    if not os.path.exists(theme_path):
        return None

    env = os.environ.copy()
    env['STARSHIP_CONFIG'] = theme_path
    env['STARSHIP_LOG'] = 'error'

    # Create a temp git repo for richer prompt output
    tmp_dir = '/tmp/xpreview'
    os.makedirs(tmp_dir, exist_ok=True)
    subprocess.run(['git', 'init'], cwd=tmp_dir, capture_output=True)
    with open(os.path.join(tmp_dir, 'main.py'), 'w') as f:
        f.write("print('hello')\n")
    with open(os.path.join(tmp_dir, 'README.md'), 'w') as f:
        f.write("# test\n")
    subprocess.run(['git', 'add', '.'], cwd=tmp_dir, capture_output=True)
    subprocess.run(['git', '-c', 'user.name=test', '-c', 'user.email=test@test.com', 'commit', '-m', 'init'],
                   cwd=tmp_dir, capture_output=True)
    # Add untracked file
    with open(os.path.join(tmp_dir, 'untracked.py'), 'w') as f:
        f.write("x = 1\n")

    env['PWD'] = tmp_dir
    env['HOME'] = '/tmp'
    env['USER'] = 'xscriptor'

    try:
        result = subprocess.run(
            ['starship', 'prompt', '--status=0', '--terminal-width=100'],
            env=env, cwd=tmp_dir, capture_output=True, text=True, timeout=10
        )
        return result.stdout
    except Exception as e:
        print(f"  Error rendering {theme_name}: {e}")
        return None


def render_ohmyposh_prompt(theme_name):
    theme_path = os.path.join(ROOT_DIR, 'prompts', 'ohmyposh', 'themes', f'{theme_name}.json')
    if not os.path.exists(theme_path):
        return None

    tmp_dir = '/tmp/xpreview'
    os.makedirs(tmp_dir, exist_ok=True)

    env = os.environ.copy()
    env['PWD'] = tmp_dir
    env['HOME'] = '/tmp'
    env['USER'] = 'xscriptor'

    try:
        result = subprocess.run(
            ['oh-my-posh', 'print', 'primary', '--config', theme_path, '--shell', 'bash', '--status', '0'],
            env=env, cwd=tmp_dir, capture_output=True, text=True, timeout=10
        )
        return result.stdout
    except Exception as e:
        print(f"  Error rendering {theme_name}: {e}")
        return None


def parse_ansi(text):
    """Parse ANSI escape sequences into segments with foreground/background colors and bold."""
    # Unwrap shell-escaped ANSI: zsh %{...%}, bash \[...\]
    text = re.sub(r'%\{|\%\}|\\\[|\\\]', '', text)

    segments = []
    fg = (200, 200, 200)
    bg = None
    bold = False

    ansi_re = re.compile(r'\x1b\[([0-9;]*)m')
    pos = 0
    text_only = ''

    for m in ansi_re.finditer(text):
        if m.start() > pos:
            t = text[pos:m.start()]
            text_only += t
            segments.append((t, fg, bg, bold))

        params = m.group(1).split(';') if m.group(1) else ['0']
        i = 0
        while i < len(params):
            p = params[i]
            if p == '' or p == '0':
                fg = (200, 200, 200)
                bg = None
                bold = False
            elif p == '1':
                bold = True
            elif p == '22':
                bold = False
            elif p == '38' and i + 2 < len(params) and params[i+1] == '2':
                r, g, b = int(params[i+2]), int(params[i+3]), int(params[i+4])
                fg = (r, g, b)
                i += 4
                continue
            elif p == '48' and i + 2 < len(params) and params[i+1] == '2':
                r, g, b = int(params[i+2]), int(params[i+3]), int(params[i+4])
                bg = (r, g, b)
                i += 4
                continue
            elif p in ('38', '48'):
                # Skip 5;n format if present
                if i + 2 < len(params) and params[i+1] == '5':
                    i += 2
                    continue
            elif p == '39':
                fg = (200, 200, 200)
            elif p == '49':
                bg = None
            elif p.isdigit() and 30 <= int(p) <= 37:
                fg = ANSI_COLORS[int(p) - 30]
            elif p.isdigit() and 90 <= int(p) <= 97:
                fg = ANSI_COLORS[int(p) - 90 + 8]
            elif p.isdigit() and 100 <= int(p) <= 107:
                bg = ANSI_COLORS[int(p) - 100 + 8]
            i += 1

        pos = m.end()

    if pos < len(text):
        t = text[pos:]
        text_only += t
        segments.append((t, fg, bg, bold))

    return segments, text_only


def find_font(bold=False, size=16):
    """Find a good monospace font on the system."""
    paths = [
        (FONT_PATH if not bold else FONT_REGULAR),
        (FONT_REGULAR if not bold else FONT_PATH),
    ]
    # Swap for bold
    if bold:
        paths = [FONT_PATH, FONT_REGULAR]

    for p in paths:
        if os.path.exists(p):
            try:
                return ImageFont.truetype(p, size)
            except Exception:
                continue
    return ImageFont.load_default()


def render_preview(theme_name, prompt_text, palettes, engine):
    """Render a prompt text as a PNG image."""
    if not prompt_text:
        return None

    segments, _ = parse_ansi(prompt_text)

    # Determine background from palette
    palette = palettes.get(theme_name, palettes.get('x', {}))
    bg_hex = palette.get('background', '#000000')
    bg_color = hex_to_rgb(bg_hex) if bg_hex.startswith('#') else (0, 0, 0)

    font_size = 18
    line_height = 28
    padding = 12

    # First pass: measure total width and number of lines
    total_width = 800
    lines = []
    current_line = []
    current_width = 0
    line_text = ''

    for seg_text, fg, bg, bold in segments:
        try:
            font = find_font(bold, font_size)
            left, _, right, _ = font.getbbox(seg_text)
            w = right - left
        except Exception:
            w = len(seg_text) * 10

        if current_width + w > total_width - padding * 2 and current_line:
            lines.append((current_line, bg_color))
            current_line = []
            current_width = 0

        current_line.append((seg_text, fg, bg if bg else bg_color, bold))
        current_width += w

    if current_line:
        lines.append((current_line, bg_color))

    total_height = len(lines) * line_height + padding * 2
    total_width = 900

    img = Image.new('RGB', (total_width, total_height), bg_color)
    draw = ImageDraw.Draw(img)

    y = padding
    for line_segments, line_bg in lines:
        # Draw full-line background if different from image bg
        x = padding
        for seg_text, fg, seg_bg, bold in line_segments:
            try:
                font = find_font(bold, font_size)
                left, top, right, bottom = font.getbbox(seg_text)
                tw = right - left
            except Exception:
                font = find_font(False, font_size)
                tw = len(seg_text) * 10

            # Draw segment background
            if seg_bg and seg_bg != bg_color:
                draw.rectangle([x, y, x + tw + 2, y + line_height], fill=seg_bg)

            draw.text((x, y + 2), seg_text, font=font, fill=fg)
            x += tw

        y += line_height

    return img


def main():
    os.makedirs(PREVIEWS_DIR, exist_ok=True)
    palettes = parse_palettes()
    starship_themes = sorted(f.split('.')[0] for f in os.listdir(os.path.join(STARSHIP_DIR, 'themes')) if f.endswith('.toml'))
    ohmyposh_themes = sorted(f.split('.')[0] for f in os.listdir(os.path.join(OHMYPOSH_DIR, 'themes')) if f.endswith('.json'))

    print("Rendering Starship themes...")
    starship_images = []
    for theme in starship_themes:
        print(f"  {theme}...", end=' ', flush=True)
        prompt = render_starship_prompt(theme)
        if prompt:
            img = render_preview(theme, prompt, palettes, 'starship')
            if img:
                path = os.path.join(PREVIEWS_DIR, f'starship_{theme}.png')
                img.save(path)
                starship_images.append(img)
                print(f"{img.width}x{img.height}")
            else:
                print("render failed")
        else:
            print("prompt empty")

    # Composite Starship preview (stack all themes)
    if starship_images:
        composite_w = max(img.width for img in starship_images)
        composite_h = sum(img.height for img in starship_images)
        composite = Image.new('RGB', (composite_w, composite_h), (0, 0, 0))
        y = 0
        for img in starship_images:
            composite.paste(img, (0, y))
            y += img.height
        preview_path = os.path.join(PREVIEWS_DIR, 'starship_preview.png')
        composite.save(preview_path)
        print(f"\nStarship composite: {preview_path} ({composite_w}x{composite_h})")

    print("\nRendering Oh My Posh themes...")
    omp_images = []
    for theme in ohmyposh_themes:
        print(f"  {theme}...", end=' ', flush=True)
        prompt = render_ohmyposh_prompt(theme)
        if prompt:
            img = render_preview(theme, prompt, palettes, 'ohmyposh')
            if img:
                path = os.path.join(PREVIEWS_DIR, f'ohmyposh_{theme}.png')
                img.save(path)
                omp_images.append(img)
                print(f"{img.width}x{img.height}")
            else:
                print("render failed")
        else:
            print("prompt empty")

    if omp_images:
        composite_w = max(img.width for img in omp_images)
        composite_h = sum(img.height for img in omp_images)
        composite = Image.new('RGB', (composite_w, composite_h), (0, 0, 0))
        y = 0
        for img in omp_images:
            composite.paste(img, (0, y))
            y += img.height
        preview_path = os.path.join(PREVIEWS_DIR, 'ohmyposh_preview.png')
        composite.save(preview_path)
        print(f"\nOh My Posh composite: {preview_path} ({composite_w}x{composite_h})")

    print(f"\nDone. Previews in {PREVIEWS_DIR}/")


if __name__ == '__main__':
    main()
