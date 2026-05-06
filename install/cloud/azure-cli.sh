#!/usr/bin/env bash
# Kodra macOS — Install Azure CLI
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

if has_command az; then
    log_debug "Azure CLI already available"
else
    brew_install azure-cli
fi
