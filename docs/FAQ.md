# Kodra macOS — FAQ

## General

### What is Kodra macOS?

Kodra macOS is an opinionated, one-command developer environment for macOS Apple Silicon. It installs and configures 40+ development tools for cloud-native development with Azure, Kubernetes, and modern CLI workflows.

### How is it different from the WSL variant?

| Aspect | Kodra WSL | Kodra macOS |
|--------|-----------|-------------|
| OS | Ubuntu on WSL2 | macOS (Apple Silicon) |
| Package Manager | apt + Homebrew | Homebrew + native .pkg |
| Shell | bash/zsh | zsh (macOS default) |
| Prompt | Oh My Posh | Starship |
| Terminal | Windows Terminal | Ghostty |
| Docker | Docker CE (native) | Colima or Podman + Docker CLI |
| Service Manager | systemd | launchd |

### Does it work on Intel Macs?

Kodra macOS is designed for Apple Silicon (M1/M2/M3/M4). It may work on Intel Macs but is untested and unsupported. Homebrew paths differ between architectures (`/opt/homebrew` vs `/usr/local`), which our scripts handle, but CI only tests on Apple Silicon.

### What macOS versions are supported?

macOS 14 (Sonoma) and later. We test on macOS 15 (Sequoia) in CI.

## Installation

### How do I install?

```bash
curl -fsSL https://kodra.macos.codetocloud.io/boot.sh | bash
```

### Can I install only specific tools?

Yes. The installer offers 6 options:
1. **Full Install** — all tools (default)
2. **Minimal** — shell + CLI tools only
3. **Developer** — shell + CLI + Git + Containers
4. **Cloud Engineer** — everything except desktop tweaks
5. **Uninstall Kodra** — remove all Kodra tools, configs, and apps
6. **Exit** — quit without making changes

### How do I uninstall?

```bash
bash ~/.kodra/uninstall.sh
```

Or select **option 5** from the install menu (`curl -fsSL https://kodra.macos.codetocloud.io/boot.sh | bash`).

The uninstaller now removes **everything**: all Homebrew formulae (41), all casks (6 apps), PowerShell.app, gh-copilot extension, config files, VS Code Kodra settings, shell config, launchd plists, Podman/Colima data, and all Kodra directories. Only Homebrew itself is preserved.

### Installation failed — what do I do?

1. Check the install log: `~/.config/kodra/install.log`
2. Run `kodra doctor` to see what succeeded
3. Try reinstalling the failed tool manually (check the specific installer in `install/`)
4. Open an issue with the log output

## Tools

### Why Colima instead of Docker Desktop?

Docker Desktop requires a paid license for commercial use in organizations with 250+ employees or $10M+ revenue. Colima is a free, open-source alternative that runs Docker in a lightweight Lima VM. See [docs/COLIMA_VS_DESKTOP.md](COLIMA_VS_DESKTOP.md).

### Can I use Podman instead of Docker?

Yes! During installation, Kodra asks you to choose between the **Docker stack** (Colima + Docker CLI + lazydocker) and the **Podman stack** (Podman + Podman Desktop + podman-compose). Both are free and license-free. Podman is daemonless and rootless by default, and `podman-docker` provides Docker CLI compatibility if needed.

### Why Ghostty instead of iTerm2?

Ghostty is a native macOS terminal that's GPU-accelerated, supports splits/tabs, and is lightweight. It's created by Mitchell Hashimoto (founder of HashiCorp). While iTerm2 is excellent, Ghostty is more modern and aligns with Kodra's opinionated approach.

### Why Starship instead of Oh My Posh?

Starship is cross-platform, fast (written in Rust), and has excellent macOS/zsh integration. Oh My Posh is used in the WSL variant due to better Windows Terminal integration. Each variant uses what works best for its platform.

### Why PowerShell via .pkg instead of Homebrew?

The native `.pkg` installer from Microsoft provides the most reliable PowerShell installation on macOS, avoiding potential Homebrew cask issues and ensuring proper system integration.

### Can I add my own tools?

Yes! Create an installer script in the appropriate `install/` subdirectory following the existing pattern, then add it to `install.sh`. See [CONTRIBUTING.md](../CONTRIBUTING.md).

## Troubleshooting

### Tools not found after install

Restart your terminal or run `source ~/.zshrc`. If that doesn't work, check that `~/.local/bin` is in your PATH.

### Homebrew commands fail

Ensure Homebrew is initialized: `eval "$(/opt/homebrew/bin/brew shellenv)"`

### Colima won't start

```bash
colima delete  # Remove existing VM
colima start   # Create fresh VM
```

See [docs/TROUBLESHOOTING.md](TROUBLESHOOTING.md) for more.
