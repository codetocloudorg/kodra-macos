#!/usr/bin/env bash
# Kodra macOS — Uninstall PowerShell
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

log_info "Removing PowerShell..."

# PowerShell on macOS is installed via native .pkg — remove with pkgutil
if pkgutil --pkgs 2>/dev/null | grep -q "com.microsoft.powershell"; then
    pkg_id="$(pkgutil --pkgs 2>/dev/null | grep "com.microsoft.powershell" | head -1)"
    sudo rm -rf /usr/local/microsoft/powershell 2>/dev/null || true
    sudo pkgutil --forget "$pkg_id" 2>/dev/null || true
fi

# Also try Homebrew cask in case it was installed that way
brew uninstall --cask powershell 2>/dev/null || true

if [[ -d "$HOME/.config/powershell" ]]; then
    rm -rf "$HOME/.config/powershell"
    log_success "Removed ~/.config/powershell"
fi

if [[ -d "$HOME/.local/share/powershell" ]]; then
    rm -rf "$HOME/.local/share/powershell"
    log_success "Removed ~/.local/share/powershell"
fi

if ! has_command pwsh; then
    log_success "PowerShell uninstalled"
else
    log_error "PowerShell still present"
    exit 1
fi
