#!/usr/bin/env bash
# Kodra macOS — Install bat (cat replacement with syntax highlighting)
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_install bat

# Configure bat theme
mkdir -p "$HOME/.config/bat"
cat > "$HOME/.config/bat/config" << 'EOF'
--theme="TwoDark"
--style="numbers,changes,header"
--italic-text=always
EOF
