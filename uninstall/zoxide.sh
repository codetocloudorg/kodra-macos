#!/usr/bin/env bash
# Kodra macOS — Uninstall zoxide
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing zoxide..."
brew uninstall zoxide 2>/dev/null || true

if ! has_command zoxide; then
    log_success "zoxide uninstalled"
else
    log_error "zoxide still present"
    exit 1
fi
