#!/usr/bin/env bash
# Kodra macOS — Install Ghostty terminal
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_cask_install ghostty

# Configure Ghostty with Tokyo Night theme
mkdir -p "$HOME/.config/ghostty"
cat > "$HOME/.config/ghostty/config" << 'EOF'
# Kodra macOS — Ghostty Configuration
font-family = JetBrainsMono Nerd Font
font-size = 14
theme = tokyonight

window-padding-x = 12
window-padding-y = 8
window-decoration = true

cursor-style = block
cursor-style-blink = true

copy-on-select = clipboard
confirm-close-surface = false

# macOS native
macos-titlebar-style = tabs
macos-option-as-alt = true

# Split keybindings (Cmd+D vertical, Cmd+Shift+D horizontal)
keybind = super+d=new_split:right
keybind = super+shift+d=new_split:down
keybind = super+shift+enter=toggle_split_zoom
keybind = super+alt+left=goto_split:left
keybind = super+alt+right=goto_split:right
keybind = super+alt+up=goto_split:top
keybind = super+alt+down=goto_split:bottom
EOF
