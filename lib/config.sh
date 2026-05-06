#!/usr/bin/env bash
#
# Kodra macOS — Configuration Management
# Key=Value settings file management
#

KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
KODRA_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/kodra/settings"

source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true

# Default settings
declare -A KODRA_DEFAULTS=(
    [motd_style]="banner"
    [auto_update]="true"
    [shell]="zsh"
    [theme]="default"
)

# Ensure the config file exists with defaults
_init_config() {
    local config_dir
    config_dir="$(dirname "$KODRA_CONFIG_FILE")"
    mkdir -p "$config_dir"

    if [[ ! -f "$KODRA_CONFIG_FILE" ]]; then
        for key in "${!KODRA_DEFAULTS[@]}"; do
            echo "${key}=${KODRA_DEFAULTS[$key]}" >> "$KODRA_CONFIG_FILE"
        done
    fi
}

# Get a config value (returns default if not set)
get_config() {
    local key="$1"
    local default="${2:-${KODRA_DEFAULTS[$key]:-}}"

    _init_config

    local value
    value="$(grep -E "^${key}=" "$KODRA_CONFIG_FILE" 2>/dev/null | head -1 | cut -d'=' -f2-)"

    if [[ -n "$value" ]]; then
        echo "$value"
    else
        echo "$default"
    fi
}

# Set a config value (creates or updates)
set_config() {
    local key="$1"
    local value="$2"

    if [[ -z "$key" || -z "$value" ]]; then
        log_error "Usage: set_config <key> <value>"
        return 1
    fi

    _init_config

    if grep -qE "^${key}=" "$KODRA_CONFIG_FILE" 2>/dev/null; then
        # Update existing — BSD sed requires -i ''
        sed -i '' "s|^${key}=.*|${key}=${value}|" "$KODRA_CONFIG_FILE"
    else
        # Append new key
        echo "${key}=${value}" >> "$KODRA_CONFIG_FILE"
    fi
}

# Reset all settings to defaults
reset_config() {
    _init_config

    : > "$KODRA_CONFIG_FILE"

    for key in "${!KODRA_DEFAULTS[@]}"; do
        echo "${key}=${KODRA_DEFAULTS[$key]}" >> "$KODRA_CONFIG_FILE"
    done

    log_success "Configuration reset to defaults"
}
