#!/usr/bin/env bash
# Kodra macOS — Uninstall lazydocker
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing lazydocker..."
brew uninstall lazydocker 2>/dev/null || true

if ! has_command lazydocker; then
    log_success "lazydocker uninstalled"
else
    log_error "lazydocker still present"
    exit 1
fi
