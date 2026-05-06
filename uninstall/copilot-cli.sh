#!/usr/bin/env bash
# Kodra macOS — Uninstall GitHub Copilot CLI
KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

ensure_brew_path

log_info "Removing GitHub Copilot CLI..."
npm uninstall -g @githubnext/github-copilot-cli 2>/dev/null || true
gh extension remove github/gh-copilot 2>/dev/null || true

log_success "GitHub Copilot CLI uninstalled"
