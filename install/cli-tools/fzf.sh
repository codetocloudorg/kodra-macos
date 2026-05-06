#!/usr/bin/env bash
# Kodra macOS — Install fzf (fuzzy finder)
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_install fzf

# Install key bindings and completion (non-interactive)
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish 2>/dev/null || true
