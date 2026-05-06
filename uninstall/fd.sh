#!/usr/bin/env bash
# Kodra macOS — Uninstall fd
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing fd..."
brew uninstall fd 2>/dev/null || true

if ! has_command fd; then
    log_success "fd uninstalled"
else
    log_error "fd still present"
    exit 1
fi
