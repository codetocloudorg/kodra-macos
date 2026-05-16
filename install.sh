#!/usr/bin/env bash
#
# Kodra macOS Install Script
# A Code To Cloud Project ☁️
#
# https://kodra.macos.codetocloud.io
#
# Main installation orchestrator for macOS environments
#
# Usage:
#   ./install.sh              Normal installation (stops on error)
#   ./install.sh --debug      Debug mode (logs failures, continues)
#

# Parse arguments
export KODRA_DEBUG="false"
for arg in "$@"; do
    case $arg in
        --debug|--resilient|-d)
            export KODRA_DEBUG="true"
            shift
            ;;
    esac
done

# Only set -e if NOT in debug mode
if [ "$KODRA_DEBUG" != "true" ]; then
    set -e
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
export KODRA_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kodra"
export KODRA_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/kodra"
export KODRA_LOG_FILE="/tmp/kodra-macos-install-$(date +%Y%m%d-%H%M%S).log"

# Start logging everything to file (skip process substitution in CI to avoid exit issues)
if [ -n "${CI:-}" ]; then
    # In CI, the workflow handles tee externally
    true
else
    exec > >(tee -a "$KODRA_LOG_FILE") 2>&1
fi

echo "═══════════════════════════════════════════════════════════════════════════"
echo "Kodra macOS Installation Log"
echo "Started: $(date)"
echo "System: $(uname -a)"
echo "User: $USER"
echo "macOS: $(sw_vers -productVersion) ($(sw_vers -productName))"
echo "Arch: $(uname -m)"
echo "Log file: $KODRA_LOG_FILE"
[ "$KODRA_DEBUG" = "true" ] && echo "Mode: DEBUG (resilient - will continue on errors)"
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""

# Error handler with verbose logging
kodra_error_handler() {
    local exit_code=$?
    local line_no=$1
    echo ""
    echo "╔═══════════════════════════════════════════════════════════════════════════╗"
    echo "║                         INSTALLATION ERROR                                ║"
    echo "╚═══════════════════════════════════════════════════════════════════════════╝"
    echo ""
    echo "❌ Error occurred at line $line_no (exit code: $exit_code)"
    echo ""
    echo "Log file saved at: $KODRA_LOG_FILE"
    echo ""

    # Save system info to log
    {
        echo ""
        echo "═══════════════════════════════════════════════════════════════════════════"
        echo "System Information at Error"
        echo "═══════════════════════════════════════════════════════════════════════════"
        echo "macOS version: $(sw_vers -productVersion)"
        echo "Architecture: $(uname -m)"
        echo "Chip: $(sysctl -n machdep.cpu.brand_string 2>/dev/null || echo unknown)"
        echo "Disk space: $(df -h / | tail -1)"
        echo "Memory: $(sysctl -n hw.memsize 2>/dev/null | awk '{printf "%.1f GB", $1/1073741824}')"
        echo "Homebrew: $(brew --version 2>/dev/null | head -1 || echo 'not found')"
    } >> "$KODRA_LOG_FILE" 2>&1

    exit $exit_code
}

trap 'kodra_error_handler $LINENO' ERR

# Source library functions
source "$SCRIPT_DIR/lib/logging.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/lib/checks.sh"
source "$SCRIPT_DIR/lib/state.sh"

# Create state/config directories
mkdir -p "$KODRA_CONFIG_DIR"
mkdir -p "$KODRA_STATE_DIR"

# Initialize timing
KODRA_START_TIME=$(date +%s)
export KODRA_START_TIME
export KODRA_INSTALL_COUNT=0
export KODRA_FAIL_COUNT=0
export KODRA_FAILED_INSTALLS=""

# Display banner
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

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Pre-flight Checks
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
log_section "Pre-flight Checks"

check_macos_version
check_apple_silicon
check_homebrew
check_disk_space

# Internet connection
if curl -fsSL --connect-timeout 5 https://github.com > /dev/null 2>&1; then
    log_success "Internet connection"
else
    log_error "No internet connection detected"
    exit 1
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Installation Options
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
log_section "Installation Options"

# Default selections (full install)
INSTALL_SHELL=true
INSTALL_CLI_TOOLS=true
INSTALL_GIT_TOOLS=true
INSTALL_AZURE=true
INSTALL_CONTAINERS=true
INSTALL_KUBERNETES=true
INSTALL_DESKTOP=true

# Container runtime: "docker" (Colima + Docker CLI) or "podman" (Podman + Podman Desktop)
CONTAINER_RUNTIME="${KODRA_CONTAINER_RUNTIME:-docker}"

# Determine if we can prompt the user (interactive terminal)
KODRA_CAN_PROMPT=false
if [ -z "$KODRA_SKIP_PROMPTS" ]; then
    if [ -t 0 ]; then
        KODRA_CAN_PROMPT=true
    elif [ -e /dev/tty ]; then
        KODRA_CAN_PROMPT=true
    fi
fi

# Check if interactive
if [ "$KODRA_CAN_PROMPT" = "true" ]; then
    echo -e "    Choose what to install:"
    echo ""
    echo -e "    \033[0;36m1)\033[0m Full Install (recommended) — all tools"
    echo -e "    \033[0;36m2)\033[0m Minimal — shell + CLI tools only"
    echo -e "    \033[0;36m3)\033[0m Developer — shell + CLI + Git + Containers"
    echo -e "    \033[0;36m4)\033[0m Cloud Engineer — everything except Desktop tweaks"
    echo ""

    printf "    Choose an option [1-4] (default: 1): "
    read -n 1 -r REPLY < /dev/tty
    echo
    echo ""

    case $REPLY in
        2)
            INSTALL_AZURE=false
            INSTALL_CONTAINERS=false
            INSTALL_KUBERNETES=false
            INSTALL_DESKTOP=false
            ;;
        3)
            INSTALL_AZURE=false
            INSTALL_KUBERNETES=false
            INSTALL_DESKTOP=false
            ;;
        4)
            INSTALL_DESKTOP=false
            ;;
        *)
            # Full install (default)
            ;;
    esac
else
    log_info "Non-interactive mode: Installing all components"
fi

# Container runtime selection (only if containers are being installed)
if [ "$INSTALL_CONTAINERS" = "true" ] && [ "$KODRA_CAN_PROMPT" = "true" ]; then
    echo -e "    Choose container runtime:"
    echo ""
    echo -e "    \033[0;36m1)\033[0m Docker (Colima + Docker CLI) — lightweight, no Docker Desktop license"
    echo -e "    \033[0;36m2)\033[0m Podman (Podman + Podman Desktop) — daemonless, rootless containers"
    echo ""

    printf "    Choose an option [1-2] (default: 1): "
    read -n 1 -r RUNTIME_REPLY < /dev/tty
    echo
    echo ""

    case $RUNTIME_REPLY in
        2)
            CONTAINER_RUNTIME="podman"
            ;;
        *)
            CONTAINER_RUNTIME="docker"
            ;;
    esac
fi

echo -e "    Will install:"
[ "$INSTALL_SHELL" = "true" ] && echo -e "    \033[0;32m✔\033[0m Shell environment (Starship prompt, aliases)"
[ "$INSTALL_CLI_TOOLS" = "true" ] && echo -e "    \033[0;32m✔\033[0m CLI utilities (bat, eza, fzf, jq, delta, neovim, etc.)"
[ "$INSTALL_GIT_TOOLS" = "true" ] && echo -e "    \033[0;32m✔\033[0m Git tools (GitHub CLI, lazygit, Copilot CLI, act)"
[ "$INSTALL_AZURE" = "true" ] && echo -e "    \033[0;32m✔\033[0m Cloud tools (Azure CLI, azd, Terraform, OpenShift, Ansible)"
if [ "$INSTALL_CONTAINERS" = "true" ]; then
    if [ "$CONTAINER_RUNTIME" = "podman" ]; then
        echo -e "    \033[0;32m✔\033[0m Container tools (Podman, Podman Desktop, podman-compose)"
    else
        echo -e "    \033[0;32m✔\033[0m Container tools (Colima, Docker CLI, lazydocker)"
    fi
fi
[ "$INSTALL_KUBERNETES" = "true" ] && echo -e "    \033[0;32m✔\033[0m Kubernetes tools (kubectl, Helm, k9s)"
[ "$INSTALL_DESKTOP" = "true" ] && echo -e "    \033[0;32m✔\033[0m macOS desktop settings (Dock, Finder, keyboard)"
echo ""

export INSTALL_SHELL INSTALL_CLI_TOOLS INSTALL_GIT_TOOLS INSTALL_AZURE INSTALL_CONTAINERS INSTALL_KUBERNETES INSTALL_DESKTOP CONTAINER_RUNTIME

INSTALL_DIR="$SCRIPT_DIR/install"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Shell Environment
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$INSTALL_SHELL" = "true" ]; then
    log_section "Shell Environment"

    run_installer "$INSTALL_DIR/terminal/ghostty.sh"
    run_installer "$INSTALL_DIR/terminal/nerd-fonts.sh"
    run_installer "$INSTALL_DIR/terminal/starship.sh"
    run_installer "$INSTALL_DIR/terminal/shell-config.sh"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# CLI Tools
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$INSTALL_CLI_TOOLS" = "true" ]; then
    log_section "CLI Tools"

    run_installer "$INSTALL_DIR/cli-tools/bat.sh"
    run_installer "$INSTALL_DIR/cli-tools/btop.sh"
    run_installer "$INSTALL_DIR/cli-tools/delta.sh"
    run_installer "$INSTALL_DIR/cli-tools/direnv.sh"
    run_installer "$INSTALL_DIR/cli-tools/eza.sh"
    run_installer "$INSTALL_DIR/cli-tools/fastfetch.sh"
    run_installer "$INSTALL_DIR/cli-tools/fd.sh"
    run_installer "$INSTALL_DIR/cli-tools/fzf.sh"
    run_installer "$INSTALL_DIR/cli-tools/httpie.sh"
    run_installer "$INSTALL_DIR/cli-tools/jq.sh"
    run_installer "$INSTALL_DIR/cli-tools/neovim.sh"
    run_installer "$INSTALL_DIR/cli-tools/ripgrep.sh"
    run_installer "$INSTALL_DIR/cli-tools/shellcheck.sh"
    run_installer "$INSTALL_DIR/cli-tools/tldr.sh"
    run_installer "$INSTALL_DIR/cli-tools/yq.sh"
    run_installer "$INSTALL_DIR/cli-tools/zoxide.sh"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Git Tools
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$INSTALL_GIT_TOOLS" = "true" ]; then
    log_section "Git Tools"

    run_installer "$INSTALL_DIR/cli-tools/github-cli.sh"
    run_installer "$INSTALL_DIR/cli-tools/copilot-cli.sh"
    run_installer "$INSTALL_DIR/cli-tools/lazygit.sh"
    run_installer "$INSTALL_DIR/cli-tools/act.sh"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Azure, Red Hat & Cloud Tools
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$INSTALL_AZURE" = "true" ]; then
    log_section "Azure, Red Hat & Cloud Tools"

    run_installer "$INSTALL_DIR/cloud/azure-cli.sh"
    run_installer "$INSTALL_DIR/cloud/azd.sh"
    run_installer "$INSTALL_DIR/cloud/bicep.sh"
    run_installer "$INSTALL_DIR/cloud/terraform.sh"
    run_installer "$INSTALL_DIR/cloud/opentofu.sh"
    run_installer "$INSTALL_DIR/cloud/powershell.sh"
    run_installer "$INSTALL_DIR/cloud/openshift-cli.sh"
    run_installer "$INSTALL_DIR/cloud/ansible.sh"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Containers (Docker via Colima or Podman — no Docker Desktop)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$INSTALL_CONTAINERS" = "true" ]; then
    log_section "Container Development"

    # Docker CLI is always installed (needed for build commands, compose, etc.)
    run_installer "$INSTALL_DIR/containers/docker-cli.sh"

    if [ "$CONTAINER_RUNTIME" = "podman" ]; then
        run_installer "$INSTALL_DIR/containers/podman.sh"
    else
        run_installer "$INSTALL_DIR/containers/colima.sh"
        run_installer "$INSTALL_DIR/containers/lazydocker.sh"
    fi

    # Container security & inspection (both stacks)
    run_installer "$INSTALL_DIR/containers/trivy.sh"
    run_installer "$INSTALL_DIR/containers/dive.sh"

    save_state "container.runtime" "$CONTAINER_RUNTIME"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Kubernetes
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$INSTALL_KUBERNETES" = "true" ]; then
    log_section "Kubernetes"

    run_installer "$INSTALL_DIR/cloud/kubectl.sh"
    run_installer "$INSTALL_DIR/cloud/helm.sh"
    run_installer "$INSTALL_DIR/cloud/k9s.sh"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Development Tools
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
log_section "Development Tools"

run_installer "$INSTALL_DIR/dev-tools/mise.sh"
run_installer "$INSTALL_DIR/dev-tools/vscode.sh"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# macOS Desktop Customization
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
if [ "$INSTALL_DESKTOP" = "true" ]; then
    log_section "macOS Desktop Customization"

    run_installer "$INSTALL_DIR/desktop/dock.sh"
    run_installer "$INSTALL_DIR/desktop/finder.sh"
    run_installer "$INSTALL_DIR/desktop/defaults.sh"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Finalization
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
log_section "Finalizing"

# Install kodra CLI to PATH
mkdir -p "$HOME/.local/bin"
ln -sf "$KODRA_DIR/bin/kodra" "$HOME/.local/bin/kodra"

# Save config
mkdir -p "$KODRA_CONFIG_DIR"
echo "macos" > "$KODRA_CONFIG_DIR/edition"
date +%s > "$KODRA_CONFIG_DIR/installed_at"

# Save install state
save_state "installed" "true"
save_state "version" "$(cat "$KODRA_DIR/VERSION")"
save_state "installed_at" "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
save_state "arch" "$(uname -m)"
save_state "macos_version" "$(sw_vers -productVersion)"

# Calculate duration
KODRA_END_TIME=$(date +%s)
KODRA_DURATION=$((KODRA_END_TIME - KODRA_START_TIME))
KODRA_MINUTES=$((KODRA_DURATION / 60))
KODRA_SECONDS=$((KODRA_DURATION % 60))

# Save permanent log
PERMANENT_LOG="$KODRA_CONFIG_DIR/install.log"
cp "$KODRA_LOG_FILE" "$PERMANENT_LOG" 2>/dev/null || true

# Show debug failure summary
if [ "$KODRA_DEBUG" = "true" ] && [ -n "$KODRA_FAILED_INSTALLS" ]; then
    echo ""
    echo -e "    \033[0;33m┌────────────────────────────────────────────────────────┐\033[0m"
    echo -e "    \033[0;33m│\033[0m  DEBUG: INSTALLATION SUMMARY                             \033[0;33m│\033[0m"
    echo -e "    \033[0;33m├────────────────────────────────────────────────────────┤\033[0m"
    echo -e "    \033[0;33m│\033[0m  Attempted: ${KODRA_INSTALL_COUNT:-0} installers                             \033[0;33m│\033[0m"
    echo -e "    \033[0;33m│\033[0m  Failed:    ${KODRA_FAIL_COUNT:-0} installers                             \033[0;33m│\033[0m"
    echo -e "    \033[0;33m├────────────────────────────────────────────────────────┤\033[0m"
    echo -e "$KODRA_FAILED_INSTALLS" | while read -r line; do
        [ -n "$line" ] && echo -e "    \033[0;33m│\033[0m  \033[0;31m✖\033[0m $line"
    done
    echo -e "    \033[0;33m└────────────────────────────────────────────────────────┘\033[0m"
fi

# Completion message
KODRA_DURATION_STR="${KODRA_MINUTES}m ${KODRA_SECONDS}s"
echo ""
echo -e "    \033[38;5;135m┌──────────────────────────────────────────────────────┐\033[0m"
printf "    \033[38;5;141m│\033[0m  ✅ Kodra macOS installed successfully!               \033[38;5;141m│\033[0m\n"
printf "    \033[38;5;147m│\033[0m     Completed in %-36s\033[38;5;147m│\033[0m\n" "$KODRA_DURATION_STR"
echo -e "    \033[38;5;87m└──────────────────────────────────────────────────────┘\033[0m"
echo ""

log_info "Log saved: ~/.config/kodra/install.log"

# Next steps
echo ""
echo -e "    ┌──────────────────────────────────────────────────────┐"
echo -e "    │                    \033[1;32mNEXT STEPS\033[0m                          │"
echo -e "    ├──────────────────────────────────────────────────────┤"
echo -e "    │                                                      │"
echo -e "    │  \033[0;36m1.\033[0m Restart your terminal                             │"
echo -e "    │     Or run: \033[1;37msource ~/.zshrc\033[0m                           │"
echo -e "    │                                                      │"
echo -e "    │  \033[0;36m2.\033[0m Verify installation                               │"
echo -e "    │     Run: \033[1;37mkodra doctor\033[0m                                 │"
echo -e "    │                                                      │"
if [ "${CONTAINER_RUNTIME:-docker}" = "podman" ]; then
echo -e "    │  \033[0;36m3.\033[0m Start Podman (container runtime)                  │"
echo -e "    │     Run: \033[1;37mpodman machine start\033[0m                         │"
else
echo -e "    │  \033[0;36m3.\033[0m Start Colima (container runtime)                  │"
echo -e "    │     Run: \033[1;37mcolima start\033[0m                                 │"
fi
echo -e "    │                                                      │"
echo -e "    │  \033[0;36m4.\033[0m Configure your accounts                           │"
echo -e "    │     \033[1;37mgh auth login\033[0m     (GitHub)                        │"
echo -e "    │     \033[1;37maz login\033[0m          (Azure)                         │"
echo -e "    │                                                      │"
echo -e "    └──────────────────────────────────────────────────────┘"
echo ""
