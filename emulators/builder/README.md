# Universal Theme Builder

This tool allows you to automatically generate all terminal emulator configurations from a single source of truth.
If you need to change a color or create a new theme, you no longer need to manually edit 14 different files.

## How it works

The engine reads color schemas from `colors.md` in the root repository.
It supports dynamic variable replacements allowing us to feed HEX strings, stripped HEX strings, and fractional/standard RGB variables to any template.

1. The script `build.py` looks into `colors.md` for JSON code blocks under `<h2>` headings.
2. It parses the 16 base colors (`color0` to `color15`) plus `background` and `foreground`.
3. It loops over every `.template` file located in the `builder/templates/` folder.
4. It exports the final static configuration files to `builder/test/` for review.

## How to add or change a theme

1. Open `colors.md` in the root of the repository.
2. Locate the theme you want to modify, or create a new one copying the exact Markdown/HTML structure of an existing one.
3. Modify the HEX codes inside its JSON block.
4. Run the builder script from the root of your repository:
   ```sh
   python3 emulators/builder/build.py
   ```
5. Check the `emulators/builder/test/` directory. The engine will have generated folders containing your updated theme files.
6. Review the generated files. If everything looks correct, copy them manually into the corresponding `emulators/<terminal>/themes/` directories.

## Supported Template Variables

Available variables you can use inside any `builder/templates/*.template` file:

- Standard Hex format: `{{ color0 }}` to `{{ color15 }}`, `{{ background }}`, `{{ foreground }}` (Outputs: `#1E1E1E`)
- Clean Hex format: `{{ color0_hex }}` (Outputs: `1E1E1E`)
- Standard RGB: `{{ color0_r }}`, `{{ color0_g }}`, `{{ color0_b }}` (Outputs: `255`)
- Fractional RGB: `{{ color0_rf }}`, `{{ color0_gf }}`, `{{ color0_bf }}` (Outputs: `1.000`)

To support a new terminal configuration, simply add a new `.template` file in `builder/templates/` making use of these variables, and run `build.py`.
