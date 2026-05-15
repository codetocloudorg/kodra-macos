#!/usr/bin/env bash
# Kodra macOS — Install direnv (per-directory environment variables)
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_install direnv

# Hook direnv into zsh
append_to_shell_config 'eval "$(direnv hook zsh)"'
