#!/usr/bin/env bash
# Kodra macOS — Uninstall OpenTofu
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing OpenTofu..."
brew uninstall opentofu 2>/dev/null || true

if [[ -d "$HOME/.opentofu" ]]; then
    rm -rf "$HOME/.opentofu"
    log_success "Removed ~/.opentofu"
fi

if ! has_command tofu; then
    log_success "OpenTofu uninstalled"
else
    log_error "OpenTofu still present"
    exit 1
fi
