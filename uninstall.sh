#!/usr/bin/env bash
#
# Kodra macOS Uninstall Script
# Fully removes everything Kodra installed: tools, configs, apps, and state
#

set -e

# Ensure we can read user input (needed when exec'd from install.sh)
if [ ! -t 0 ] && [ ! -e /dev/tty ]; then
    echo "  ❌ Error: Uninstall must be run in an interactive terminal."
    exit 1
fi

KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
KODRA_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kodra"
KODRA_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/kodra"

# ─── Homebrew formulae installed by Kodra ──────────────────────
KODRA_BREW_FORMULAE=(
    bat btop eza fzf ripgrep zoxide yq jq fd fastfetch
    lazygit gh git-delta direnv httpie neovim shellcheck tldr act
    starship mise tmux
    azure-cli azd opentofu kubectl helm k9s ansible openshift-cli
    colima docker docker-compose docker-credential-helper
    lazydocker trivy dive
    podman podman-compose podman-docker
    "hashicorp/tap/terraform"
)

# ─── Homebrew casks installed by Kodra ─────────────────────────
KODRA_BREW_CASKS=(
    ghostty copilot-cli visual-studio-code podman-desktop
    font-jetbrains-mono-nerd-font font-meslo-lg-nerd-font
)

# ─── Config files Kodra creates ────────────────────────────────
KODRA_CONFIG_FILES=(
    "$HOME/.config/kodra"
    "$HOME/.config/starship.toml"
    "$HOME/.config/bat/config"
    "$HOME/.config/fastfetch/config.jsonc"
    "$HOME/.config/ghostty/config"
    "$HOME/.config/ghostty/sidebar-menu.sh"
    "$HOME/.tmux.conf"
    "$HOME/.config/kodra/podman-env.zsh"
)

echo ""
echo "  ┌──────────────────────────────────────────────┐"
echo "  │  Kodra macOS — Full Uninstall                 │"
echo "  └──────────────────────────────────────────────┘"
echo ""
echo "  This will remove EVERYTHING Kodra installed:"
echo ""
echo "    • All Homebrew formulae (${#KODRA_BREW_FORMULAE[@]} packages)"
echo "    • All Homebrew casks (${#KODRA_BREW_CASKS[@]} apps)"
echo "    • PowerShell 7 (.pkg install)"
echo "    • gh-copilot extension"
echo "    • All config files (starship, bat, fastfetch, ghostty, tmux)"
echo "    • Shell config (~/.zshrc Kodra lines)"
echo "    • Podman environment config"
echo "    • VS Code Kodra settings"
echo "    • LaunchAgent plists (Colima, Podman)"
echo "    • Kodra repo, state, and CLI"
echo ""

read -rp "  Are you sure? This cannot be undone. [y/N] " confirm < /dev/tty
if [[ "$confirm" != [yY] ]]; then
    echo "  Cancelled."
    exit 0
fi

echo ""

# ─── Stop running services ────────────────────────────────────
echo "  ▶ Stopping services..."

# Stop Colima VM if running
if command -v colima &>/dev/null; then
    colima stop 2>/dev/null || true
    echo "    ✔ Colima stopped"
fi

# Stop Podman machine if running
if command -v podman &>/dev/null; then
    podman machine stop 2>/dev/null || true
    echo "    ✔ Podman machine stopped"
fi

# ─── Remove launchd plists ────────────────────────────────────
echo "  ▶ Removing LaunchAgents..."

if [[ -f "$HOME/Library/LaunchAgents/com.kodra.colima.plist" ]]; then
    launchctl unload "$HOME/Library/LaunchAgents/com.kodra.colima.plist" 2>/dev/null || true
    rm -f "$HOME/Library/LaunchAgents/com.kodra.colima.plist"
    echo "    ✔ Colima launchd plist removed"
fi

if [[ -f "$HOME/Library/LaunchAgents/com.kodra.podman.plist" ]]; then
    launchctl unload "$HOME/Library/LaunchAgents/com.kodra.podman.plist" 2>/dev/null || true
    rm -f "$HOME/Library/LaunchAgents/com.kodra.podman.plist"
    echo "    ✔ Podman launchd plist removed"
fi

# ─── Remove gh extensions ─────────────────────────────────────
echo "  ▶ Removing gh extensions..."

if command -v gh &>/dev/null; then
    if gh extension list 2>/dev/null | grep -q "copilot"; then
        gh extension remove github/gh-copilot 2>/dev/null || true
        echo "    ✔ gh-copilot extension removed"
    fi
fi

# ─── Uninstall PowerShell (.pkg) ──────────────────────────────
echo "  ▶ Removing PowerShell..."

if command -v pwsh &>/dev/null || [[ -d "/Applications/PowerShell.app" ]]; then
    sudo rm -rf /usr/local/microsoft/powershell 2>/dev/null || true
    sudo rm -f /usr/local/bin/pwsh 2>/dev/null || true
    sudo rm -rf "/Applications/PowerShell.app" 2>/dev/null || true
    sudo pkgutil --forget com.microsoft.powershell 2>/dev/null || true
    echo "    ✔ PowerShell removed"
fi

# ─── Uninstall Homebrew casks ─────────────────────────────────
echo "  ▶ Removing Homebrew casks..."

for cask in "${KODRA_BREW_CASKS[@]}"; do
    if brew list --cask "$cask" &>/dev/null 2>&1; then
        brew uninstall --cask --force "$cask" 2>/dev/null || true
        echo "    ✔ $cask removed"
    fi
done

# Fallback: remove apps that may not have been installed via cask
for app in "Visual Studio Code" "Ghostty" "Podman Desktop"; do
    if [[ -d "/Applications/${app}.app" ]]; then
        rm -rf "/Applications/${app}.app"
        echo "    ✔ ${app}.app removed from /Applications"
    fi
done

# ─── Uninstall Homebrew formulae ──────────────────────────────
echo "  ▶ Removing Homebrew formulae..."

for formula in "${KODRA_BREW_FORMULAE[@]}"; do
    if brew list "$formula" &>/dev/null 2>&1; then
        brew uninstall --ignore-dependencies "$formula" 2>/dev/null || true
        echo "    ✔ $formula removed"
    fi
done

# Second pass to catch anything held back by deps
for formula in "${KODRA_BREW_FORMULAE[@]}"; do
    if brew list "$formula" &>/dev/null 2>&1; then
        brew uninstall --force --ignore-dependencies "$formula" 2>/dev/null || true
        echo "    ✔ $formula force-removed"
    fi
done

# Remove orphaned dependencies left behind
brew autoremove 2>/dev/null || true

# ─── Remove Podman machine data ───────────────────────────────
echo "  ▶ Cleaning Podman data..."

if [[ -d "$HOME/.local/share/containers" ]]; then
    rm -rf "$HOME/.local/share/containers"
    echo "    ✔ Podman containers data removed"
fi

if [[ -d "$HOME/.config/containers" ]]; then
    rm -rf "$HOME/.config/containers"
    echo "    ✔ Podman config removed"
fi

# ─── Remove Colima data ───────────────────────────────────────
echo "  ▶ Cleaning Colima data..."

if [[ -d "$HOME/.colima" ]]; then
    rm -rf "$HOME/.colima"
    echo "    ✔ Colima VM data removed"
fi

if [[ -d "$HOME/.docker" ]]; then
    rm -rf "$HOME/.docker"
    echo "    ✔ Docker config removed"
fi

# ─── Remove VS Code Kodra settings ────────────────────────────
echo "  ▶ Cleaning VS Code settings..."

VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
if [[ -f "$VSCODE_SETTINGS" ]]; then
    # Use sed since jq may already be uninstalled
    sed -i '' '/"dev.containers.dockerPath"/d' "$VSCODE_SETTINGS" 2>/dev/null || true
    sed -i '' '/"dev.containers.dockerComposePath"/d' "$VSCODE_SETTINGS" 2>/dev/null || true
    sed -i '' '/"docker.dockerPath"/d' "$VSCODE_SETTINGS" 2>/dev/null || true
    sed -i '' '/"docker.host"/d' "$VSCODE_SETTINGS" 2>/dev/null || true
    echo "    ✔ VS Code Kodra settings removed"
fi

# ─── Remove config files ──────────────────────────────────────
echo "  ▶ Removing config files..."

for cfg in "${KODRA_CONFIG_FILES[@]}"; do
    if [[ -e "$cfg" ]]; then
        rm -rf "$cfg"
        echo "    ✔ Removed $cfg"
    fi
done

# ─── Clean shell config ───────────────────────────────────────
echo "  ▶ Cleaning shell config..."

if [[ -f "$HOME/.zshrc" ]]; then
    sed -i '' '/# Kodra macOS/d' "$HOME/.zshrc" 2>/dev/null || true
    sed -i '' '/kodra\/shell.zsh/d' "$HOME/.zshrc" 2>/dev/null || true
    sed -i '' '/podman-env.zsh/d' "$HOME/.zshrc" 2>/dev/null || true
    echo "    ✔ Cleaned ~/.zshrc"
fi

# ─── Remove CLI symlink ───────────────────────────────────────
if [[ -L "$HOME/.local/bin/kodra" ]]; then
    rm -f "$HOME/.local/bin/kodra"
    echo "    ✔ Removed CLI symlink"
fi

# ─── Remove Kodra directories ─────────────────────────────────
echo "  ▶ Removing Kodra directories..."

rm -rf "$KODRA_DIR"
echo "    ✔ Removed $KODRA_DIR"

rm -rf "$KODRA_CONFIG_DIR"
echo "    ✔ Removed $KODRA_CONFIG_DIR"

rm -rf "$KODRA_STATE_DIR"
echo "    ✔ Removed $KODRA_STATE_DIR"

# ─── Cleanup Homebrew ─────────────────────────────────────────
echo "  ▶ Cleaning up Homebrew..."
brew cleanup --prune=all 2>/dev/null || true
echo "    ✔ Homebrew cache cleaned"

echo ""
echo "  ┌──────────────────────────────────────────────┐"
echo "  │  ✅ Kodra macOS fully uninstalled             │"
echo "  │                                               │"
echo "  │  Please restart your terminal.                │"
echo "  │  Homebrew itself was kept — remove with:      │"
echo "  │  /bin/bash -c \"\$(curl -fsSL https://raw.   │"
echo "  │  githubusercontent.com/Homebrew/install/       │"
echo "  │  HEAD/uninstall.sh)\"                         │"
echo "  └──────────────────────────────────────────────┘"
echo ""
