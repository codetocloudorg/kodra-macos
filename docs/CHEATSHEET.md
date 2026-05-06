# Kodra macOS — Cheatsheet

Quick reference for all Kodra-installed tools and shortcuts.

## Kodra CLI

| Command | Description |
|---------|-------------|
| `kodra doctor` | Check health of all installed tools |
| `kodra update` | Update Homebrew and all tools |
| `kodra cleanup` | Clean Homebrew cache and old versions |
| `kodra fetch` | Show system info via fastfetch |
| `kodra defaults` | Reapply macOS desktop settings |
| `kodra refresh` | Reload shell configuration |
| `kodra shortcuts` | Show keyboard shortcuts |
| `kodra version` | Show Kodra version |
| `kodra help` | Show all commands |

## Shell Aliases

| Alias | Expands To |
|-------|------------|
| `ls` | `eza --icons --group-directories-first` |
| `ll` | `eza -la --icons --group-directories-first` |
| `la` | `eza -a --icons` |
| `lt` | `eza --tree --level=2 --icons` |
| `cat` | `bat --paging=never` |
| `grep` | `rg` (ripgrep) |
| `find` | `fd` |
| `top` | `btop` |
| `lg` | `lazygit` |
| `ld` | `lazydocker` |

## Ghostty Terminal

| Shortcut | Action |
|----------|--------|
| `Cmd+D` | Split vertically (side-by-side) |
| `Cmd+Shift+D` | Split horizontally (top/bottom) |
| `Cmd+Shift+Enter` | Toggle zoom on current split |
| `Cmd+Alt+Arrow` | Navigate between splits |
| `Cmd+T` | New tab |
| `Cmd+W` | Close tab/split |

## fzf (Fuzzy Finder)

| Shortcut | Action |
|----------|--------|
| `Ctrl+R` | Search command history |
| `Ctrl+T` | Search files |
| `Alt+C` | Change directory (fuzzy) |

## zoxide (Smart cd)

| Command | Description |
|---------|-------------|
| `z <partial>` | Jump to frequently visited directory |
| `zi` | Interactive directory selection |

## Git Shortcuts

| Command | Description |
|---------|-------------|
| `gh pr create` | Create a pull request |
| `gh pr list` | List open PRs |
| `gh copilot suggest` | AI command suggestions |
| `gh copilot explain` | AI command explanations |
| `lazygit` / `lg` | Visual Git TUI |

## Azure CLI

| Command | Description |
|---------|-------------|
| `az login` | Authenticate to Azure |
| `az account show` | Show current subscription |
| `azd init` | Initialize Azure Developer CLI project |
| `azd up` | Provision and deploy |

## Container Tools

| Command | Description |
|---------|-------------|
| `colima start` | Start container runtime |
| `colima stop` | Stop container runtime |
| `docker ps` | List running containers |
| `docker compose up` | Start compose stack |
| `lazydocker` / `ld` | Visual Docker TUI |

## Kubernetes

| Command | Description |
|---------|-------------|
| `kubectl get pods` | List pods |
| `kubectl get svc` | List services |
| `helm install` | Install a Helm chart |
| `k9s` | Visual Kubernetes TUI |
