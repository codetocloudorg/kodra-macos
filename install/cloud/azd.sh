#!/usr/bin/env bash
# Kodra macOS — Install Azure Developer CLI (azd)
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew tap azure/azd 2>/dev/null || true
brew_install azd
