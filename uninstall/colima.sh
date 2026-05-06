#!/usr/bin/env bash
# Kodra macOS — Uninstall Colima
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Stopping Colima..."
colima stop 2>/dev/null || true

# Remove launchd plist
if [[ -f "$HOME/Library/LaunchAgents/com.kodra.colima.plist" ]]; then
    launchctl unload "$HOME/Library/LaunchAgents/com.kodra.colima.plist" 2>/dev/null || true
    rm -f "$HOME/Library/LaunchAgents/com.kodra.colima.plist"
    log_success "Removed Colima launchd plist"
fi

log_info "Removing Colima..."
brew uninstall colima 2>/dev/null || true

if [[ -d "$HOME/.colima" ]]; then
    rm -rf "$HOME/.colima"
    log_success "Removed ~/.colima"
fi

if ! has_command colima; then
    log_success "Colima uninstalled"
else
    log_error "Colima still present"
    exit 1
fi
