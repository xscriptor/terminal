#!/usr/bin/env sh
PROFILE_ID="$(dconf read /org/gnome/terminal/legacy/profiles:/default | tr -d \"'\")"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/use-theme-colors "false"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/background-color "'#140706'"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/foreground-color "'#f7f1ff'"
dconf write /org/gnome/terminal/legacy/profiles:/:$PROFILE_ID/palette "['#222222', '#fc618d', '#7bd88f', '#ffed89', '#47e6ff', '#ff9999', '#47e6ff', '#f7f1ff', '#525053', '#fc618d', '#7bd88f', '#ffed89', '#47e6ff', '#ff9999', '#47e6ff', '#f7f1ff']"
