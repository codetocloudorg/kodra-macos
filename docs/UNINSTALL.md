# Kodra macOS — Uninstallation Guide

## Quick Uninstall

```bash
~/.kodra/uninstall.sh
```

## What Gets Removed

The uninstaller removes:

1. **Kodra CLI symlink** — `~/.local/bin/kodra`
2. **Colima launchd agent** — `~/Library/LaunchAgents/com.kodra.colima.plist`
3. **Shell config** — Kodra source line from `~/.zshrc`
4. **Kodra config** — `~/.config/kodra/`
5. **Kodra state** — `~/.local/state/kodra/`
6. **Kodra directory** — `~/.kodra/`

## What Gets Preserved

The uninstaller does **NOT** remove:

- **Homebrew** — may be used by other tools
- **Homebrew-installed packages** — bat, fzf, ripgrep, etc. remain installed
- **Ghostty** — remains installed as a cask
- **VS Code** — remains installed
- **Colima/Docker** — remain installed (only the auto-start plist is removed)
- **Starship config** — `~/.config/starship.toml` remains
- **Ghostty config** — `~/.config/ghostty/config` remains
- **Nerd Fonts** — remain installed

## Complete Cleanup

To remove everything including Homebrew packages:

```bash
# 1. Run the uninstaller
~/.kodra/uninstall.sh

# 2. Remove Homebrew packages installed by Kodra
brew uninstall bat btop eza fastfetch fd fzf ripgrep yq zoxide \
  lazygit gh azure-cli azd terraform opentofu kubectl helm k9s \
  colima docker docker-compose lazydocker mise starship 2>/dev/null

# 3. Remove Homebrew casks
brew uninstall --cask ghostty visual-studio-code \
  font-jetbrains-mono-nerd-font 2>/dev/null

# 4. Remove remaining configs
rm -rf ~/.config/ghostty ~/.config/starship.toml

# 5. Clean Homebrew cache
brew cleanup --prune=all
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
