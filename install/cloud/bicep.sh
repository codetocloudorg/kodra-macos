#!/usr/bin/env bash
# Kodra macOS — Install Bicep CLI
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

# Bicep is bundled with Azure CLI, but also install standalone
if has_command az; then
    az bicep install 2>/dev/null || true
    log_debug "Bicep installed via Azure CLI"
fi
