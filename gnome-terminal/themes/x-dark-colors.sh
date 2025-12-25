#!/usr/bin/env sh
PROFILE_ID="$(dconf read /org/gnome/terminal/legacy/profiles:/default | tr -d \"'\")"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/use-theme-colors "false"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/background-color "'#1a1a1a'"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/foreground-color "'#ffffff'"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/palette "['#1a1a1a', '#ff5555', '#b8e6a0', '#ffe4a3', '#bd93f9', '#ff9aa2', '#8be9fd', '#ffffff', '#6272a4', '#ff6e6e', '#b8e6a0', '#ffe4a3', '#d6acff', '#ff9aa2', '#a4ffff', '#ffffff']"
