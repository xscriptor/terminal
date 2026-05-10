#!/usr/bin/env sh
PROFILE_ID="$(dconf read /org/gnome/terminal/legacy/profiles:/default | tr -d \"'\")"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/use-theme-colors "false"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/background-color "'#000000'"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/foreground-color "'#f7f1ff'"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/palette "['#000000', '#ff4c8b', '#7fffd4', '#ffd84c', '#00ffa8', '#d36cff', '#47cfff', '#f7f1ff', '#69676c', '#ff4c8b', '#7fffd4', '#ffd84c', '#00ffa8', '#d36cff', '#47cfff', '#f7f1ff']"
