#!/usr/bin/env bash
# Kodra macOS — Install zoxide (smart cd replacement)
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_install zoxide

# Add zoxide init to shell config
append_to_shell_config 'eval "$(zoxide init zsh)"'
