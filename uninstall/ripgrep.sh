#!/usr/bin/env bash
# Kodra macOS — Uninstall ripgrep
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing ripgrep..."
brew uninstall ripgrep 2>/dev/null || true

if ! has_command rg; then
    log_success "ripgrep uninstalled"
else
    log_error "ripgrep still present"
    exit 1
fi
