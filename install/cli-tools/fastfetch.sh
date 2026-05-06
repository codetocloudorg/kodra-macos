#!/usr/bin/env bash
# Kodra macOS — Install fastfetch (system info)
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_install fastfetch

# Configure fastfetch with Kodra branding
mkdir -p "$HOME/.config/fastfetch"
cat > "$HOME/.config/fastfetch/config.jsonc" << 'EOF'
{
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "small"
    },
    "display": {
        "separator": " → "
    },
    "modules": [
        "title",
        "separator",
        "os",
        "host",
        "kernel",
        "uptime",
        "shell",
        "terminal",
        "cpu",
        "gpu",
        "memory",
        "disk",
        "break",
        "colors"
    ]
}
EOF
