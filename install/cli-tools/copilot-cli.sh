#!/usr/bin/env bash
# Kodra macOS — Install GitHub Copilot CLI (standalone + gh extension)
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

# Install standalone Copilot CLI (provides 'copilot' command)
# https://formulae.brew.sh/cask/copilot-cli
brew_cask_install copilot-cli

# Also install gh copilot extension if gh is available
if has_command gh; then
    if ! gh extension list 2>/dev/null | grep -q "copilot"; then
        gh extension install github/gh-copilot 2>/dev/null || true
    fi
    log_debug "GitHub Copilot gh extension ready"
fi
