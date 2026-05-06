#!/usr/bin/env bash
# Kodra macOS — Uninstall k9s
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing k9s..."
brew uninstall k9s 2>/dev/null || true

if [[ -d "$HOME/.config/k9s" ]]; then
    rm -rf "$HOME/.config/k9s"
    log_success "Removed ~/.config/k9s"
fi

if ! has_command k9s; then
    log_success "k9s uninstalled"
else
    log_error "k9s still present"
    exit 1
fi
