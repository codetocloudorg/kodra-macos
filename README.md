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
30+ cloud-native tools, Homebrew + native `.pkg` installs, zero config.

[![macOS Lint & Unit Tests](https://github.com/codetocloudorg/kodra-macos/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/codetocloudorg/kodra-macos/actions/workflows/ci.yml)
[![macOS Install (Apple Silicon E2E)](https://github.com/codetocloudorg/kodra-macos/actions/workflows/e2e.yml/badge.svg?branch=main)](https://github.com/codetocloudorg/kodra-macos/actions/workflows/e2e.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![macOS](https://img.shields.io/badge/macOS-Apple%20Silicon-black?logo=apple)](https://github.com/codetocloudorg/kodra-macos)
[![Version](https://img.shields.io/badge/version-0.1.0-purple)](CHANGELOG.md)

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
| `eza` | Modern `ls` replacement |
| `fastfetch` | System info display |
| `fd` | Modern `find` replacement |
| `fzf` | Fuzzy finder |
| `gh` | GitHub CLI |
| `gh copilot` | GitHub Copilot CLI |
| `lazygit` | Git TUI |
| `ripgrep` | Fast grep |
| `yq` | YAML processor |
| `zoxide` | Smart `cd` |

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

### Containers (No Docker Desktop)
| Tool | Purpose |
|------|---------|
| `colima` | Lightweight container runtime (replaces Docker Desktop) |
| `docker` | Docker CLI + Compose |
| `lazydocker` | Docker TUI |

### Terminal & Shell
| Tool | Purpose |
|------|---------|
| Ghostty | GPU-accelerated terminal |
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
```

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
│   ├── logging.sh
│   ├── utils.sh
│   ├── checks.sh
│   └── state.sh
├── install/
│   ├── cli-tools/          # bat, eza, fzf, gh, ripgrep, etc.
│   ├── cloud/              # az, azd, terraform, kubectl, etc.
│   ├── containers/         # colima, docker-cli, lazydocker
│   ├── dev-tools/          # mise, vscode
│   ├── terminal/           # ghostty, starship, nerd-fonts, shell-config
│   └── desktop/            # dock, finder, system defaults
├── tests/
│   ├── unit/               # Fast structural tests
│   └── integration/        # Real install tests (CI)
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
| Docker | Docker CE | Docker CE (no Desktop) | Colima (no Desktop) |
| Terminal | Ghostty | Oh My Posh | Ghostty + Starship |
| Architecture | x86_64/arm64 | x86_64 | Apple Silicon |
| CI Runners | ubuntu-24.04 | windows-2022 | macos-15 |

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines. PRs welcome.

---

## License

[MIT](LICENSE) — A [Code To Cloud](https://codetocloud.io) Project ☁️
