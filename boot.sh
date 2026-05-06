#!/usr/bin/env bash
#
# Kodra macOS Bootstrap Script
# A Code To Cloud Project ☁️
#
# https://kodra.macos.codetocloud.io
#
# Usage:
#   curl -fsSL https://kodra.macos.codetocloud.io/boot.sh | bash
#

set -e

KODRA_REPO="https://github.com/codetocloudorg/kodra-macos.git"
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"

# Colors
C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'
C_PURPLE='\033[0;35m'
C_CYAN='\033[0;36m'
C_WHITE='\033[1;37m'
C_GRAY='\033[0;90m'
C_ORANGE='\033[38;5;208m'

# Clear screen for clean start
clear 2>/dev/null || true

# Purple→cyan gradient banner
echo ""
echo -e "\033[38;5;135m    ██╗  ██╗ ██████╗ ██████╗ ██████╗  █████╗\033[0m"
echo -e "\033[38;5;141m    ██║ ██╔╝██╔═══██╗██╔══██╗██╔══██╗██╔══██╗\033[0m"
echo -e "\033[38;5;147m    █████╔╝ ██║   ██║██║  ██║██████╔╝███████║\033[0m"
echo -e "\033[38;5;117m    ██╔═██╗ ██║   ██║██║  ██║██╔══██╗██╔══██║\033[0m"
echo -e "\033[38;5;87m    ██║  ██╗╚██████╔╝██████╔╝██║  ██║██║  ██║\033[0m"
echo -e "\033[38;5;87m    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝\033[0m"
echo ""
echo -e "\033[2m    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[38;5;147m              🍎  m a c O S   E D I T I O N  •  A P P L E   S I L I C O N  🍎\033[0m"
echo -e "\033[2m    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -e "    \033[2mAgentic Azure engineering for macOS developers\033[0m"
echo -e "    \033[2mGitHub CLI • Copilot CLI • Docker • Azure CLI • Kubernetes\033[0m"
echo ""

# Helper functions
show_step() {
    echo -e "    ${C_CYAN}▶${C_RESET} $1"
}

show_done() {
    echo -e "    ${C_GREEN}✔${C_RESET} $1"
}

show_warn() {
    echo -e "    ${C_YELLOW}⚠${C_RESET} $1"
}

show_error() {
    echo -e "    ${C_RED}✖${C_RESET} $1"
}

# Detect macOS
detect_macos() {
    [[ "$(uname -s)" == "Darwin" ]]
}

# Detect Apple Silicon
detect_apple_silicon() {
    [[ "$(uname -m)" == "arm64" ]]
}

# Get macOS version
get_macos_version() {
    sw_vers -productVersion
}

get_macos_name() {
    local ver
    ver=$(sw_vers -productVersion | cut -d. -f1)
    case "$ver" in
        15) echo "Sequoia" ;;
        14) echo "Sonoma" ;;
        13) echo "Ventura" ;;
        *) echo "macOS $ver" ;;
    esac
}

# Check environment
show_step "Detecting environment..."

if ! detect_macos; then
    show_error "This script requires macOS"
    echo -e "    ${C_GRAY}For WSL, use: https://kodra.wsl.codetocloud.io${C_RESET}"
    echo -e "    ${C_GRAY}For Ubuntu desktop, use: https://kodra.codetocloud.io${C_RESET}"
    exit 1
fi

MACOS_VERSION=$(get_macos_version)
MACOS_NAME=$(get_macos_name)
MACOS_MAJOR=$(echo "$MACOS_VERSION" | cut -d. -f1)

if detect_apple_silicon; then
    show_done "Apple Silicon detected (arm64)"
else
    show_warn "Intel Mac detected — Apple Silicon recommended"
fi

show_done "macOS $MACOS_VERSION ($MACOS_NAME)"

if [ "$MACOS_MAJOR" -lt 14 ]; then
    show_warn "macOS 14 (Sonoma) or later recommended. You have: $MACOS_VERSION"
fi
echo ""

# Check for Xcode Command Line Tools
show_step "Checking prerequisites..."
if ! xcode-select -p &>/dev/null; then
    show_step "Installing Xcode Command Line Tools..."
    xcode-select --install 2>/dev/null || true
    echo -e "    ${C_GRAY}Please complete the installation dialog, then re-run this script${C_RESET}"
    exit 1
fi
show_done "Xcode Command Line Tools ready"

# Check for Homebrew
if ! command -v brew &>/dev/null; then
    show_step "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    if [ -f /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f /usr/local/bin/brew ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    show_done "Homebrew installed"
else
    show_done "Homebrew ready"
fi

# Export environment flags
export KODRA_IS_MACOS="true"
export KODRA_ARCH="$(uname -m)"
export KODRA_MACOS_VERSION="$MACOS_VERSION"

# Clone or update repository
echo ""
if [ -d "$KODRA_DIR" ]; then
    show_step "Updating existing Kodra macOS installation..."
    cd "$KODRA_DIR"
    echo -e "    ${C_GRAY}Fetching latest changes from GitHub...${C_RESET}"
    git fetch origin --progress < /dev/null 2>&1 || true
    git reset --hard origin/main < /dev/null 2>&1 || true
    show_done "Repository updated"
else
    show_step "Downloading Kodra macOS from GitHub..."
    echo -e "    ${C_GRAY}This may take a moment on slower connections...${C_RESET}"
    git clone --progress "$KODRA_REPO" "$KODRA_DIR" < /dev/null 2>&1
    show_done "Repository cloned to $KODRA_DIR"
fi
echo ""

# Run installer
cd "$KODRA_DIR"
echo -e "    ${C_PURPLE}Starting installation...${C_RESET}"
echo ""
bash ./install.sh "$@"
