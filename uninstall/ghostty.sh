#!/usr/bin/env bash
# Kodra macOS — Uninstall Ghostty
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing Ghostty..."
brew uninstall --cask ghostty 2>/dev/null || true

if [[ -d "$HOME/.config/ghostty" ]]; then
    rm -rf "$HOME/.config/ghostty"
    log_success "Removed ~/.config/ghostty"
fi

log_success "Ghostty uninstalled"
