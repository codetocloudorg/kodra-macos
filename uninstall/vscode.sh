#!/usr/bin/env bash
# Kodra macOS — Uninstall Visual Studio Code
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing Visual Studio Code..."
brew uninstall --cask visual-studio-code 2>/dev/null || true

if [[ -d "$HOME/Library/Application Support/Code" ]]; then
    rm -rf "$HOME/Library/Application Support/Code"
    log_success "Removed ~/Library/Application Support/Code"
fi

if ! has_command code; then
    log_success "VS Code uninstalled"
else
    log_error "VS Code still present"
    exit 1
fi
