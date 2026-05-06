#!/usr/bin/env bash
# Kodra macOS — Uninstall eza
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing eza..."
brew uninstall eza 2>/dev/null || true

if ! has_command eza; then
    log_success "eza uninstalled"
else
    log_error "eza still present"
    exit 1
fi
