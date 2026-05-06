#!/usr/bin/env bash
# Kodra macOS — Uninstall Bicep
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing Bicep..."
brew uninstall bicep 2>/dev/null || true

if [[ -d "$HOME/.bicep" ]]; then
    rm -rf "$HOME/.bicep"
    log_success "Removed ~/.bicep"
fi

if ! has_command bicep; then
    log_success "Bicep uninstalled"
else
    log_error "Bicep still present"
    exit 1
fi
