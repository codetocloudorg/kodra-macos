# Kodra macOS — Uninstallation Guide

## Quick Uninstall

```bash
bash ~/.kodra/uninstall.sh
```

Or select **option 5** from the install menu:
```bash
curl -fsSL https://kodra.macos.codetocloud.io/boot.sh | bash
```

## What Gets Removed

The uninstaller removes **everything** Kodra installed:

1. **Homebrew formulae (41)** — bat, btop, eza, fd, fzf, ripgrep, yq, zoxide, lazygit, gh, jq, delta, direnv, neovim, httpie, shellcheck, tldr, act, azure-cli, azd, terraform, opentofu, kubectl, helm, k9s, colima, docker, docker-compose, lazydocker, podman, podman-compose, podman-docker, trivy, dive, mise, starship, fastfetch, openshift-cli, ansible, krunkit, and more
2. **Homebrew casks (6)** — Ghostty, VS Code, Podman Desktop, Nerd Fonts, GitHub Copilot CLI, and others
3. **PowerShell.app** — `/usr/local/microsoft/powershell` and `/usr/local/bin/pwsh`
4. **gh-copilot extension** — GitHub Copilot CLI extension
5. **Config files** — `~/.config/kodra/`, `~/.config/starship.toml`, `~/.config/ghostty/`
6. **VS Code Kodra settings** — Kodra-managed VS Code configuration
7. **Shell config** — Kodra source line from `~/.zshrc`
8. **launchd plists** — `com.kodra.colima.plist`, `com.kodra.podman.plist`
9. **Container data** — Colima VMs and Podman machines
10. **Kodra state** — `~/.local/state/kodra/`
11. **Kodra directory** — `~/.kodra/`
12. **Kodra CLI symlink** — `~/.local/bin/kodra`

## What Gets Preserved

The uninstaller does **NOT** remove:

- **Homebrew itself** — may be used by other tools (see below to remove)
- **Any non-Kodra tools** — tools you installed separately are untouched

### Removing Homebrew

If you want to remove Homebrew entirely after uninstalling Kodra:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```

## Removing Individual Tools

To remove a specific tool without uninstalling Kodra:

```bash
# Homebrew formula
brew uninstall <tool-name>

# Homebrew cask
brew uninstall --cask <tool-name>

# PowerShell (installed via .pkg)
sudo rm -rf /usr/local/bin/pwsh /usr/local/microsoft/powershell
sudo pkgutil --forget com.microsoft.powershell
```
