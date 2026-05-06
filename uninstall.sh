#!/usr/bin/env bash
#
# Kodra macOS Uninstall Script
# Removes Kodra configuration and CLI (tools installed via Homebrew remain)
#

set -e

KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
KODRA_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kodra"
KODRA_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/kodra"

echo ""
echo "  Kodra macOS — Uninstall"
echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  This will remove:"
echo "    • $KODRA_DIR (repo)"
echo "    • $KODRA_CONFIG_DIR (config)"
echo "    • $KODRA_STATE_DIR (state)"
echo "    • $HOME/.local/bin/kodra (CLI link)"
echo "    • Kodra shell config from ~/.zshrc"
echo ""
echo "  Homebrew-installed tools will NOT be removed."
echo "  To remove those: brew uninstall <tool>"
echo ""

read -rp "  Continue? [y/N] " confirm
if [[ "$confirm" != [yY] ]]; then
    echo "  Cancelled."
    exit 0
fi

echo ""

# Remove CLI symlink
if [[ -L "$HOME/.local/bin/kodra" ]]; then
    rm -f "$HOME/.local/bin/kodra"
    echo "  ✔ Removed CLI symlink"
fi

# Remove Colima launchd plist
if [[ -f "$HOME/Library/LaunchAgents/com.kodra.colima.plist" ]]; then
    launchctl unload "$HOME/Library/LaunchAgents/com.kodra.colima.plist" 2>/dev/null || true
    rm -f "$HOME/Library/LaunchAgents/com.kodra.colima.plist"
    echo "  ✔ Removed Colima launchd plist"
fi

# Remove shell config source line
if [[ -f "$HOME/.zshrc" ]]; then
    sed -i '' '/# Kodra macOS/d' "$HOME/.zshrc" 2>/dev/null || true
    sed -i '' '/kodra\/shell.zsh/d' "$HOME/.zshrc" 2>/dev/null || true
    echo "  ✔ Cleaned ~/.zshrc"
fi

# Remove directories
rm -rf "$KODRA_DIR"
echo "  ✔ Removed $KODRA_DIR"

rm -rf "$KODRA_CONFIG_DIR"
echo "  ✔ Removed $KODRA_CONFIG_DIR"

rm -rf "$KODRA_STATE_DIR"
echo "  ✔ Removed $KODRA_STATE_DIR"

echo ""
echo "  ✅ Kodra macOS uninstalled. Restart your terminal."
echo ""
