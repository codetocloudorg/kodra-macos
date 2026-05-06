#!/usr/bin/env bash
# Kodra macOS — Uninstall Helm
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing Helm..."
brew uninstall helm 2>/dev/null || true

if [[ -d "$HOME/.config/helm" ]]; then
    rm -rf "$HOME/.config/helm"
    log_success "Removed ~/.config/helm"
fi

if ! has_command helm; then
    log_success "Helm uninstalled"
else
    log_error "Helm still present"
    exit 1
fi
