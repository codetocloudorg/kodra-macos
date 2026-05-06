#!/usr/bin/env bash
#
# Kodra macOS — Logging Library
#

C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'
C_CYAN='\033[0;36m'
C_GRAY='\033[0;90m'
C_PURPLE='\033[38;5;135m'

log_info() {
    echo -e "    ${C_CYAN}▶${C_RESET} $1"
}

log_success() {
    echo -e "    ${C_GREEN}✔${C_RESET} $1"
}

log_warn() {
    echo -e "    ${C_YELLOW}⚠${C_RESET} $1"
}

log_error() {
    echo -e "    ${C_RED}✖${C_RESET} $1"
}

log_debug() {
    if [[ "${KODRA_DEBUG:-false}" == "true" ]]; then
        echo -e "    ${C_GRAY}[debug] $1${C_RESET}"
    fi
}

log_section() {
    echo ""
    echo -e "    ${C_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo -e "    ${C_PURPLE}  $1${C_RESET}"
    echo -e "    ${C_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""
}
