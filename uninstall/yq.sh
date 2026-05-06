#!/usr/bin/env bash
# Kodra macOS — Uninstall yq
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing yq..."
brew uninstall yq 2>/dev/null || true

if ! has_command yq; then
    log_success "yq uninstalled"
else
    log_error "yq still present"
    exit 1
fi
