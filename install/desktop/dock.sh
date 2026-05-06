#!/usr/bin/env bash
# Kodra macOS — Dock customization (native defaults)
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

# Dock behavior
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.3
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 64
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mineffect -string "scale"

# Position dock at bottom
defaults write com.apple.dock orientation -string "bottom"

# Remove all default dock items and add dev-focused ones
defaults write com.apple.dock persistent-apps -array

# Add apps to dock (only if they exist)
add_dock_app() {
    local app_path="$1"
    if [[ -d "$app_path" ]]; then
        defaults write com.apple.dock persistent-apps -array-add \
            "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$app_path</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    fi
}

add_dock_app "/System/Applications/Launchpad.app"
add_dock_app "/Applications/Ghostty.app"
add_dock_app "/Applications/Visual Studio Code.app"
add_dock_app "/System/Applications/System Settings.app"

# Restart Dock to apply
killall Dock 2>/dev/null || true

log_debug "Dock configured — minimal developer layout"
