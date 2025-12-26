# PuTTY Themes (Xscriptor)

This folder provides ready-to-import PuTTY color themes as .reg files. Each file creates a PuTTY “Session” preconfigured with the theme’s colors.

## Files
- Location: `putty/themes`
- Includes: Xscriptor, Xscriptor Light, X Retro, X Dark One, X Candy Pop, X Sense, X Summer Night, X Nord, X Nord Inverted, X Greyscale, X Greyscale Inverted, X Dark Colors, X Persecution

## Install
- On Windows, double-click any `.reg` file and allow the merge
- Open PuTTY → Saved Sessions → select the newly added session (e.g. “Xscriptor”), set Host Name, then Save
- To use it as the global default, you can import the file and then copy values to “Default Settings”, or replace the session name in the `.reg` file with `Default%20Settings` before importing

## Notes
- Import writes to `HKCU\Software\SimonTatham\PuTTY\Sessions`
- Colors are per session; apply to each saved connection you use

