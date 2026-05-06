#!/usr/bin/env bash
# Kodra macOS — Install Visual Studio Code
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_cask_install visual-studio-code

# Install essential extensions
if has_command code; then
    local extensions=(
        "github.copilot"
        "github.copilot-chat"
        "enkia.tokyo-night"
        "ms-azuretools.vscode-bicep"
        "hashicorp.terraform"
        "ms-vscode.azure-account"
        "ms-azuretools.vscode-docker"
    )
    for ext in "${extensions[@]}"; do
        code --install-extension "$ext" --force 2>/dev/null || true
    done
fi
