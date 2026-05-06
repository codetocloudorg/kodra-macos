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

check_internet() {
    if curl -s --head --connect-timeout 5 --max-time 10 https://github.com >/dev/null 2>&1; then
        log_success "Internet connectivity ✓"
        return 0
    else
        log_error "No internet connection — cannot reach github.com"
        return 1
    fi
}

check_memory() {
    local total_bytes
    total_bytes="$(sysctl -n hw.memsize 2>/dev/null)"
    local total_gb=$(( total_bytes / 1073741824 ))

    if [[ "$total_gb" -ge 16 ]]; then
        log_success "Memory: ${total_gb}GB RAM"
    elif [[ "$total_gb" -ge 8 ]]; then
        log_warn "Memory: ${total_gb}GB RAM (16GB+ recommended)"
    else
        log_error "Low memory: ${total_gb}GB RAM (8GB+ required)"
        return 1
    fi
}

check_shell() {
    local current_shell
    current_shell="$(basename "${SHELL:-unknown}")"

    if [[ "$current_shell" == "zsh" ]]; then
        log_success "Shell: zsh ✓"
        return 0
    else
        log_warn "Shell: $current_shell detected — zsh recommended (macOS default)"
        return 1
    fi
}

check_dns() {
    if nslookup github.com >/dev/null 2>&1; then
        log_success "DNS resolution ✓"
        return 0
    else
        log_error "DNS resolution failed — cannot resolve github.com"
        return 1
    fi
}

# Run all checks, collect results
run_all_checks() {
    local failures=0

    check_macos_version  || failures=$((failures + 1))
    check_apple_silicon  || failures=$((failures + 1))
    check_homebrew       || failures=$((failures + 1))
    check_disk_space     || failures=$((failures + 1))
    check_internet       || failures=$((failures + 1))
    check_memory         || failures=$((failures + 1))
    check_shell          || failures=$((failures + 1))
    check_dns            || failures=$((failures + 1))

    return "$failures"
}

# Display results table
show_checks_summary() {
    echo ""
    echo -e "    ${C_PURPLE:-}Pre-flight Checks${C_RESET:-}"
    echo -e "    ${C_GRAY:-}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET:-}"
    echo ""

    local failures=0
    failures=$(run_all_checks; echo $?)

    echo ""
    if [[ "$failures" -eq 0 ]]; then
        echo -e "    ${C_GREEN:-}✔ All checks passed${C_RESET:-}"
    else
        echo -e "    ${C_YELLOW:-}⚠ ${failures} check(s) had warnings or errors${C_RESET:-}"
    fi
    echo ""
}
