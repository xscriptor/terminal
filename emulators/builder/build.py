#!/usr/bin/env python3
import os
import re
import json

ROOT_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
REF_FILE = os.path.join(ROOT_DIR, 'colors.md')
TEMPLATES_DIR = os.path.join(ROOT_DIR, 'emulators', 'builder', 'templates')
TEST_DIR = os.path.join(ROOT_DIR, 'emulators', 'builder', 'test')

def hex_to_rgb(hex_str):
    hex_str = hex_str.lstrip('#')
    return tuple(int(hex_str[i:i+2], 16) for i in (0, 2, 4))

def parse_colors():
    with open(REF_FILE, 'r', encoding='utf-8') as f:
        content = f.read()

    pattern = re.compile(r'<h2[^>]*>([^<]+)</h2>\s*```json\s*({[^}]+})\s*```')
    blocks = pattern.findall(content)

    themes = {}
    for name, json_text in blocks:
        name = name.strip().lower()
        try:
            colors = json.loads(json_text)
            themes[name] = colors
        except json.JSONDecodeError:
            print(f"Error parseando JSON de {name}")
    return themes

def build_themes():
    themes = parse_colors()
    print(f"Extraídos {len(themes)} temas desde colors.md")

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
        ext = template_name.replace(f'{terminal_name}.', '', 1).replace('.template', '')

        term_test_dir = os.path.join(TEST_DIR, terminal_name)
        os.makedirs(term_test_dir, exist_ok=True)

        for theme_name, base_colors in themes.items():
            rendered = template_content

            advanced_colors = {}
            for key, val in base_colors.items():
                if val.startswith('#'):
                    advanced_colors[key] = val
                    advanced_colors[key + '_hex'] = val.lstrip('#')

                    r, g, b = hex_to_rgb(val)
                    advanced_colors[key + '_r'] = str(r)
                    advanced_colors[key + '_g'] = str(g)
                    advanced_colors[key + '_b'] = str(b)

                    advanced_colors[key + '_rf'] = f"{r/255.0:.3f}"
                    advanced_colors[key + '_gf'] = f"{g/255.0:.3f}"
                    advanced_colors[key + '_bf'] = f"{b/255.0:.3f}"
                else:
                    advanced_colors[key] = val

            advanced_colors['theme_name_plain'] = theme_name

            for key, val in advanced_colors.items():
                rendered = rendered.replace(f'{{{{ {key} }}}}', val)

            output_file = os.path.join(term_test_dir, f'{theme_name}.{ext}')
            with open(output_file, 'w', encoding='utf-8') as out:
                out.write(rendered)

        print(f"Construidos {len(themes)} temas para {terminal_name} en builder/test/{terminal_name}/")

if __name__ == "__main__":
    build_themes()
