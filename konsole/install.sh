#!/bin/bash

# Xscriptor Theme Installer for Konsole (KDE)
# This script installs the Xscriptor theme for Konsole

set -e

echo "Installing Xscriptor theme for Konsole..."

# Check if Konsole is installed
if ! command -v konsole &> /dev/null; then
    echo "Error: Konsole is not installed on this system."
    echo "Please install Konsole first: sudo apt install konsole"
    exit 1
fi
