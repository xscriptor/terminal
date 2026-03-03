# Xscriptor Terminal — Roadmap

## Phase 1: Core Theme Library <!-- phase:core-themes -->

- [x] Define base color palette reference (references.md)
- [x] Create theme: x
- [x] Create theme: madrid
- [x] Create theme: lahabana
- [x] Create theme: seul
- [x] Create theme: miami
- [x] Create theme: paris
- [x] Create theme: tokio
- [x] Create theme: oslo
- [x] Create theme: helsinki
- [x] Create theme: berlin
- [x] Create theme: london
- [x] Create theme: praha
- [x] Create theme: bogota
- [x] Reorder themes according to the primary palette and variant sets
- [x] Rename themes to city-based naming convention
- [x] Create theme variants: Light, High-Contrast, Colorblind-safe

## Phase 2: Terminal Ports <!-- phase:terminal-ports -->

- [x] Port themes to GNOME Terminal (dconf + themes)
- [x] Port themes to iTerm2 (.itermcolors)
- [x] Port themes to Kitty (conf themes)
- [x] Port themes to Konsole (.colorscheme)
- [x] Port themes to PowerShell (JSON settings)
- [x] Port themes to Ptyxis (palette files)
- [x] Port themes to XFCE Terminal (terminalrc)
- [x] Port themes to Alacritty (.toml themes)
- [x] Port themes to WezTerm (.toml themes)
- [x] Port themes to Ghostty (config + styles)
- [x] Port themes to Terminal.app (macOS .terminal)
- [x] Port themes to Hyper (.js plugin)
- [x] Port themes to Tilix (JSON themes)
- [x] Port themes to Terminator (config themes)
- [x] Port themes to Termux (.properties)
- [x] Port themes to Foot (ini themes)
- [x] Port themes to Warp (.yaml themes)
- [x] Port themes to PuTTY (.reg registry files)
- [x] Port themes to MobaXterm (.mxtpro)

## Phase 3: Install & Uninstall Scripts <!-- phase:install-scripts -->

- [x] Install script for Alacritty (install.sh)
- [x] Install script for Foot (install.sh)
- [x] Install script for Ghostty (install.sh)
- [x] Install script for GNOME Terminal (install.sh)
- [x] Install script for Hyper (install.sh)
- [x] Install script for iTerm2 (install.sh)
- [x] Install script for Kitty (install.sh)
- [x] Install script for Konsole (install.sh)
- [x] Install script for PowerShell (install.ps1)
- [x] Install script for Ptyxis (install.sh)
- [x] Install script for Terminator (install.sh)
- [x] Install script for Termux (install.sh)
- [x] Install script for Warp (install.sh)
- [x] Install script for WezTerm (install.sh)
- [x] Install script for XFCE Terminal (install.sh)
- [ ] Install script for PuTTY (install.bat / install.ps1) (#1)
- [ ] Install script for MobaXterm (install script) (#2)
- [ ] Install script for Tilix (install.sh) (#3)
- [ ] Install script for Terminal.app (install.sh) (#4)
- [x] Uninstall script for Alacritty (uninstall.sh)
- [x] Uninstall script for Foot (uninstall.sh)
- [x] Uninstall script for Ghostty (uninstall.sh)
- [x] Uninstall script for GNOME Terminal (uninstall.sh)
- [x] Uninstall script for Hyper (uninstall.sh)
- [x] Uninstall script for iTerm2 (uninstall.sh)
- [x] Uninstall script for Kitty (uninstall.sh)
- [x] Uninstall script for Konsole (uninstall.sh)
- [x] Uninstall script for PowerShell (uninstall.ps1)
- [x] Uninstall script for Ptyxis (uninstall.sh)
- [x] Uninstall script for Terminator (uninstall.sh)
- [x] Uninstall script for Warp (uninstall.sh)
- [x] Uninstall script for WezTerm (uninstall.sh)
- [x] Uninstall script for XFCE Terminal (uninstall.sh)
- [ ] Uninstall script for PuTTY (#5)
- [ ] Uninstall script for MobaXterm (#6)
- [ ] Uninstall script for Tilix (#7)
- [ ] Uninstall script for Terminal.app (#8)
- [ ] Uninstall script for Termux (uninstall.sh) (#9)
- [ ] Per-terminal reset.sh to restore original configs (#10)

## Phase 4: Documentation & Previews <!-- phase:documentation -->

- [x] Main project README.md with install instructions
- [x] README for Alacritty
- [x] README for Foot
- [x] README for Ghostty
- [x] README for GNOME Terminal
- [x] README for Hyper
- [x] README for iTerm2
- [x] README for Kitty
- [x] README for Konsole
- [x] README for MobaXterm
- [x] README for PowerShell
- [x] README for Ptyxis
- [x] README for PuTTY
- [x] README for Terminal.app
- [x] README for Terminator
- [x] README for Termux
- [x] README for Tilix
- [x] README for Warp
- [x] README for WezTerm
- [x] README for XFCE Terminal
- [x] Previews for Alacritty
- [x] Previews for Foot
- [x] Previews for Ghostty
- [x] Previews for GNOME Terminal
- [x] Previews for iTerm2
- [x] Previews for Kitty
- [x] Previews for Konsole
- [x] Previews for PowerShell
- [x] Previews for Ptyxis
- [x] Previews for Terminator
- [ ] Previews for Hyper (#11)
- [ ] Previews for MobaXterm (#12)
- [ ] Previews for PuTTY (#13)
- [ ] Previews for Terminal.app (#14)
- [ ] Previews for Termux (#15)
- [ ] Previews for Tilix (#16)
- [ ] Previews for Warp (#17)
- [ ] Previews for WezTerm (#18)
- [ ] Previews for XFCE Terminal (#19)
- [x] Quick import guides per platform (Linux/macOS/Windows)
- [x] Troubleshooting section per terminal (paths, caches, VTE quirks)
- [x] Support policy and compatibility matrix by terminal/version
- [ ] Contribution template for new ports and PR guidelines (CONTRIBUTING.md) (#20)

## Phase 5: Tooling & Automation <!-- phase:tooling -->

- [x] Runtime palette application via OSC 4/10/11 scripts
- [x] CLI tool xscriptor-theme to apply schemes from shell
- [ ] Linter for file structure and required keys per terminal (#21)
- [ ] Contrast and accessibility report (WCAG compliance) (#22)
- [ ] Set up .github/scripts/sync_roadmap.py for Roadmap Sync (#23)
- [ ] Set up .github/workflows/roadmap-sync.yml GitHub Action (#24)

## Phase 6: Integrations & Ecosystem <!-- phase:integrations -->

- [ ] Prompt integrations (Starship/Powerline) aligned to theme (#25)
- [ ] Shell syntax-highlighting theme matching (zsh-syntax-highlighting, fish) (#26)
- [ ] Editor color scheme companions (VS Code, Neovim) (#27)

## Phase 7: Packaging & Releases <!-- phase:packaging -->

- [ ] Packaging: .deb/.rpm for Linux distributions (#28)
- [ ] Packaging: Homebrew Tap for macOS (#29)
- [ ] Packaging: Scoop/Chocolatey manifests for Windows (#30)
- [ ] Releases with semantic versioning and checksums (#31)
- [ ] Quarterly roadmap with measurable goals and milestones (#32)
