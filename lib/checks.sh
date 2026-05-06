#!/usr/bin/env bash
#
# Kodra macOS — System Checks
#

check_macos_version() {
    local version
    version="$(sw_vers -productVersion)"
    local major
    major="$(echo "$version" | cut -d. -f1)"

    if [[ "$major" -ge 14 ]]; then
        log_success "macOS $version supported"
    else
        log_warn "macOS $version detected — macOS 14+ recommended"
    fi
}

check_apple_silicon() {
    local arch
    arch="$(uname -m)"

    if [[ "$arch" == "arm64" ]]; then
        log_success "Apple Silicon (arm64) ✓"
    else
        log_warn "Intel ($arch) detected — Apple Silicon recommended"
    fi
}

check_homebrew() {
    ensure_brew_path
    if has_command brew; then
        log_success "Homebrew $(brew --version | head -1 | awk '{print $2}') ready"
    else
        log_error "Homebrew not found — run boot.sh first"
        exit 1
    fi
}

check_disk_space() {
    local available_gb
    available_gb=$(df -g "$HOME" | awk 'NR==2 {print $4}')

    if [[ "$available_gb" -ge 10 ]]; then
        log_success "Disk space: ${available_gb}GB available"
    elif [[ "$available_gb" -ge 5 ]]; then
        log_warn "Low disk space: ${available_gb}GB (10GB+ recommended)"
    else
        log_error "Insufficient disk space: ${available_gb}GB (need 5GB+)"
        exit 1
    fi
}
