#!/usr/bin/env bash
# Kodra macOS — Install GitHub Copilot CLI extension
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

# Requires gh to be installed first
if has_command gh; then
    # Install Copilot extension if not present
    if ! gh extension list 2>/dev/null | grep -q "copilot"; then
        gh extension install github/gh-copilot 2>/dev/null || true
    fi
    log_debug "GitHub Copilot CLI extension ready"
else
    log_warn "GitHub CLI not found — skipping Copilot CLI"
fi
