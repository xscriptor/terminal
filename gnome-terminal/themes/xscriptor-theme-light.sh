#!/usr/bin/env sh
PROFILE_ID="$(dconf read /org/gnome/terminal/legacy/profiles:/default | tr -d \"'\")"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/use-theme-colors "false"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/background-color "'#fafafa'"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/foreground-color "'#1a1a1a'"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/palette "['#333333', '#cc0033', '#009933', '#b8860b', '#0099cc', '#6633cc', '#0099cc', '#1a1a1a', '#666666', '#cc0033', '#009933', '#b8860b', '#0099cc', '#6633cc', '#0099cc', '#1a1a1a']"
