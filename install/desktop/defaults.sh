#!/usr/bin/env bash
# Kodra macOS — System defaults customization (native macOS)
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

# ─── Keyboard ─────────────────────────────────────────────────
# Fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Disable auto-correct and smart features for dev work
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# ─── Trackpad ─────────────────────────────────────────────────
# Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# ─── Screenshots ──────────────────────────────────────────────
# Save to ~/Screenshots instead of Desktop
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ─── Mission Control ──────────────────────────────────────────
# Don't rearrange spaces by usage
defaults write com.apple.dock mru-spaces -bool false

# Hot corners: bottom-right = Mission Control
defaults write com.apple.dock wvous-br-corner -int 2
defaults write com.apple.dock wvous-br-modifier -int 0

# ─── Menu Bar ─────────────────────────────────────────────────
# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# ─── Appearance ───────────────────────────────────────────────
# Dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Accent color: purple (matches Kodra branding)
defaults write NSGlobalDomain AppleAccentColor -int 5
defaults write NSGlobalDomain AppleHighlightColor -string "0.968627 0.831373 1.000000 Purple"

log_debug "System defaults configured — developer-optimized"
