#!/usr/bin/env bash
# Kodra macOS — Install Nerd Fonts
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

# Install JetBrains Mono Nerd Font (primary) and Meslo (fallback)
brew tap homebrew/cask-fonts 2>/dev/null || true
brew_cask_install font-jetbrains-mono-nerd-font
brew_cask_install font-meslo-lg-nerd-font
