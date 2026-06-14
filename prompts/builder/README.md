# Prompt Theme Builder

Generates Starship and Oh My Posh themes from the colour palettes in `colors.md`, following a canonical ANSI-to-prompt mapping.

## How it works

1. `build.py` reads all palettes from `colors.md` (JSON blocks under `<h2>` headings).
2. For each palette, it expands the 16 base colours (`color0`–`color15`) plus `background` and `foreground` into template variables (hex, clean hex, RGB, fractional RGB).
3. It loops over every `.template` file in `builder/templates/` and renders one theme file per palette.
4. Output goes to `builder/test/` for review — never directly to the live theme directories.

Templates use a variant system:

| File pattern | Variant | Applied to |
|---|---|---|
| `starship.toml.template` | `default` | `x`, `tokio` |
| `starship.combo.toml.template` | `combo` | all other themes |
| `ohmyposh.json.template` | `default` | `x`, `tokio` |
| `ohmyposh.combo.json.template` | `combo` | all other themes |

The `default` variant renders full powerline blocks. The `combo` variant renders session + directory as powerline blocks and everything else as plain text with `>` separators.

## How to add or change a theme

1. Open `colors.md` in the root of the repository.
2. Locate the theme you want to modify, or create a new one copying the exact HTML structure of an existing block.
3. Modify the HEX codes inside its JSON block.
4. Run the builder:
   ```sh
   python3 prompts/builder/build.py
   ```
5. Check the output in `prompts/builder/test/`. The engine generates folders for each prompt engine:
   - `test/starship/*.toml`
   - `test/ohmyposh/*.json`
6. Review the generated files. If everything looks correct, copy them manually:
   ```sh
   cp -r prompts/builder/test/starship/* prompts/starship/themes/
   cp -r prompts/builder/test/ohmyposh/* prompts/ohmyposh/themes/
   ```
7. For `tokio.toml` (right-prompt variant), apply `right_format` manually after copying.

## Template variables

| Variable | Example output |
|---|---|
| `{{ color0 }}` | `#0a0a0a` |
| `{{ color0_hex }}` | `0a0a0a` |
| `{{ color0_r }}` | `10` |
| `{{ color0_g }}` | `10` |
| `{{ color0_b }}` | `10` |
| `{{ color0_rf }}` | `0.039` |
| `{{ background }}` | `#050505` |
| `{{ foreground }}` | `#f7f1ff` |

## Canonical colour mapping

All prompt themes follow this mapping from ANSI colour numbers to prompt elements:

| ANSI | Prompt usage |
|---|---|
| color0 | session / git / cmd / status / battery background |
| color1 | time background, error character, status error |
| color2 | character success |
| color3 | username text (user mode), battery full |
| color5 | OS section background |
| color6 | directory background/foreground, language version text |
| color7 | hostname text, git branch/status text |
| color8 | language tool version background |

## Preview generation

```sh
python3 prompts/builder/preview.py        # prompt previews (PNG + GIF)
python3 prompts/builder/preview_terminal.py  # terminal/xfetch previews (PNG + GIF)
```

Previews are saved to `prompts/previews/`.
