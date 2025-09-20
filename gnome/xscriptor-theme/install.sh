#!/bin/bash

# Xscriptor Theme installation script for GNOME Terminal
# Author: Xscriptor
# Description: Installs Xscriptor theme based on VSCode Xscriptor theme color palette

set -e

echo "Installing Xscriptor theme for GNOME Terminal..."

# Verificar si dconf está disponible
if ! command -v dconf &> /dev/null; then
    echo "Error: dconf is not installed. Please install it first:"
    echo "   Ubuntu/Debian: sudo apt install dconf-cli"
    echo "   Fedora: sudo dnf install dconf"
    echo "   Arch: sudo pacman -S dconf"
    exit 1
fi

# Verificar si GNOME Terminal está instalado
if ! command -v gnome-terminal &> /dev/null; then
    echo "Error: GNOME Terminal is not installed."
    exit 1
fi

# Función para verificar si un UUID ya existe
check_uuid_exists() {
    local uuid=$1
    dconf list /org/gnome/terminal/legacy/profiles:/ | grep -q ":$uuid/" 2>/dev/null
}

# Generar UUID único para el perfil
echo "Generating unique UUID for profile..."
PROFILE_UUID=$(uuidgen)

# Verificar si el UUID ya existe y generar uno nuevo si es necesario
while check_uuid_exists "$PROFILE_UUID"; do
    echo "UUID $PROFILE_UUID already exists, generating new one..."
    PROFILE_UUID=$(uuidgen)
done

PROFILE_PATH="/org/gnome/terminal/legacy/profiles:/:$PROFILE_UUID/"

echo "Creating profile with UUID: $PROFILE_UUID"

# Obtener lista actual de perfiles
CURRENT_PROFILES=$(dconf read /org/gnome/terminal/legacy/profiles:/list | tr -d "[]'" | tr ',' '\n' | grep -v '^$' || true)

# Agregar el nuevo perfil a la lista
if [ -z "$CURRENT_PROFILES" ]; then
    NEW_PROFILES="['$PROFILE_UUID']"
else
    # Construir la lista de perfiles de forma más segura
    PROFILE_LIST=$(echo "$CURRENT_PROFILES" | sed "s/^/'/ ; s/$/',/" | tr -d '\n' | sed 's/,$//')
    NEW_PROFILES="[$PROFILE_LIST,'$PROFILE_UUID']"
fi

# Aplicar configuración del perfil
echo "Applying theme configuration..."

dconf write /org/gnome/terminal/legacy/profiles:/list "$NEW_PROFILES"
dconf write "${PROFILE_PATH}visible-name" "'Xscriptor Theme'"
dconf write "${PROFILE_PATH}palette" "['#363537', '#fc618d', '#7bd88f', '#fce566', '#fd9353', '#948ae3', '#5ad4e6', '#f7f1ff', '#69676c', '#fc618d', '#7bd88f', '#fce566', '#fd9353', '#948ae3', '#5ad4e6', '#f7f1ff']"
dconf write "${PROFILE_PATH}background-color" "'#050505'"
dconf write "${PROFILE_PATH}foreground-color" "'#f7f1ff'"
dconf write "${PROFILE_PATH}use-theme-colors" "false"
dconf write "${PROFILE_PATH}use-theme-transparency" "false"
dconf write "${PROFILE_PATH}use-transparent-background" "false"
dconf write "${PROFILE_PATH}background-transparency-percent" "0"
dconf write "${PROFILE_PATH}bold-color-same-as-fg" "true"
dconf write "${PROFILE_PATH}bold-color" "'#f7f1ff'"
dconf write "${PROFILE_PATH}cursor-colors-set" "true"
dconf write "${PROFILE_PATH}cursor-background-color" "'#f7f1ff'"
dconf write "${PROFILE_PATH}cursor-foreground-color" "'#050505'"
dconf write "${PROFILE_PATH}highlight-colors-set" "true"
dconf write "${PROFILE_PATH}highlight-background-color" "'#bab6c026'"
dconf write "${PROFILE_PATH}highlight-foreground-color" "'#f7f1ff'"

# Establecer como perfil por defecto (opcional)
read -p "Do you want to set Xscriptor theme as the default profile? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    dconf write /org/gnome/terminal/legacy/profiles:/default "'$PROFILE_UUID'"
    echo "X theme set as default profile"
fi

echo "X theme installed successfully!"
echo "To use the theme:"
echo "   1. Open GNOME Terminal"
echo "   2. Go to Preferences > Profiles"
echo "   3. Select 'Xscriptor Theme'"
echo "   4. Enjoy your new theme!"
echo
echo "Tip: You can also create a new window with the theme using:"
echo "   gnome-terminal --profile='Xscriptor Theme'"