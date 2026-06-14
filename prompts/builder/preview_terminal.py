#!/usr/bin/env python3
"""
Terminal Preview Generator
Renders xfetch + ls + colour palette for each theme as a PNG image.
"""

import os
import re
import json
import sys
from PIL import Image, ImageDraw, ImageFont

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
PREVIEWS_DIR = os.path.join(ROOT_DIR, 'prompts', 'previews')
FONT_REGULAR = os.path.expanduser("~/.fonts/JetBrainsMonoNerdFont-Regular.ttf")
FONT_BOLD = os.path.expanduser("~/.fonts/JetBrainsMonoNerdFont-Bold.ttf")


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


def get_font(bold=False, size=15):
    path = FONT_BOLD if bold else FONT_REGULAR
    if os.path.exists(path):
        return ImageFont.truetype(path, size)
    return ImageFont.load_default()


def text_width(text, font):
    bbox = font.getbbox(text)
    return bbox[2] - bbox[0]


def render_preview(theme_name, palettes):
    palette = palettes.get(theme_name, palettes.get('x', {}))
    bg_color = hex_to_rgb(palette.get('background', '#000000'))

    # Palette colours
    c = {}
    for i in range(16):
        c[f'c{i}'] = hex_to_rgb(palette.get(f'color{i}', '#888888'))
    cy = c['c6']
    pu = c['c5']
    rd = c['c1']
    gr = c['c2']
    ye = c['c3']
    wh = c['c7']
    gy = c['c8']
    or_ = c['c4']

    fg = hex_to_rgb(palette.get('foreground', '#cccccc'))

    # Layout constants
    col_width = 36  # number of monospace chars for left column
    padding = 14
    char_w = 9      # approximate monospace char width
    sep_x = padding + col_width * char_w
    line_height = 20
    width = 1000

    # === DATA ===
    left_lines = [
        (r' __  __                               ', cy, False),
        (r'   \ \/ /                             ', cy, False),
        (r'    \  /                              ', cy, False),
        (r'    /  \                              ', cy, False),
        (r'   /_/\_\                             ', cy, False),
        (r'  /____/linux                         ', cy, False),
        (' ---------BEGIN PUBLIC KEY----------  ', gy, False),
        (' MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMII  ', gy, False),
        (' BCgKCAQEAwtU/XOS/xOf/FakeKeyDataFor  ', gy, False),
        (' ArtPutHere+Of/XOSLINUXDISTRO/gD4t4+  ', gy, False),
        (' N4ToR3aL/K3yG3NkR/v3RyL0ngD4t4+XoSy  ', gy, False),
        (' LiNuX/R0cK/M0r3+L1nUx/D1sTr0/R4cK3a  ', gy, False),
        (' XYS/aBcDeFgHiJkLmNoPqRsTuVwXyZ01234  ', gy, False),
        (' 56789+/woXosLinuxR0xOsD1sTr0d1stR0f  ', gy, False),
        (' 0/c00L/k3Y/wER3aL63nD/v3RyL0ngD4t4a  ', gy, False),
        (' ABcD/EfGhIjK/xOsLiNuX/D1sTr0/R0cK3a  ', gy, False),
        (' LmNoPqRsTuVwXyZ0/1nUx/wER3aL63nD/v3  ', gy, False),
        (' RyL0ngD4t4+XoSy/M0r3+L1nUx/D1sTr0/R  ', gy, False),
        (' 4cK3a/XYS/aBcDeFgHiJkLmNoPqRsTuVwXy  ', gy, False),
        (' Z0123456789+/woXos/Linux/Rocks/==    ', gy, False),
        (' ----------END PUBLIC KEY-----------  ', gy, False),
    ]

    right_lines = [
        # line_index -> list of (text, color, bold)
        [(r'────── Hardware ──────', cy, True)],
        [('│ ', gy), (' ', pu), ('hostname: ', gy), ('xscriptor', fg, False)],
        [('│ ', gy), (' ', pu), ('cpu: ', gy), ('Intel(R) Core(TM) i7-14650HX (24) @ 2.42 GHz', fg, False)],
        [('│ ', gy), ('󰍹 ', pu), ('gpu: ', gy), ('Unknown GPU', fg, False)],
        [('│ ', gy), (' ', pu), ('memory: ', gy), ('5.20 GiB / 46.85 GiB ', fg, False), ('(11%)', rd, False)],
        [('│ ', gy), (' ', pu), ('swap: ', gy), ('0.00 GiB / 12.00 GiB ', fg, False), ('(0%)', gr, False)],
        [('│ ', gy), ('󰋊 ', pu), ('disk: ', gy), ('0.00 GiB / 23.42 GiB ', fg, False), ('(0%) - overlay', gy, False)],
        [('│ ', gy), (' ', pu), ('battery: ', gy), ('100% ', gr, True), ('[AC Connected]', gr, False)],
        [('│ ', gy)],
        [('│ ', gy)],
        [('│ ', gy), (r'────── Software ──────', cy, True)],
        [('│ ', gy), (' ', pu), ('os: ', gy), ('X  x86_64', fg, False)],
        [('│ ', gy), (' ', pu), ('kernel: ', gy), ('7.0.12', fg, False)],
        [('│ ', gy), (' ', pu), ('packages: ', gy), ('12 (xpkg)', fg, False)],
        [('│ ', gy), (' ', pu), ('shell: ', gy), ('zsh', fg, False)],
        [('│ ', gy), (' ', pu), ('wm: ', gy), ('Hyprland', fg, False)],
        [('│ ', gy), (' ', pu), ('terminal: ', gy), ('Kitty', fg, False)],
        [('│ ', gy), ('󰩟 ', pu), ('local_ip: ', gy), ('10.255.255.254', fg, False)],
        [('│ ', gy), (r'────── Session ──────', cy, True)],
        [('│ ', gy), (' ', pu), ('user: ', gy), ('x', fg, False)],
        [('│ ', gy), ('󰔛 ', pu), ('uptime: ', gy), ('2 hours, 11 mins', fg, False)],
    ]

    # Extra lines for datetime and X (no left art)
    extra_right = [
        [('│ ', gy), (' ', pu), ('datetime: ', gy), ('2026-06-14 15:27:04', fg, False)],
        [('│ ', gy), (' ', pu), ('X (@Xscriptor)', fg, False)],
    ]

    max_lines = max(len(left_lines), len(right_lines) + len(extra_right))
    # Total sections: left/right lines + blank + extra lines + blank + dots + ls + palette
    total_lines = max_lines + 2 + len(extra_right) + 1
    total_height = total_lines * line_height + padding * 2 + 4 * line_height + 40

    img = Image.new('RGB', (width, total_height), bg_color)
    draw = ImageDraw.Draw(img)

    # Helper to render a list of segments starting at x, returns next x
    def render_segs(segs, x, y):
        for seg in segs:
            if not seg or len(seg) < 2:
                continue
            text = seg[0]
            color = seg[1]
            bold = seg[2] if len(seg) > 2 else False
            if color is None:
                x += len(text) * char_w
                continue
            f = get_font(bold, 15)
            tw = text_width(text, f)
            draw.text((x, y), text, font=f, fill=color)
            x += tw
        return x

    # Render left + right columns
    y = padding
    for i in range(max_lines):
        # Left column
        if i < len(left_lines):
            text, color, bold = left_lines[i]
            f = get_font(bold, 15)
            draw.text((padding, y), text, font=f, fill=color)

        # Right column
        if i < len(right_lines):
            render_segs(right_lines[i], sep_x, y)
        elif i >= max_lines - len(extra_right):
            ri = i - (max_lines - len(extra_right))
            if ri < len(extra_right):
                render_segs(extra_right[ri], sep_x, y)

        y += line_height

    # Blank line, then xfetch palette bar (drawn as circles)
    y += line_height // 2

    dot_y = y
    dot_size = 14
    gap = 2

    # Palette icon
    f_icon = get_font(size=15)
    draw.text((sep_x, dot_y - 2), ' ', font=f_icon, fill=or_)
    icon_w = text_width(' ', f_icon)

    # Draw 16 colored circles using PIL
    for i in range(16):
        dot_color = hex_to_rgb(palette.get(f'color{i}', '#888888'))
        x0 = sep_x + icon_w + i * (dot_size + gap)
        y0 = dot_y + (line_height - dot_size) // 2
        draw.ellipse([x0, y0, x0 + dot_size, y0 + dot_size], fill=dot_color)

    y += line_height + 4

    # === ls OUTPUT ===
    def render_ls_entry(name, icon, y_pos, is_first=False):
        x = padding
        for seg in [
            ('drwxr-xr-x  ', (120, 180, 120), False),
            ('  x  ', ye, True),
            ('  x  ', ye, True),
            ('  4096 ', (160, 160, 160), False),
            ('Jun 14 15:27 ', (180, 120, 120), False),
        ]:
            text, color, bold = seg
            f_ls = get_font(bold, 15)
            tw = text_width(text, f_ls)
            draw.text((x, y_pos), text, font=f_ls, fill=color)
            x += tw
        draw.text((x, y_pos), f'{icon}{name}/', font=get_font(True, 15), fill=cy)

    for entry, icon in [('.', ''), ('Documents', '󰈙 '), ('Downloads', ' '),
                        ('Music', ' '), ('projects', '󰂺 '), ('xpkg', ' ')]:
        render_ls_entry(entry, icon, y)
        y += line_height

    # === PALETTE BAR ===
    y += 4
    dot_size2 = 20
    gap2 = 2
    total_dots = 16 * (dot_size2 + gap2)
    start_x = (width - total_dots) // 2

    for i in range(16):
        dot_color = hex_to_rgb(palette.get(f'color{i}', '#888888'))
        x0 = start_x + i * (dot_size2 + gap2)
        draw.rounded_rectangle([x0, y, x0 + dot_size2, y + dot_size2], radius=4, fill=dot_color)

    f_label = get_font(size=12)
    label = 'ANSI 16-colour palette'
    lw = text_width(label, f_label)
    draw.text(((width - lw) // 2, y + dot_size2 + 5), label, font=f_label, fill=gy)

    return img


def main():
    os.makedirs(PREVIEWS_DIR, exist_ok=True)
    palettes = parse_palettes()

    images = []
    for name in sorted(palettes.keys()):
        print(f"  {name}...", end=' ', flush=True)
        img = render_preview(name, palettes)
        path = os.path.join(PREVIEWS_DIR, f'terminal_{name}.png')
        img.save(path)
        images.append(img)
        print(f"{img.width}x{img.height}")

    if images:
        comp_w = max(img.width for img in images)
        comp_h = sum(img.height for img in images)
        composite = Image.new('RGB', (comp_w, comp_h), (0, 0, 0))
        y = 0
        for img in images:
            composite.paste(img, (0, y))
            y += img.height
        preview_path = os.path.join(PREVIEWS_DIR, 'terminal_preview.png')
        composite.save(preview_path)
        print(f"\nComposite: {preview_path}")


if __name__ == '__main__':
    main()
