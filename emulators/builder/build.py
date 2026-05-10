#!/usr/bin/env python3
import os
import re
import json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REF_FILE = os.path.join(ROOT_DIR, 'references.md')
TEMPLATES_DIR = os.path.join(ROOT_DIR, 'builder', 'templates')
DIST_DIR = os.path.join(ROOT_DIR, 'builder', 'dist')

def hex_to_rgb(hex_str):
    hex_str = hex_str.lstrip('#')
    return tuple(int(hex_str[i:i+2], 16) for i in (0, 2, 4))

def parse_references():
    with open(REF_FILE, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Matches ## themename \n\n ```json\n {...} \n```
    pattern = re.compile(r'##\s+([a-zA-Z0-9_-]+)\n+```json\n({[^}]+})\n```')
    blocks = pattern.findall(content)
    
    themes = {}
    for name, json_text in blocks:
        try:
            colors = json.loads(json_text)
            
            # Extract bg/fg from Alacritty dir
            alacritty_theme = os.path.join(ROOT_DIR, 'alacritty', 'themes', f'{name}.toml')
            bg, fg = "#000000", "#ffffff" 
            
            if os.path.exists(alacritty_theme):
                with open(alacritty_theme, 'r', encoding='utf-8') as tf:
                    tcontent = tf.read()
                    bg_match = re.search(r'background\s*=\s*"([^"]+)"', tcontent)
                    fg_match = re.search(r'foreground\s*=\s*"([^"]+)"', tcontent)
                    if bg_match: bg = bg_match.group(1)
                    if fg_match: fg = fg_match.group(1)
            
            colors['background'] = bg
            colors['foreground'] = fg
            themes[name] = colors
        except json.JSONDecodeError:
            print(f"Error parseando JSON de {name}")
    return themes

def build_themes():
    themes = parse_references()
    print(f"Extraídos {len(themes)} temas desde references.md")
    
    if not os.path.exists(TEMPLATES_DIR):
        print(f"No existe el directorio de plantillas: {TEMPLATES_DIR}")
        return
        
    templates = [f for f in os.listdir(TEMPLATES_DIR) if f.endswith('.template')]
    if not templates:
        print(f"No hay archivos .template en {TEMPLATES_DIR}")
        return
        
    for template_name in templates:
        with open(os.path.join(TEMPLATES_DIR, template_name), 'r', encoding='utf-8') as f:
            template_content = f.read()
            
        terminal_name = template_name.split('.')[0]
        ext = template_name.replace(f'{terminal_name}.', '').replace('.template', '')
        
        term_dist_dir = os.path.join(DIST_DIR, terminal_name)
        os.makedirs(term_dist_dir, exist_ok=True)
        
        for theme_name, base_colors in themes.items():
            rendered = template_content
            
            # Generate advanced color formats dynamically
            advanced_colors = {}
            for key, val in base_colors.items():
                if val.startswith('#'):
                    # {{ color0 }} = #123456
                    advanced_colors[key] = val
                    # {{ color0_hex }} = 123456
                    advanced_colors[key + '_hex'] = val.lstrip('#')
                    
                    r, g, b = hex_to_rgb(val)
                    # {{ color0_r }}, {{ color0_g }}, {{ color0_b }}
                    advanced_colors[key + '_r'] = str(r)
                    advanced_colors[key + '_g'] = str(g)
                    advanced_colors[key + '_b'] = str(b)
                    
                    # {{ color0_rf }}, {{ color0_gf }}, {{ color0_bf }} for fractional templates like iTerm2
                    advanced_colors[key + '_rf'] = f"{r/255.0:.3f}"
                    advanced_colors[key + '_gf'] = f"{g/255.0:.3f}"
                    advanced_colors[key + '_bf'] = f"{b/255.0:.3f}"
                else:
                    advanced_colors[key] = val
            
            for key, val in advanced_colors.items():
                rendered = rendered.replace(f'{{{{ {key} }}}}', val)
                
            output_file = os.path.join(term_dist_dir, f'{theme_name}.{ext}')
            with open(output_file, 'w', encoding='utf-8') as out:
                out.write(rendered)
        
        print(f"Construidos {len(themes)} temas para {terminal_name} en builder/dist/{terminal_name}/")

if __name__ == "__main__":
    build_themes()
