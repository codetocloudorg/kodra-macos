#!/usr/bin/env bash
#
# Kodra macOS — UI Helper Functions
# Shared display components for the CLI
#

KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"

source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true

# Gradient color codes (purple → cyan)
C_LOGO_1='\033[38;5;135m'
C_LOGO_2='\033[38;5;141m'
C_LOGO_3='\033[38;5;147m'
C_LOGO_4='\033[38;5;117m'
C_LOGO_5='\033[38;5;87m'
C_DIM='\033[2m'
C_BOLD='\033[1m'
C_WHITE='\033[1;37m'

# Show the ASCII art Kodra banner with gradient colors
show_banner() {
    local ver
    ver="$(cat "$KODRA_DIR/VERSION" 2>/dev/null || echo "unknown")"

    echo ""
    echo -e "${C_DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo -e "${C_LOGO_1}  ██╗  ██╗ ██████╗ ██████╗ ██████╗  █████╗${C_RESET}"
    echo -e "${C_LOGO_2}  ██║ ██╔╝██╔═══██╗██╔══██╗██╔══██╗██╔══██╗${C_RESET}"
    echo -e "${C_LOGO_3}  █████╔╝ ██║   ██║██║  ██║██████╔╝███████║${C_RESET}"
    echo -e "${C_LOGO_4}  ██╔═██╗ ██║   ██║██║  ██║██╔══██╗██╔══██║${C_RESET}"
    echo -e "${C_LOGO_5}  ██║  ██╗╚██████╔╝██████╔╝██║  ██║██║  ██║${C_RESET}"
    echo -e "${C_LOGO_5}  ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝${C_RESET}"
    echo ""
    echo -e "  ${C_BOLD}v${ver}${C_RESET} ${C_DIM}•${C_RESET} macOS Edition ${C_DIM}•${C_RESET} by Code To Cloud"
    echo -e "  ${C_DIM}kodra.macos.codetocloud.io${C_RESET}"
    echo -e "${C_DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""
}

# Show a horizontal separator line
show_separator() {
    local color="${1:-$C_GRAY}"
    echo -e "  ${color}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
}

# Show a formatted section header
show_section_header() {
    local title="$1"
    echo ""
    echo -e "  ${C_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo -e "  ${C_PURPLE}  ${title}${C_RESET}"
    echo -e "  ${C_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""
}

# Show a simple progress indicator
show_progress() {
    local current="$1"
    local total="$2"
    local label="${3:-Progress}"

    local pct=$((current * 100 / total))
    local filled=$((pct / 5))
    local empty=$((20 - filled))

    local bar=""
    for ((i = 0; i < filled; i++)); do bar+="█"; done
    for ((i = 0; i < empty; i++)); do bar+="░"; done

    printf "\r  ${C_CYAN}%s${C_RESET} [${bar}] %d/%d (%d%%)" "$label" "$current" "$total" "$pct"

    if [[ "$current" -eq "$total" ]]; then
        echo ""
    fi
}

# Show an animated spinner for long operations
show_spinner() {
    local pid="$1"
    local message="${2:-Working}"
    local spin_chars='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0

    while kill -0 "$pid" 2>/dev/null; do
        local char="${spin_chars:$((i % ${#spin_chars})):1}"
        printf "\r  ${C_CYAN}%s${C_RESET} %s" "$char" "$message"
        i=$((i + 1))
        sleep 0.1
    done

    printf "\r  ${C_GREEN}✔${C_RESET} %s\n" "$message"
}

# Prompt for yes/no confirmation
confirm_prompt() {
    local message="${1:-Continue?}"
    local default="${2:-N}"

    if [[ "$default" == "Y" || "$default" == "y" ]]; then
        printf "  %s [Y/n] " "$message"
    else
        printf "  %s [y/N] " "$message"
    fi

    read -n 1 -r reply
    echo ""

    if [[ -z "$reply" ]]; then
        reply="$default"
    fi

    [[ "$reply" == [yY] ]]
}

# Show a boxed message
show_box() {
    local message="$1"
    local color="${2:-$C_CYAN}"
    local len=${#message}
    local border=""

    for ((i = 0; i < len + 4; i++)); do border+="━"; done

    echo -e "  ${color}┏${border}┓${C_RESET}"
    echo -e "  ${color}┃${C_RESET}  ${message}  ${color}┃${C_RESET}"
    echo -e "  ${color}┗${border}┛${C_RESET}"
}
