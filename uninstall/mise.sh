#!/usr/bin/env bash
# Kodra macOS — Uninstall mise
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing mise..."
brew uninstall mise 2>/dev/null || true

if [[ -d "$HOME/.local/share/mise" ]]; then
    rm -rf "$HOME/.local/share/mise"
    log_success "Removed ~/.local/share/mise"
fi

if [[ -d "$HOME/.config/mise" ]]; then
    rm -rf "$HOME/.config/mise"
    log_success "Removed ~/.config/mise"
fi

if ! has_command mise; then
    log_success "mise uninstalled"
else
    log_error "mise still present"
    exit 1
fi
