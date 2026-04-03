#!/usr/bin/env bash

set -e

echo "=============================================="
echo " Terminal Xscriptor - Universal Theme Installer "
echo "=============================================="
echo ""
echo "Select the terminal you want to install themes for:"
echo "1) Alacritty"
echo "2) Foot"
echo "3) Ghostty"
echo "4) GNOME Terminal"
echo "5) Hyper"
echo "6) iTerm2"
echo "7) Kitty"
echo "8) Konsole"
echo "9) Ptyxis"
echo "10) Terminator"
echo "11) Termux"
echo "12) Warp"
echo "13) WezTerm"
echo "14) XFCE Terminal"
echo "15) Exit"
echo ""

read -p "Enter your choice (1-15): " choice

url_base="https://raw.githubusercontent.com/xscriptor/terminal/main"

case $choice in
    1)
        echo "Installing Alacritty themes..."
        wget -qO- "$url_base/alacritty/install.sh" | bash
        ;;
    2)
        echo "Installing Foot themes..."
        wget -qO- "$url_base/foot/install.sh" | bash
        ;;
    3)
        echo "Installing Ghostty themes..."
        wget -qO- "$url_base/ghostty/install.sh" | bash
        ;;
    4)
        echo "Installing GNOME Terminal themes..."
        wget -qO- "$url_base/gnome-terminal/install.sh" | bash
        ;;
    5)
        echo "Installing Hyper themes..."
        wget -qO- "$url_base/hyper/install.sh" | bash
        ;;
    6)
        echo "Installing iTerm2 themes..."
        wget -qO- "$url_base/iterm/install.sh" | bash
        ;;
    7)
        echo "Installing Kitty themes..."
        wget -qO- "$url_base/kitty/install.sh" | bash
        ;;
    8)
        echo "Installing Konsole themes..."
        wget -qO- "$url_base/konsole/install.sh" | bash
        ;;
    9)
        echo "Installing Ptyxis themes..."
        wget -qO- "$url_base/ptyxis/install.sh" | bash
        ;;
    10)
        echo "Installing Terminator themes..."
        wget -qO- "$url_base/terminator/install.sh" | bash
        ;;
    11)
        echo "Installing Termux themes..."
        wget -qO- "$url_base/termux/install.sh" | bash
        ;;
    12)
        echo "Installing Warp themes..."
        wget -qO- "$url_base/warp/install.sh" | bash
        ;;
    13)
        echo "Installing WezTerm themes..."
        wget -qO- "$url_base/wezterm/install.sh" | bash
        ;;
    14)
        echo "Installing XFCE Terminal themes..."
        wget -qO- "$url_base/xfce/install.sh" | bash
        ;;
    15)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
