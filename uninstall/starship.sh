#!/usr/bin/env bash
# Kodra macOS — Uninstall Starship
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing Starship..."
brew uninstall starship 2>/dev/null || true

if [[ -f "$HOME/.config/starship.toml" ]]; then
    rm -f "$HOME/.config/starship.toml"
    log_success "Removed ~/.config/starship.toml"
fi

if ! has_command starship; then
    log_success "Starship uninstalled"
else
    log_error "Starship still present"
    exit 1
fi
