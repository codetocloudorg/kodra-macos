#!/usr/bin/env bash
# Kodra macOS — Uninstall GitHub CLI
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing GitHub CLI..."
brew uninstall gh 2>/dev/null || true

if [[ -d "$HOME/.config/gh" ]]; then
    rm -rf "$HOME/.config/gh"
    log_success "Removed ~/.config/gh"
fi

if ! has_command gh; then
    log_success "GitHub CLI uninstalled"
else
    log_error "GitHub CLI still present"
    exit 1
fi
