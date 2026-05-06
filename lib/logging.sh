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
    _write_log "INFO" "$1" 2>/dev/null || true
}

log_success() {
    echo -e "    ${C_GREEN}✔${C_RESET} $1"
    _write_log "SUCCESS" "$1" 2>/dev/null || true
}

log_warn() {
    echo -e "    ${C_YELLOW}⚠${C_RESET} $1"
    _write_log "WARN" "$1" 2>/dev/null || true
}

log_error() {
    echo -e "    ${C_RED}✖${C_RESET} $1"
    _write_log "ERROR" "$1" 2>/dev/null || true
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

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# File logging with rotation
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

KODRA_LOG_DIR="${HOME}/.local/state/kodra/logs"
KODRA_LOG_FILE=""

# Set up log file and rotate old logs
init_log() {
    mkdir -p "${KODRA_LOG_DIR}"
    KODRA_LOG_FILE="${KODRA_LOG_DIR}/kodra-$(date +%Y-%m-%d).log"
    touch "${KODRA_LOG_FILE}"
    _rotate_logs
}

# Keep only the last 5 log files
_rotate_logs() {
    local log_count
    log_count="$(find "${KODRA_LOG_DIR}" -name 'kodra-*.log' -type f 2>/dev/null | wc -l | tr -d ' ')"

    if [[ "$log_count" -gt 5 ]]; then
        find "${KODRA_LOG_DIR}" -name 'kodra-*.log' -type f 2>/dev/null \
            | sort \
            | head -n $(( log_count - 5 )) \
            | while IFS= read -r old_log; do
                rm -f "$old_log"
            done
    fi
}

# Append timestamped entry to log file
_write_log() {
    local level="$1"
    local msg="$2"
    if [[ -n "${KODRA_LOG_FILE:-}" && -d "${KODRA_LOG_DIR}" ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [${level}] ${msg}" >> "${KODRA_LOG_FILE}"
    fi
}
