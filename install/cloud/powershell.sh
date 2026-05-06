#!/usr/bin/env bash
# Kodra macOS — Install PowerShell 7 via official Microsoft .pkg
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

if has_command pwsh; then
    log_debug "PowerShell already installed"
    return 0 2>/dev/null || exit 0
fi

# Determine architecture
ARCH="$(uname -m)"
if [[ "$ARCH" == "arm64" ]]; then
    PKG_ARCH="arm64"
else
    PKG_ARCH="x64"
fi

# Fetch latest stable version from GitHub releases
PWSH_VERSION=$(curl -fsSL "https://api.github.com/repos/PowerShell/PowerShell/releases/latest" \
    | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

if [[ -z "$PWSH_VERSION" ]]; then
    log_warn "Could not determine PowerShell version — skipping"
    exit 0
fi

PKG_URL="https://github.com/PowerShell/PowerShell/releases/download/v${PWSH_VERSION}/powershell-${PWSH_VERSION}-osx-${PKG_ARCH}.pkg"
PKG_FILE="/tmp/powershell-${PWSH_VERSION}.pkg"

log_debug "Downloading PowerShell $PWSH_VERSION for $PKG_ARCH..."
curl -fsSL -o "$PKG_FILE" "$PKG_URL"

# Install via native macOS installer
sudo installer -pkg "$PKG_FILE" -target / 2>/dev/null

# Cleanup
rm -f "$PKG_FILE"

if has_command pwsh; then
    log_debug "PowerShell $(pwsh --version) installed via .pkg"
fi
