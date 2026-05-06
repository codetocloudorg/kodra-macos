#!/usr/bin/env bash
# Kodra macOS — Finder customization (native defaults)
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

# Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar and status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Default to list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show ~/Library folder
chflags nohidden ~/Library 2>/dev/null || true

# Show full path in title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Avoid creating .DS_Store on network/USB
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Restart Finder
killall Finder 2>/dev/null || true

log_debug "Finder configured — developer-friendly settings"
