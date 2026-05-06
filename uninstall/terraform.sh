#!/usr/bin/env bash
# Kodra macOS — Uninstall Terraform
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing Terraform..."
brew uninstall terraform 2>/dev/null || true

if [[ -d "$HOME/.terraform.d" ]]; then
    rm -rf "$HOME/.terraform.d"
    log_success "Removed ~/.terraform.d"
fi

if ! has_command terraform; then
    log_success "Terraform uninstalled"
else
    log_error "Terraform still present"
    exit 1
fi
