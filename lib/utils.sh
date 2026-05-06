#!/usr/bin/env bash
#
# Kodra macOS — Utility Functions
#

# Run an installer script with error handling and failure tracking
run_installer() {
    local script="$1"
    local name
    name="$(basename "$script" .sh)"

    if [[ ! -f "$script" ]]; then
        log_warn "Installer not found: $script"
        return 1
    fi

    KODRA_INSTALL_COUNT=$((${KODRA_INSTALL_COUNT:-0} + 1))

    log_info "Installing $name..."

    if bash "$script" 2>&1; then
        log_success "$name installed"
        save_state "tool.$name" "installed"
    else
        if [[ "$KODRA_DEBUG" == "true" ]]; then
            log_error "$name failed (continuing in debug mode)"
            save_state "tool.$name" "failed"
            KODRA_FAIL_COUNT=$((${KODRA_FAIL_COUNT:-0} + 1))
            KODRA_FAILED_INSTALLS="${KODRA_FAILED_INSTALLS}${name}\n"
        else
            log_error "$name installation failed"
            save_state "tool.$name" "failed"
            exit 1
        fi
    fi
}

# Check if a command exists
has_command() {
    command -v "$1" &>/dev/null
}

# Get Homebrew prefix (handles Apple Silicon vs Intel)
brew_prefix() {
    if [[ -d /opt/homebrew ]]; then
        echo "/opt/homebrew"
    else
        echo "/usr/local"
    fi
}

# Ensure Homebrew is in PATH
ensure_brew_path() {
    if ! has_command brew; then
        local prefix
        prefix="$(brew_prefix)"
        if [[ -f "$prefix/bin/brew" ]]; then
            eval "$("$prefix/bin/brew" shellenv)"
        fi
    fi
}

# Install a Homebrew formula if not present
brew_install() {
    local formula="$1"
    ensure_brew_path
    if ! brew list "$formula" &>/dev/null; then
        brew install "$formula"
    else
        log_debug "$formula already installed"
    fi
}

# Install a Homebrew cask if not present
brew_cask_install() {
    local cask="$1"
    ensure_brew_path
    if ! brew list --cask "$cask" &>/dev/null; then
        brew install --cask "$cask"
    else
        log_debug "$cask already installed"
    fi
}

# Get the current shell config file
shell_config_file() {
    if [[ "$SHELL" == */zsh ]]; then
        echo "$HOME/.zshrc"
    elif [[ "$SHELL" == */bash ]]; then
        echo "$HOME/.bash_profile"
    else
        echo "$HOME/.profile"
    fi
}

# Append a line to shell config if not present
append_to_shell_config() {
    local line="$1"
    local config
    config="$(shell_config_file)"

    if ! grep -qF "$line" "$config" 2>/dev/null; then
        echo "$line" >> "$config"
    fi
}
