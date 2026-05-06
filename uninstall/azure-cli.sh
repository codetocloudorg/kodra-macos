#!/usr/bin/env bash
# Kodra macOS — Uninstall Azure CLI
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing Azure CLI..."
brew uninstall azure-cli 2>/dev/null || true

if [[ -d "$HOME/.azure" ]]; then
    rm -rf "$HOME/.azure"
    log_success "Removed ~/.azure"
fi

if ! has_command az; then
    log_success "Azure CLI uninstalled"
else
    log_error "Azure CLI still present"
    exit 1
fi
