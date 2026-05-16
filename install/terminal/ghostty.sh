#!/usr/bin/env bash
# Kodra macOS — Install Ghostty terminal
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_cask_install ghostty

# Configure Ghostty with Cyberpunk theme
mkdir -p "$HOME/.config/ghostty"
cat > "$HOME/.config/ghostty/config" << 'EOF'
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Kodra macOS — Ghostty Configuration
# Agentic Development Environment ⚡
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ─── Typography ────────────────────────────────────────────────
font-family = JetBrainsMono Nerd Font
font-family-bold = JetBrainsMono Nerd Font
font-family-italic = JetBrainsMono Nerd Font
font-size = 14
adjust-cell-height = 25%

# ─── Theme & Visuals ──────────────────────────────────────────
theme = Cyberpunk
background-opacity = 0.92
background-blur = true
unfocused-split-opacity = 0.85
minimum-contrast = 1.1

# ─── Window ───────────────────────────────────────────────────
window-padding-x = 16
window-padding-y = 12
window-decoration = true
window-padding-balance = true

# ─── Cursor ───────────────────────────────────────────────────
cursor-style = block
cursor-style-blink = true

# ─── Behavior ─────────────────────────────────────────────────
copy-on-select = clipboard
confirm-close-surface = false
link-url = true
scrollback-limit = 50000000

# ─── macOS Native ─────────────────────────────────────────────
macos-titlebar-style = tabs
macos-option-as-alt = true

# ─── Quick Terminal (Cmd+`) ───────────────────────────────────
quick-terminal-position = top
quick-terminal-animation-duration = 0.15
quick-terminal-autohide = true

# ─── Resize ───────────────────────────────────────────────────
resize-overlay = after-first
resize-overlay-position = center
resize-overlay-duration = 500ms

# ─── Splits: Navigation ──────────────────────────────────────
keybind = super+d=new_split:right
keybind = super+shift+d=new_split:down
keybind = super+shift+enter=toggle_split_zoom
keybind = super+alt+left=goto_split:left
keybind = super+alt+right=goto_split:right
keybind = super+alt+up=goto_split:top
keybind = super+alt+down=goto_split:bottom

# ─── Splits: Resize ──────────────────────────────────────────
keybind = super+ctrl+left=resize_split:left,40
keybind = super+ctrl+right=resize_split:right,40
keybind = super+ctrl+up=resize_split:up,20
keybind = super+ctrl+down=resize_split:down,20
keybind = super+shift+0=equalize_splits

# ─── Tabs ─────────────────────────────────────────────────────
keybind = super+t=new_tab
keybind = super+w=close_surface
keybind = super+shift+left=previous_tab
keybind = super+shift+right=next_tab

# ─── Quick Actions ────────────────────────────────────────────
keybind = super+shift+comma=reload_config
keybind = super+k=clear_screen
EOF
