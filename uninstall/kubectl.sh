#!/usr/bin/env bash
# Kodra macOS — Uninstall kubectl
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing kubectl..."
brew uninstall kubectl 2>/dev/null || true

if [[ -d "$HOME/.kube" ]]; then
    rm -rf "$HOME/.kube"
    log_success "Removed ~/.kube"
fi

if ! has_command kubectl; then
    log_success "kubectl uninstalled"
else
    log_error "kubectl still present"
    exit 1
fi
