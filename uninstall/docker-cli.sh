#!/usr/bin/env bash
# Kodra macOS — Uninstall Docker CLI
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing Docker CLI and Compose..."
brew uninstall docker-compose 2>/dev/null || true
brew uninstall docker 2>/dev/null || true

if [[ -d "$HOME/.docker" ]]; then
    rm -rf "$HOME/.docker"
    log_success "Removed ~/.docker"
fi

if ! has_command docker; then
    log_success "Docker CLI uninstalled"
else
    log_error "Docker CLI still present"
    exit 1
fi
