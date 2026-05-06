#!/usr/bin/env bash
# Kodra macOS — Uninstall Azure Developer CLI (azd)
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing Azure Developer CLI..."
brew uninstall azd 2>/dev/null || true

if [[ -d "$HOME/.azd" ]]; then
    rm -rf "$HOME/.azd"
    log_success "Removed ~/.azd"
fi

if ! has_command azd; then
    log_success "Azure Developer CLI uninstalled"
else
    log_error "Azure Developer CLI still present"
    exit 1
fi
