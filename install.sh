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
        --debug|-d)
            export KODRA_DEBUG="true"
            ;;
    esac
done

set -e
[[ "$KODRA_DEBUG" == "true" ]] && set +e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
export KODRA_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kodra"
export KODRA_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/kodra"

# Source library functions
source "$SCRIPT_DIR/lib/logging.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/lib/checks.sh"
source "$SCRIPT_DIR/lib/state.sh"

# Create state/config directories
mkdir -p "$KODRA_CONFIG_DIR"
mkdir -p "$KODRA_STATE_DIR"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Phase 1: System Checks
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
log_section "Phase 1: System Checks"

check_macos_version
check_apple_silicon
check_homebrew
check_disk_space

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Phase 2: CLI Tools
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
log_section "Phase 2: CLI Tools"

INSTALL_DIR="$SCRIPT_DIR/install"

run_installer "$INSTALL_DIR/cli-tools/bat.sh"
run_installer "$INSTALL_DIR/cli-tools/btop.sh"
run_installer "$INSTALL_DIR/cli-tools/eza.sh"
run_installer "$INSTALL_DIR/cli-tools/fastfetch.sh"
run_installer "$INSTALL_DIR/cli-tools/fd.sh"
run_installer "$INSTALL_DIR/cli-tools/fzf.sh"
run_installer "$INSTALL_DIR/cli-tools/github-cli.sh"
run_installer "$INSTALL_DIR/cli-tools/copilot-cli.sh"
run_installer "$INSTALL_DIR/cli-tools/lazygit.sh"
run_installer "$INSTALL_DIR/cli-tools/ripgrep.sh"
run_installer "$INSTALL_DIR/cli-tools/yq.sh"
run_installer "$INSTALL_DIR/cli-tools/zoxide.sh"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Phase 3: Cloud Tools
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
log_section "Phase 3: Cloud & Infrastructure"

run_installer "$INSTALL_DIR/cloud/azure-cli.sh"
run_installer "$INSTALL_DIR/cloud/azd.sh"
run_installer "$INSTALL_DIR/cloud/bicep.sh"
run_installer "$INSTALL_DIR/cloud/terraform.sh"
run_installer "$INSTALL_DIR/cloud/opentofu.sh"
run_installer "$INSTALL_DIR/cloud/kubectl.sh"
run_installer "$INSTALL_DIR/cloud/helm.sh"
run_installer "$INSTALL_DIR/cloud/k9s.sh"
run_installer "$INSTALL_DIR/cloud/powershell.sh"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Phase 4: Containers
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
log_section "Phase 4: Containers"

run_installer "$INSTALL_DIR/containers/colima.sh"
run_installer "$INSTALL_DIR/containers/docker-cli.sh"
run_installer "$INSTALL_DIR/containers/lazydocker.sh"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Phase 5: Development Tools
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
log_section "Phase 5: Development Tools"

run_installer "$INSTALL_DIR/dev-tools/mise.sh"
run_installer "$INSTALL_DIR/dev-tools/vscode.sh"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Phase 6: Terminal & Shell
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
log_section "Phase 6: Terminal & Shell"

run_installer "$INSTALL_DIR/terminal/ghostty.sh"
run_installer "$INSTALL_DIR/terminal/nerd-fonts.sh"
run_installer "$INSTALL_DIR/terminal/starship.sh"
run_installer "$INSTALL_DIR/terminal/shell-config.sh"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Phase 7: Desktop Customization
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
log_section "Phase 7: Desktop Customization"

run_installer "$INSTALL_DIR/desktop/dock.sh"
run_installer "$INSTALL_DIR/desktop/finder.sh"
run_installer "$INSTALL_DIR/desktop/defaults.sh"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Phase 8: Finalize
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
log_section "Phase 8: Finalizing"

# Install kodra CLI to PATH
mkdir -p "$HOME/.local/bin"
ln -sf "$KODRA_DIR/bin/kodra" "$HOME/.local/bin/kodra"

# Save install state
save_state "installed" "true"
save_state "version" "$(cat "$KODRA_DIR/VERSION")"
save_state "installed_at" "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
save_state "arch" "$(uname -m)"
save_state "macos_version" "$(sw_vers -productVersion)"

echo ""
echo -e "\033[38;5;135m    ┌──────────────────────────────────────────────────┐\033[0m"
echo -e "\033[38;5;141m    │  ✅ Kodra macOS installed successfully!           │\033[0m"
echo -e "\033[38;5;147m    │                                                    │\033[0m"
echo -e "\033[38;5;117m    │  Run: kodra doctor     to verify everything       │\033[0m"
echo -e "\033[38;5;87m    │  Run: kodra help       to see all commands        │\033[0m"
echo -e "\033[38;5;87m    └──────────────────────────────────────────────────┘\033[0m"
echo ""
echo -e "    \033[2mRestart your terminal or run: source ~/.zshrc\033[0m"
echo ""
