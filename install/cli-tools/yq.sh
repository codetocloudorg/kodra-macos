#!/usr/bin/env bash
# Kodra macOS — Install yq (YAML processor)
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

if has_command yq; then
    log_debug "yq already available"
else
    brew_install yq
fi
