#!/usr/bin/env bash
# Kodra macOS — Uninstall btop
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing btop..."
brew uninstall btop 2>/dev/null || true

if [[ -d "$HOME/.config/btop" ]]; then
    rm -rf "$HOME/.config/btop"
    log_success "Removed ~/.config/btop"
fi

if ! has_command btop; then
    log_success "btop uninstalled"
else
    log_error "btop still present"
    exit 1
fi
