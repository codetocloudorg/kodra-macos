#!/usr/bin/env bash
# Kodra macOS — Uninstall fzf
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing fzf..."
brew uninstall fzf 2>/dev/null || true

rm -rf "$HOME"/.fzf* 2>/dev/null

if ! has_command fzf; then
    log_success "fzf uninstalled"
else
    log_error "fzf still present"
    exit 1
fi
