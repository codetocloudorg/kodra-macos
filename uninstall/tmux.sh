#!/usr/bin/env bash
# Kodra macOS — Uninstall tmux
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing tmux..."
brew uninstall tmux 2>/dev/null || true

if [[ -f "$HOME/.tmux.conf" ]]; then
    rm -f "$HOME/.tmux.conf"
    log_success "Removed ~/.tmux.conf"
fi

if [[ -f "$HOME/.config/ghostty/sidebar-menu.sh" ]]; then
    rm -f "$HOME/.config/ghostty/sidebar-menu.sh"
    log_success "Removed sidebar-menu.sh"
fi

log_success "tmux uninstalled"
