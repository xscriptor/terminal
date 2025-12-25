# Xscriptor GNOME Terminal Themes

Este folder contiene perfiles de GNOME Terminal (vía dconf) y un instalador que carga los temas Xscriptor, asegura dependencias y añade aliases para cambiar de tema rápidamente.

## Files
- `install.sh`: Instala los perfiles y añade aliases para cambio de tema.
- `themes/*.sh`: Scripts opcionales que aplican colores al perfil por defecto usando dconf.
- `dconf/*.dconf`: Dumps de perfiles listos para importar con `dconf load`:
  - `xscriptor-theme.dconf`
  - `xscriptor-theme-light.dconf`
  - `x-retro.dconf`
  - `x-dark-candy.dconf`
  - `x-candy-pop.dconf`
  - `x-sense.dconf`
  - `x-summer-night.dconf`
  - `x-nord.dconf`
  - `x-nord-inverted.dconf`
  - `x-greyscale.dconf`
  - `x-greyscale-inverted.dconf`
  - `x-dark-colors.dconf`
  - `x-persecution.dconf`

## Requirements
- GNOME Terminal.
- `dconf` y `gsettings`.
- `sed`, `bash` o `zsh`.
- `curl` o `wget`.

## Instalación
- One-liner:
```bash
wget -qO- https://raw.githubusercontent.com/xscriptordev/terminal/main/gnome-terminal/install.sh | bash
```

o

- Descarga el repo, ve a la carpeta y ejecuta el instalador:
  - `chmod +x install.sh && ./install.sh`
- Qué hace el instalador:
  - Detecta tu gestor de paquetes e instala dependencias faltantes (`dconf-cli`, `glib2/gsettings`, `sed`, `curl/wget`).
  - Importa los perfiles desde `dconf/*.dconf` (local o remoto si no existen localmente).
  - Asegura que todos los UUID de los temas estén en `org.gnome.Terminal.ProfilesList`.
  - Establece por defecto el perfil de Xscriptor.
  - Añade aliases de shell para cambiar el perfil activo por defecto.

## Aliases
- Tras la instalación, se añaden los siguientes aliases:
  - `gtxscriptor`, `gtxscriptorlight`, `gtxretro`, `gtxdark`, `gtxdarkcandy`, `gtxcandy`, `gtxcandypop`, `gtxsense`, `gtxsummer`, `gtxnord`, `gtxnordinverted`, `gtxgreyscale`, `gtxgreyscaleinv`, `gtxpersecution`
- Uso:
  - `gtxscriptor` → establece el perfil Xscriptor como perfil por defecto en GNOME Terminal.
- Recarga tu shell:
  - `source ~/.bashrc` o `source ~/.zshrc`

## Notas
- Los perfiles se guardan en dconf bajo `/org/gnome/terminal/legacy/profiles:/`.
- Puedes seleccionar el perfil manualmente en GNOME Terminal: Preferencias → Perfiles.
- Si los perfiles no aparecen, cierra y abre GNOME Terminal, o verifica que `dconf` está disponible.

## Troubleshooting
- Aliases no disponibles:
  - Recarga tu archivo de shell (`~/.bashrc`/`~/.zshrc`) o abre una nueva sesión.
- Perfiles no visibles:
  - Asegura que `dconf load` se ejecutó sin errores; revisa permisos y rutas.
- Cambios no aplicados:
  - Verifica el perfil por defecto con `gsettings get org.gnome.Terminal.ProfilesList default`.

## Referencias
- Instalador: [install.sh](file:///Users/xscriptor/Documents/repos/xscriptordev/terminal/gnome-terminal/install.sh)
