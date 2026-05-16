# Kodra macOS — Installation Guide

## Quick Install

```bash
curl -fsSL https://kodra.macos.codetocloud.io/boot.sh | bash
```

This will:
1. Verify you're running macOS on Apple Silicon
2. Install Homebrew (if not present)
3. Clone the Kodra repository to `~/.kodra`
4. Run the full installation

## Requirements

- **macOS 14+** (Sonoma or later)
- **Apple Silicon** (M1, M2, M3, M4 or later)
- **~5 GB** free disk space
- **Internet connection**
- **Admin account** (for Xcode Command Line Tools)

## Install Profiles

The installer offers interactive profile selection:

| Profile | What's Included |
|---------|----------------|
| **1. Full Install** (default) | Everything — all tools + desktop tweaks |
| **2. Minimal** | Shell environment + CLI tools only |
| **3. Developer** | Shell + CLI + Git tools + Containers |
| **4. Cloud Engineer** | Everything except desktop customization |
| **5. Uninstall Kodra** | Remove all Kodra tools, configs, and apps |
| **6. Exit** | Quit without making changes |

### Non-Interactive Install

For automation (CI, scripts), the installer auto-selects Full Install:

```bash
KODRA_SKIP_PROMPTS=1 ~/.kodra/install.sh
```

### Debug Mode

Continue past failures and show a summary at the end:

```bash
~/.kodra/install.sh --debug
```

## What Gets Installed

### Shell Environment
- Ghostty terminal (with Tokyo Night theme, split keybindings)
- JetBrainsMono Nerd Font
- Starship prompt (with custom config)
- zsh configuration (aliases, keybindings, tool integrations)

### CLI Tools
bat, btop, eza, fastfetch, fd, fzf, ripgrep, yq, zoxide

### Git Tools
GitHub CLI, GitHub Copilot CLI, lazygit

### Cloud & Infrastructure
Azure CLI, Azure Developer CLI (azd), Bicep, Terraform, OpenTofu, PowerShell 7, kubectl, Helm, k9s

### Containers
Colima (Docker Desktop alternative), Docker CLI + Compose, lazydocker

**OR** Podman + Podman Desktop + podman-compose (daemonless alternative)

> During installation you choose either the **Docker** stack (Colima + Docker CLI + lazydocker) or the **Podman** stack (Podman + Podman Desktop + podman-compose). Docker CLI is always installed regardless of your choice. Both options are license-free.

### Development Tools
mise (Node.js + Python version manager), VS Code (with extensions)

### macOS Desktop
Dock auto-hide, Finder developer settings, keyboard repeat rate, trackpad tap-to-click, screenshot location, dark mode

## File Locations

| What | Where |
|------|-------|
| Kodra scripts | `~/.kodra/` |
| CLI binary | `~/.local/bin/kodra` |
| Shell config | `~/.config/kodra/shell.zsh` |
| Starship config | `~/.config/starship.toml` |
| Ghostty config | `~/.config/ghostty/config` |
| State file | `~/.local/state/kodra/state.json` |
| Install log | `~/.config/kodra/install.log` |
| Colima launchd | `~/Library/LaunchAgents/com.kodra.colima.plist` |
| Podman launchd | `~/Library/LaunchAgents/com.kodra.podman.plist` |

## Post-Install

1. **Restart your terminal** (or `source ~/.zshrc`)
2. **Verify**: `kodra doctor`
3. **Start your container runtime**: `colima start` (Docker) or `podman machine start` (Podman)
4. **Login to GitHub**: `gh auth login`
5. **Login to Azure**: `az login`

## Updating

```bash
kodra update
```

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues.
