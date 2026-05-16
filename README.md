<div align="center">

<pre>
██╗  ██╗ ██████╗ ██████╗ ██████╗  █████╗
██║ ██╔╝██╔═══██╗██╔══██╗██╔══██╗██╔══██╗
█████╔╝ ██║   ██║██║  ██║██████╔╝███████║
██╔═██╗ ██║   ██║██║  ██║██╔══██╗██╔══██║
██║  ██╗╚██████╔╝██████╔╝██║  ██║██║  ██║
╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝
</pre>

### 🍎 macOS Edition • Apple Silicon

**One-command Azure developer environment for macOS.**<br>
40+ cloud-native tools, Homebrew + native `.pkg` installs, zero config.

[![macOS Lint & Unit Tests](https://github.com/codetocloudorg/kodra-macos/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/codetocloudorg/kodra-macos/actions/workflows/ci.yml)
[![macOS Install (Apple Silicon E2E)](https://github.com/codetocloudorg/kodra-macos/actions/workflows/e2e.yml/badge.svg?branch=main)](https://github.com/codetocloudorg/kodra-macos/actions/workflows/e2e.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![macOS](https://img.shields.io/badge/macOS-Apple%20Silicon-black?logo=apple)](https://github.com/codetocloudorg/kodra-macos)
[![Version](https://img.shields.io/badge/version-0.6.0-purple)](CHANGELOG.md)

</div>

---

## Quick Start

```bash
curl -fsSL https://kodra.macos.codetocloud.io/boot.sh | bash
```

That's it. From a fresh macOS to `azd up` in minutes.

---

## What's Included

### CLI Tools
| Tool | Purpose |
|------|---------|
| `bat` | Cat with syntax highlighting |
| `btop` | System monitor |
| `delta` | Beautiful git diffs with syntax highlighting |
| `direnv` | Per-directory environment variables |
| `eza` | Modern `ls` replacement |
| `fastfetch` | System info display |
| `fd` | Modern `find` replacement |
| `fzf` | Fuzzy finder |
| `gh` | GitHub CLI |
| `gh copilot` | GitHub Copilot CLI |
| `httpie` | Human-friendly HTTP client |
| `jq` | JSON processor |
| `lazygit` | Git TUI |
| `neovim` | Terminal editor |
| `ripgrep` | Fast grep |
| `shellcheck` | Shell script linter |
| `tldr` | Simplified man pages |
| `yq` | YAML processor |
| `zoxide` | Smart `cd` |
| `act` | Run GitHub Actions locally |

### Cloud & Infrastructure
| Tool | Purpose |
|------|---------|
| `az` | Azure CLI |
| `azd` | Azure Developer CLI |
| `bicep` | Azure Bicep |
| `terraform` | HashiCorp Terraform |
| `tofu` | OpenTofu |
| `kubectl` | Kubernetes CLI |
| `helm` | Kubernetes package manager |
| `k9s` | Kubernetes TUI |
| `pwsh` | PowerShell 7 (via `.pkg`) |
| `oc` | OpenShift CLI (Red Hat) |
| `ansible` | Red Hat Ansible automation |

### Containers (No Docker Desktop)
| Tool | Purpose |
|------|---------|
| `colima` | Lightweight container runtime (replaces Docker Desktop) |
| `docker` | Docker CLI + Compose |
| `lazydocker` | Docker TUI |
| `podman` | Daemonless container engine (alternative to Docker) |
| `podman-compose` | Compose support for Podman |
| Podman Desktop | GUI for managing containers, images, and pods |
| `trivy` | Container & IaC security scanner |
| `dive` | Explore container image layers |

> **Note:** During installation you choose either the **Docker** stack (Colima + Docker CLI + lazydocker) or the **Podman** stack (Podman + Podman Desktop + podman-compose). Both are license-free.

### Terminal & Shell
| Tool | Purpose |
|------|---------|
| Ghostty | GPU-accelerated terminal (Cyberpunk theme) |
| tmux | Terminal multiplexer with Kodra workspace menu |
| Starship | Cross-shell prompt |
| Nerd Fonts | JetBrains Mono + Meslo |
| zsh config | Aliases, completions, FZF integration |

### Developer Tools
| Tool | Purpose |
|------|---------|
| `mise` | Polyglot runtime manager (Node, Python, etc.) |
| VS Code | Editor with Copilot + Azure extensions |

### macOS Defaults
Developer-optimized system settings applied via native `defaults write`:
- Fast key repeat, disabled autocorrect
- Dock: auto-hide, minimal, no recents
- Finder: show extensions, hidden files, path bar
- Dark mode with purple accent
- Screenshots to `~/Screenshots`

---

## Requirements

- **macOS 14 (Sonoma)** or later
- **Apple Silicon** (M1/M2/M3/M4) recommended, Intel supported
- ~5GB free disk space
- Internet connection for initial install

---

## Usage

```bash
kodra help          # Show all commands
kodra doctor        # Check tool health
kodra doctor --fix  # Auto-reinstall missing tools
kodra update        # Update all tools (brew upgrade)
kodra cleanup       # Clean caches
kodra defaults      # Re-apply macOS settings
kodra shortcuts     # Show all aliases
kodra fetch         # System info (fastfetch)
kodra uninstall     # Remove all Kodra tools and configs
```

To uninstall Kodra completely:
```bash
bash ~/.kodra/uninstall.sh
```
Or select **option 5** from the install menu.

---

## Testing

Tests run on **real Apple Silicon** via GitHub Actions `macos-15` runners:

```bash
# Unit tests (syntax + structure, no network)
bash tests/unit/test-structure.sh

# Integration tests (actual installs via Homebrew)
bash tests/integration/test-install.sh
```

---

## Architecture

```
kodra-macos/
├── boot.sh                 # Bootstrap (curl | bash entry point)
├── install.sh              # Main orchestrator
├── uninstall.sh            # Clean removal
├── bin/kodra               # CLI tool
├── lib/                    # Shared libraries
│   ├── logging.sh          # Color output helpers
│   ├── utils.sh            # run_installer, brew_install, has_command
│   ├── checks.sh           # macOS version, Apple Silicon checks
│   ├── state.sh            # JSON state management
│   ├── backup.sh           # Dotfile backup/restore
│   ├── config.sh           # Key=value settings
│   ├── ui.sh               # Banners, progress, spinners
│   └── package.sh          # Homebrew package abstraction
├── install/
│   ├── cli-tools/          # bat, eza, fzf, gh, ripgrep, etc.
│   ├── cloud/              # az, azd, terraform, kubectl, etc.
│   ├── containers/         # colima, docker-cli, lazydocker, podman
│   ├── dev-tools/          # mise, vscode
│   ├── terminal/           # ghostty, tmux, starship, nerd-fonts, shell-config
│   └── desktop/            # dock, finder, system defaults
├── uninstall/              # Per-tool uninstallers
├── migrations/             # Version migration scripts
├── configs/
│   └── completions/        # zsh + bash tab completions
├── tests/
│   ├── unit/               # Fast structural tests (360 tests)
│   └── integration/        # Real install tests (CI)
├── llms.txt                # LLM-friendly summary
├── llms-full.txt           # Full LLM documentation
└── .github/workflows/
    ├── ci.yml              # Lint + unit tests
    └── e2e.yml             # Full install on Apple Silicon
```

---

## Comparison with Kodra Variants

| Feature | [Kodra](https://github.com/codetocloudorg/kodra) | [Kodra WSL](https://github.com/codetocloudorg/kodra-wsl) | **Kodra macOS** |
|---------|-------|-----------|-------------|
| OS | Ubuntu 24.04 | WSL2 Ubuntu | macOS 14+ |
| Package Manager | apt | apt | Homebrew + `.pkg` |
| Desktop | GNOME | Windows Terminal | Native macOS |
| Docker | Docker CE | Docker CE (no Desktop) | Colima or Podman (no Desktop) |
| Terminal | Ghostty | Oh My Posh | Ghostty + tmux + Starship |
| Architecture | x86_64/arm64 | x86_64 | Apple Silicon |
| CI Runners | ubuntu-24.04 | windows-2022 | macos-15 |

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. PRs welcome.

---

## License

[MIT](LICENSE) — A [Code To Cloud](https://codetocloud.io) Project ☁️
