#!/usr/bin/env bash
# Kodra macOS — Install GitHub CLI
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

if has_command gh; then
    log_debug "GitHub CLI already available"
else
    brew_install gh
fi
