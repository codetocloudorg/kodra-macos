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

    # Skip if already available (installed by any method)
    if has_command "$formula" && brew list "$formula" &>/dev/null 2>&1; then
        log_debug "$formula already installed"
        return 0
    fi

    # Try to install/link via Homebrew
    if brew list "$formula" &>/dev/null 2>&1; then
        log_debug "$formula already installed via Homebrew"
    else
        brew install "$formula" 2>/dev/null || {
            # If brew install fails, check if command exists anyway
            if has_command "$formula"; then
                log_debug "$formula available (not via Homebrew)"
                return 0
            fi
            return 1
        }
    fi
}

# Install a Homebrew cask if not present
brew_cask_install() {
    local cask="$1"
    ensure_brew_path
    if ! brew list --cask "$cask" &>/dev/null 2>&1; then
        brew install --cask "$cask" 2>/dev/null || {
            log_debug "$cask cask install skipped (may already exist)"
            return 0
        }
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

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Additional utility functions
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Simple internet connectivity check
check_internet_connection() {
    curl -s --connect-timeout 5 --max-time 10 --head https://github.com >/dev/null 2>&1
}

# Echo human-readable duration since START_TIME (epoch seconds)
elapsed_time() {
    local start_time="$1"
    local now
    now="$(date +%s)"
    local elapsed=$(( now - start_time ))

    if [[ "$elapsed" -lt 60 ]]; then
        echo "${elapsed}s"
    elif [[ "$elapsed" -lt 3600 ]]; then
        local mins=$(( elapsed / 60 ))
        local secs=$(( elapsed % 60 ))
        echo "${mins}m ${secs}s"
    else
        local hours=$(( elapsed / 3600 ))
        local mins=$(( (elapsed % 3600) / 60 ))
        echo "${hours}h ${mins}m"
    fi
}

# Trap handler to clean temp files
cleanup_on_exit() {
    local exit_code=$?
    if [[ -n "${KODRA_CLEANUP_FILES:-}" ]]; then
        for f in ${KODRA_CLEANUP_FILES}; do
            rm -rf "$f" 2>/dev/null || true
        done
    fi
    return "$exit_code"
}

# mkdir -p with error handling
ensure_dir() {
    local dir="$1"
    if [[ -z "$dir" ]]; then
        echo "ensure_dir: directory path required" >&2
        return 1
    fi
    if ! mkdir -p "$dir" 2>/dev/null; then
        echo "ensure_dir: failed to create directory: $dir" >&2
        return 1
    fi
}

# Append to log file (delegates to _write_log if available)
log_to_file() {
    local msg="$1"
    if command -v _write_log &>/dev/null; then
        _write_log "INFO" "$msg"
    else
        local log_dir="${HOME}/.local/state/kodra/logs"
        mkdir -p "$log_dir"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] ${msg}" >> "${log_dir}/kodra-$(date +%Y-%m-%d).log"
    fi
}

# Get Kodra version from VERSION file
get_kodra_version() {
    local kodra_root="${KODRA_DIR:-$HOME/.kodra}"
    if [[ -f "$kodra_root/VERSION" ]]; then
        cat "$kodra_root/VERSION"
    else
        echo "unknown"
    fi
}
