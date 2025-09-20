#!/bin/bash

# Get UUID of default profile
DEFAULT_UUID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")

# Create new UUID to xtropicalneon profile
NEW_UUID=$(uuidgen)

# Add new profile to the list
PROFILE_LIST=$(gsettings get org.gnome.Terminal.ProfilesList list)
NEW_LIST=$(echo "$PROFILE_LIST" | sed "s/]$/, '$NEW_UUID']/")
gsettings set org.gnome.Terminal.ProfilesList list "$NEW_LIST"

# New profile
PROFILE_PATH="org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$NEW_UUID/"

# Apply the palette
gsettings set $PROFILE_PATH visible-name 'xtropicalneon'
gsettings set $PROFILE_PATH use-theme-colors false
gsettings set $PROFILE_PATH background-color '#000000'
gsettings set $PROFILE_PATH foreground-color '#ffffff'
gsettings set $PROFILE_PATH use-transparent-background true
gsettings set $PROFILE_PATH background-transparency-percent 15
gsettings set $PROFILE_PATH palette "['#000000', '#ff5151', '#00ff87', '#ffe600', '#00b7ff', '#d99dff', '#00ffd1', '#ffffff', '#111111', '#ff8787', '#50fa7b', '#ffffa5', '#79d9ff', '#ff00a8', '#41b3ff', '#ffffff']"

# As default
gsettings set org.gnome.Terminal.ProfilesList default "'$NEW_UUID'"

echo "Profile 'xtropicalneon' created with transparency, now as default."
