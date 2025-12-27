# Xscriptor Guake Themes

Instala y aplica paletas de colores Xscriptor en Guake con un instalador que escribe los valores en dconf/gsettings y añade alias para cambiar de tema rápidamente.

## Instalación rápida
- One‑liner:

```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/guake/install.sh | bash
# o
curl -fsSL https://raw.githubusercontent.com/xscriptordev/terminal/main/guake/install.sh | bash
```

- Desde el repositorio:
```bash
chmod +x guake/install.sh && guake/install.sh
```

## Qué hace
- Detecta dconf/gsettings y escribe:
  - Paleta (16 colores) en `/org/guake/style/font/palette`
  - Color de texto en `/org/guake/style/font/color`
  - Color de fondo en `/org/guake/style/background/color`
- Aplica por defecto `xscriptor-theme`.
- Añade alias a tu shell para cambiar rápidamente de tema (prefijo `gqx`).

## Temas disponibles
- xscriptor-theme, xscriptor-theme-light, x-retro, x-dark-candy, x-candy-pop
- x-greyscale, x-greyscale-inverted, x-dark-colors, x-sense, x-nord
- x-nord-inverted, x-summer-night, x-persecution

## Uso
- Cambiar tema:
```bash
guake/install.sh x-nord
```
- Con alias:
```bash
gqxnord
gqxscriptor
gqxsummer
```
- Recarga tu shell si los alias no aparecen:
```bash
source ~/.bashrc
source ~/.zshrc
```

## Requisitos
- Guake instalado.
- `dconf` o `gsettings` disponibles.

