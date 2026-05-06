#!/usr/bin/env bash
# Kodra macOS — Install mise (polyglot runtime manager)
# Replaces nvm, pyenv, rbenv, etc.
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_install mise

# Activate mise in shell
append_to_shell_config 'eval "$(mise activate zsh)"'

# Install default runtimes
mise use --global node@lts 2>/dev/null || true
mise use --global python@3.12 2>/dev/null || true
