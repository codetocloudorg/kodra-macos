#!/usr/bin/env bash
#
# Kodra macOS — Simulated Install Demo
# For training videos — does NOT install anything
#
# Faithfully reproduces boot.sh → install.sh with section subtitles.
#
# Usage:
#   bash demo-install.sh            Normal speed
#   bash demo-install.sh --fast     2x speed (for recording)
#

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Speed
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SPEED=1.0
for arg in "$@"; do
    case "$arg" in
        --fast) SPEED=0.5 ;;
    esac
done

ssleep() {
    local t
    t=$(echo "$1 * $SPEED" | bc 2>/dev/null || echo "$1")
    sleep "$t"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Colors — identical to lib/logging.sh
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
C_RESET='\033[0m'
C_RED='\033[0;31m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_CYAN='\033[0;36m'
C_WHITE='\033[1;37m'
C_GRAY='\033[0;90m'
C_PURPLE='\033[38;5;135m'
C_DIM='\033[2m'
C_ITALIC='\033[3m'
C_BOLD='\033[1m'

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Logging — matches lib/logging.sh exactly
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
log_info() {
    echo -e "    ${C_CYAN}▶${C_RESET} $1"
}

log_success() {
    echo -e "    ${C_GREEN}✔${C_RESET} $1"
}

log_section() {
    echo ""
    echo -e "    ${C_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo -e "    ${C_PURPLE}  $1${C_RESET}"
    echo -e "    ${C_PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""
}

# Subtitle — a dim italic caption that explains what this section does
subtitle() {
    echo -e "    ${C_DIM}${C_ITALIC}$1${C_RESET}"
    echo ""
    ssleep 0.6
}

# Simulated run_installer — matches lib/utils.sh run_installer()
run_installer() {
    local name="$1"
    log_info "Installing ${name}..."
    ssleep 0.5
    log_success "${name} installed"
    ssleep 0.12
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Simulated prompt typing
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
type_prompt() {
    local text="$1"
    local prompt_char="\$"
    printf "  ${C_GREEN}${prompt_char}${C_RESET} "
    for (( i=0; i<${#text}; i++ )); do
        printf '%s' "${text:$i:1}"
        sleep 0.045
    done
    echo ""
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Banner — identical to boot.sh / install.sh
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
show_banner() {
    echo ""
    echo -e "\033[38;5;135m    ██╗  ██╗ ██████╗ ██████╗ ██████╗  █████╗\033[0m"
    echo -e "\033[38;5;141m    ██║ ██╔╝██╔═══██╗██╔══██╗██╔══██╗██╔══██╗\033[0m"
    echo -e "\033[38;5;147m    █████╔╝ ██║   ██║██║  ██║██████╔╝███████║\033[0m"
    echo -e "\033[38;5;117m    ██╔═██╗ ██║   ██║██║  ██║██╔══██╗██╔══██║\033[0m"
    echo -e "\033[38;5;87m    ██║  ██╗╚██████╔╝██████╔╝██║  ██║██║  ██║\033[0m"
    echo -e "\033[38;5;87m    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝\033[0m"
    echo ""
    echo -e "${C_DIM}    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo -e "\033[38;5;147m              🍎  m a c O S   E D I T I O N  •  A P P L E   S I L I C O N  🍎\033[0m"
    echo -e "${C_DIM}    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""
}

# ╔═════════════════════════════════════════════════════════════════╗
# ║                    BOOT.SH — BOOTSTRAP PHASE                  ║
# ╚═════════════════════════════════════════════════════════════════╝

clear 2>/dev/null || true
ssleep 0.8

# Simulate the curl | bash command the user types
echo ""
type_prompt "curl -fsSL https://kodra.macos.codetocloud.io/boot.sh | bash"
ssleep 1.8

clear 2>/dev/null || true
ssleep 0.4

show_banner

echo -e "    ${C_DIM}Agentic Azure engineering for macOS developers${C_RESET}"
echo -e "    ${C_DIM}GitHub CLI • Copilot CLI • Docker • Azure CLI • Kubernetes${C_RESET}"
echo ""
ssleep 1.2

# boot.sh: Detecting environment
log_info "Detecting environment..."
ssleep 0.7
log_success "Apple Silicon detected (arm64)"
ssleep 0.35
log_success "macOS 15.4.1 (Sequoia)"
echo ""
ssleep 0.5

# boot.sh: Prerequisites
log_info "Checking prerequisites..."
ssleep 0.6
log_success "Xcode Command Line Tools ready"
ssleep 0.3
log_success "Homebrew ready"
ssleep 0.5
echo ""

# boot.sh: Clone
log_info "Downloading Kodra macOS from GitHub..."
echo -e "    ${C_GRAY}This may take a moment on slower connections...${C_RESET}"
ssleep 1.4
log_success "Repository cloned to ~/.kodra"
echo ""
ssleep 0.5

echo -e "    ${C_PURPLE}Starting installation...${C_RESET}"
echo ""
ssleep 0.8

# ╔═════════════════════════════════════════════════════════════════╗
# ║                  INSTALL.SH — MAIN INSTALLER                  ║
# ╚═════════════════════════════════════════════════════════════════╝

# install.sh: log header
echo "═══════════════════════════════════════════════════════════════════════════"
echo "Kodra macOS Installation Log"
echo "Started: $(date '+%a %b %d %H:%M:%S %Z %Y')"
echo "System: Darwin MacBook-Pro.local 24.4.0 Darwin Kernel Version 24.4.0 arm64"
echo "User: $(whoami)"
echo "macOS: 15.4.1 (macOS)"
echo "Arch: arm64"
echo "Log file: /tmp/kodra-macos-install-$(date +%Y%m%d-%H%M%S).log"
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""
ssleep 0.8

# install.sh shows banner again
show_banner
ssleep 0.6

# ──────────────────────────────────────────────────────────────────
# Pre-flight Checks
# ──────────────────────────────────────────────────────────────────
log_section "Pre-flight Checks"
subtitle "Verifying your Mac meets all system requirements before installing."

log_success "macOS 15.4.1 (Sequoia)"
ssleep 0.3
log_success "Apple Silicon (arm64)"
ssleep 0.3
log_success "Homebrew 4.5.3"
ssleep 0.3
log_success "Disk space: 45.2 GB available"
ssleep 0.3
log_success "Internet connection"
ssleep 0.8

# ──────────────────────────────────────────────────────────────────
# Installation Options
# ──────────────────────────────────────────────────────────────────
log_section "Installation Options"
subtitle "Choose your install profile — Full Install includes all 42 tools."

echo -e "    Choose what to do:"
echo ""
echo -e "    ${C_CYAN}1)${C_RESET} Full Install (recommended) — all tools"
echo -e "    ${C_CYAN}2)${C_RESET} Minimal — shell + CLI tools only"
echo -e "    ${C_CYAN}3)${C_RESET} Developer — shell + CLI + Git + Containers"
echo -e "    ${C_CYAN}4)${C_RESET} Cloud Engineer — everything except Desktop tweaks"
echo -e "    ${C_RED}5)${C_RESET} Uninstall Kodra — remove all tools and configs"
echo -e "    ${C_GRAY}6)${C_RESET} Exit"
echo ""

printf "    Choose an option [1-6] (default: 1): "
ssleep 1.8
echo "1"
echo ""
ssleep 0.5

echo -e "    Choose container runtime:"
echo ""
echo -e "    ${C_CYAN}1)${C_RESET} Docker (Colima + Docker CLI) — lightweight, no Docker Desktop license"
echo -e "    ${C_CYAN}2)${C_RESET} Podman (Podman + Podman Desktop) — daemonless, rootless containers"
echo ""

printf "    Choose an option [1-2] (default: 1): "
ssleep 1.2
echo "1"
echo ""
ssleep 0.5

echo -e "    Will install:"
echo -e "    ${C_GREEN}✔${C_RESET} Shell environment (Starship prompt, aliases)"
echo -e "    ${C_GREEN}✔${C_RESET} CLI utilities (bat, eza, fzf, jq, delta, neovim, etc.)"
echo -e "    ${C_GREEN}✔${C_RESET} Git tools (GitHub CLI, lazygit, Copilot CLI, act)"
echo -e "    ${C_GREEN}✔${C_RESET} Cloud tools (Azure CLI, azd, Terraform, OpenShift, Ansible)"
echo -e "    ${C_GREEN}✔${C_RESET} Container tools (Colima, Docker CLI, lazydocker)"
echo -e "    ${C_GREEN}✔${C_RESET} Kubernetes tools (kubectl, Helm, k9s)"
echo -e "    ${C_GREEN}✔${C_RESET} macOS desktop settings (Dock, Finder, keyboard)"
echo ""
ssleep 1.0

# ──────────────────────────────────────────────────────────────────
# Shell Environment
# ──────────────────────────────────────────────────────────────────
log_section "Shell Environment"
subtitle "Installs Ghostty terminal, Nerd Fonts, Starship prompt, and zsh config."

run_installer "ghostty"
run_installer "nerd-fonts"
run_installer "starship"
run_installer "shell-config"

# ──────────────────────────────────────────────────────────────────
# CLI Tools
# ──────────────────────────────────────────────────────────────────
log_section "CLI Tools"
subtitle "Modern replacements for classic Unix tools — faster, prettier, smarter."

run_installer "bat"
run_installer "btop"
run_installer "delta"
run_installer "direnv"
run_installer "eza"
run_installer "fastfetch"
run_installer "fd"
run_installer "fzf"
run_installer "httpie"
run_installer "jq"
run_installer "neovim"
run_installer "ripgrep"
run_installer "shellcheck"
run_installer "tldr"
run_installer "yq"
run_installer "zoxide"

# ──────────────────────────────────────────────────────────────────
# Git Tools
# ──────────────────────────────────────────────────────────────────
log_section "Git Tools"
subtitle "GitHub CLI, Copilot in the terminal, and visual Git workflows."

run_installer "github-cli"
run_installer "copilot-cli"
run_installer "lazygit"
run_installer "act"

# ──────────────────────────────────────────────────────────────────
# Azure, Red Hat & Cloud Tools
# ──────────────────────────────────────────────────────────────────
log_section "Azure, Red Hat & Cloud Tools"
subtitle "Everything you need for cloud infrastructure — Azure, Terraform, Ansible, and more."

run_installer "azure-cli"
run_installer "azd"
run_installer "bicep"
run_installer "terraform"
run_installer "opentofu"
run_installer "powershell"
run_installer "openshift-cli"
run_installer "ansible"

# ──────────────────────────────────────────────────────────────────
# Container Development
# ──────────────────────────────────────────────────────────────────
log_section "Container Development"
subtitle "Colima provides Docker without Docker Desktop — no license required."

run_installer "docker-cli"
run_installer "colima"
run_installer "lazydocker"
run_installer "trivy"
run_installer "dive"

# ──────────────────────────────────────────────────────────────────
# Kubernetes
# ──────────────────────────────────────────────────────────────────
log_section "Kubernetes"
subtitle "Cluster management, package charts, and a beautiful terminal UI for K8s."

run_installer "kubectl"
run_installer "helm"
run_installer "k9s"

# ──────────────────────────────────────────────────────────────────
# Development Tools
# ──────────────────────────────────────────────────────────────────
log_section "Development Tools"
subtitle "Polyglot runtime manager and VS Code with extensions."

run_installer "mise"
run_installer "vscode"

# ──────────────────────────────────────────────────────────────────
# macOS Desktop Customization
# ──────────────────────────────────────────────────────────────────
log_section "macOS Desktop Customization"
subtitle "Developer-friendly Dock, Finder, and keyboard settings."

run_installer "dock"
run_installer "finder"
run_installer "defaults"

# ──────────────────────────────────────────────────────────────────
# Finalizing
# ──────────────────────────────────────────────────────────────────
log_section "Finalizing"
subtitle "Linking the kodra CLI and saving installation state."

log_info "Installing kodra CLI to PATH..."
ssleep 0.4
log_success "kodra CLI linked"
ssleep 0.2
log_info "Saving configuration..."
ssleep 0.3
log_success "Configuration saved"
ssleep 0.2
log_info "Recording install state..."
ssleep 0.3
log_success "State saved"
ssleep 0.8

# ──────────────────────────────────────────────────────────────────
# Completion
# ──────────────────────────────────────────────────────────────────
echo ""
echo -e "    \033[38;5;135m┌──────────────────────────────────────────────────────┐\033[0m"
printf "    \033[38;5;141m│\033[0m  ✅ Kodra macOS installed successfully!               \033[38;5;141m│\033[0m\n"
printf "    \033[38;5;147m│\033[0m     Completed in %-36s\033[38;5;147m│\033[0m\n" "4m 23s"
echo -e "    \033[38;5;87m└──────────────────────────────────────────────────────┘\033[0m"
echo ""

log_info "Log saved: ~/.config/kodra/install.log"

echo ""
echo -e "    ┌──────────────────────────────────────────────────────┐"
echo -e "    │                    \033[1;32mNEXT STEPS\033[0m                          │"
echo -e "    ├──────────────────────────────────────────────────────┤"
echo -e "    │                                                      │"
echo -e "    │  ${C_CYAN}1.${C_RESET} Restart your terminal                             │"
echo -e "    │     Or run: ${C_WHITE}source ~/.zshrc${C_RESET}                           │"
echo -e "    │                                                      │"
echo -e "    │  ${C_CYAN}2.${C_RESET} Verify installation                               │"
echo -e "    │     Run: ${C_WHITE}kodra doctor${C_RESET}                                 │"
echo -e "    │                                                      │"
echo -e "    │  ${C_CYAN}3.${C_RESET} Start Colima (container runtime)                  │"
echo -e "    │     Run: ${C_WHITE}colima start${C_RESET}                                 │"
echo -e "    │                                                      │"
echo -e "    │  ${C_CYAN}4.${C_RESET} Configure your accounts                           │"
echo -e "    │     ${C_WHITE}gh auth login${C_RESET}     (GitHub)                        │"
echo -e "    │     ${C_WHITE}az login${C_RESET}          (Azure)                         │"
echo -e "    │                                                      │"
echo -e "    └──────────────────────────────────────────────────────┘"
echo ""
echo -e "    ${C_DIM}Kodra macOS v0.5.0 • A Code To Cloud Project ☁️${C_RESET}"
echo -e "    ${C_DIM}https://kodra.macos.codetocloud.io${C_RESET}"
echo ""

# Hold on the final screen so the viewer can read it
ssleep 5
