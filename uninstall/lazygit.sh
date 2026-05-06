#!/usr/bin/env bash
# Kodra macOS — Uninstall lazygit
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing lazygit..."
brew uninstall lazygit 2>/dev/null || true

if [[ -d "$HOME/.config/lazygit" ]]; then
    rm -rf "$HOME/.config/lazygit"
    log_success "Removed ~/.config/lazygit"
fi

if ! has_command lazygit; then
    log_success "lazygit uninstalled"
else
    log_error "lazygit still present"
    exit 1
fi
