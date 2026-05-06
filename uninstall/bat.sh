#!/usr/bin/env bash
# Kodra macOS — Uninstall bat
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing bat..."
brew uninstall bat 2>/dev/null || true

if ! has_command bat; then
    log_success "bat uninstalled"
else
    log_error "bat still present"
    exit 1
fi
