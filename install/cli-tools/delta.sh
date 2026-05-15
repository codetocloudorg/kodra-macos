#!/usr/bin/env bash
# Kodra macOS — Install delta (beautiful git diffs with syntax highlighting)
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_install git-delta

# Configure git to use delta as the pager
if has_command delta; then
    git config --global core.pager delta
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.side-by-side true
    git config --global delta.line-numbers true
    git config --global merge.conflictstyle diff3
    git config --global diff.colorMoved default
fi
