# AGENTS.md — AI Coding Agent Guide for Kodra macOS

## Project Overview

Kodra macOS is a one-command Apple Silicon developer environment. It transforms a fresh macOS install into a fully-configured cloud-native development workstation with 40+ tools — zero config required. Built and maintained by [Code To Cloud Inc.](https://www.codetocloud.io)

**Website**: [kodra.macos.codetocloud.io](https://kodra.macos.codetocloud.io)

Key focuses:
- Azure cloud development (CLI, azd, Bicep, Terraform, OpenTofu)
- Colima + Docker CLI (no Docker Desktop license required), Kubernetes (kubectl, Helm, k9s)
- Modern terminal experience (Starship prompt, Ghostty terminal, tmux multiplexer, Nerd Fonts, fzf, zoxide, eza, bat)
- GitHub Copilot CLI for AI-powered terminal workflows
- macOS-native setup (Homebrew, launchd, zsh)

---

## Shell Conventions

All scripts in this project **must** follow these conventions:

```bash
#!/usr/bin/env bash
```

- **`snake_case`** for function names: `brew_install`, `check_macos_version`
- **`UPPERCASE`** for global constants and environment variables: `KODRA_DIR`, `KODRA_DEBUG`
- **`local`** for all variables inside functions — no leaking into global scope
- **`command -v`** to check if a command exists — **never** use `which`
- **Double-quote** all variable expansions: `"${KODRA_DIR}"`, not `$KODRA_DIR`
- Source shared libraries with: `source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"`

---

## File Organization

```
kodra-macos/
├── bin/kodra                  # CLI dispatcher (entry point)
├── install/                   # Tool installers by category
│   ├── cloud/                 #   azure-cli.sh, azd.sh, bicep.sh, terraform.sh, opentofu.sh,
│   │                          #   powershell.sh, kubectl.sh, helm.sh, k9s.sh
│   ├── containers/            #   colima.sh, docker-cli.sh, lazydocker.sh
│   ├── terminal/              #   ghostty.sh, tmux.sh, nerd-fonts.sh, starship.sh, shell-config.sh
│   ├── cli-tools/             #   github-cli.sh, copilot-cli.sh, fzf.sh, lazygit.sh,
│   │                          #   zoxide.sh, eza.sh, bat.sh, btop.sh, fastfetch.sh,
│   │                          #   ripgrep.sh, yq.sh, fd.sh
│   ├── dev-tools/             #   mise.sh, vscode.sh
│   └── desktop/               #   dock.sh, finder.sh, defaults.sh
├── lib/
│   ├── logging.sh             # Color output helpers
│   ├── utils.sh               # Shared utility functions (brew_install, run_installer)
│   ├── checks.sh              # Pre-flight system checks
│   └── state.sh               # JSON state management
├── tests/
│   ├── unit/test-structure.sh # Structural and syntax tests
│   └── integration/test-install.sh  # Full install verification
├── boot.sh                    # Bootstrap script (curl | bash entry point)
├── install.sh                 # Main installer orchestrator
├── uninstall.sh               # Clean uninstaller
├── AGENTS.md                  # This file — AI agent guide
├── SECURITY.md                # Security policy
├── CONTRIBUTING.md            # Contribution guidelines
├── CODE_OF_CONDUCT.md         # Community code of conduct
├── CHANGELOG.md               # Release history
└── VERSION                    # Current version number
```

---

## macOS-Specific Considerations

Kodra macOS runs **exclusively on macOS with Apple Silicon**. Key differences from the WSL variant:

- **Homebrew** is the primary package manager — `brew install` and `brew install --cask`
- **zsh** is the default shell (not bash) — config goes in `~/.zshrc`
- **Starship** is the prompt (not Oh My Posh) — config at `~/.config/starship.toml`
- **Ghostty** is the terminal emulator (not Windows Terminal)
- **tmux** is the terminal multiplexer with Kodra workspace menu
- **Colima** provides Docker (not Docker CE directly) — lightweight Lima VM
- **launchd** replaces systemd — plist files in `~/Library/LaunchAgents/`
- **PowerShell** installed via native `.pkg` from Microsoft GitHub releases (not Homebrew)
- **No sudo** for Homebrew installs — user-level `/opt/homebrew` on Apple Silicon
- **Nerd Fonts** installed via Homebrew cask (not manual download)
- **Desktop settings** configured via `defaults write` commands

---

## Testing

### Unit Tests

```bash
bash tests/unit/test-structure.sh
```

Validates script syntax, file existence, installer conventions, and architecture safety.

### Integration Tests

```bash
bash tests/integration/test-install.sh
```

Runs the full installer and verifies every tool, CLI commands, shell config, and state.

### Health Check

```bash
kodra doctor
```

Runs the full diagnostic suite — checks every installed tool, verifies versions, and reports status.

---

## What NOT to Do

| ❌ Don't | ✅ Do Instead |
|---|---|
| Use `apt` or `apt-get` | Use `brew install` or `brew install --cask` |
| Use `sudo` for Homebrew | Homebrew on Apple Silicon is user-level |
| Hardcode `/usr/local` paths | Use `brew_prefix()` function (handles AS vs Intel) |
| Use `eval` to run commands | Call commands directly |
| Use `which` to check for commands | Use `command -v` or `has_command` |
| Add Docker Desktop | Use Colima — no licensing issues |
| Reference Oh My Posh | macOS uses Starship prompt |
| Reference Windows Terminal | macOS uses Ghostty |
| Add `.bashrc` config | macOS default shell is zsh — use `.zshrc` |
| Reference systemd/wsl.conf | macOS uses launchd plists |
| Skip quoting variables | Always double-quote: `"${var}"` |

---

## Adding a New Tool Installer

1. Create `install/<category>/<tool-name>.sh`
2. Follow the script template:
   ```bash
   #!/usr/bin/env bash
   source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

   brew_install <tool-name>
   ```
3. Add the tool to `install.sh` orchestrator in the correct section
4. Add a health check in `bin/kodra` doctor section
5. Update `README.md` tool list
6. Test on macOS Apple Silicon

---

## Version Bump Checklist

When releasing a new version of Kodra macOS:

1. **`VERSION`** — update the version number
2. **`CHANGELOG.md`** — add release notes under new version heading
3. **`install.sh`** — verify version references
4. **`README.md`** — update any version references
5. Tag the release: `git tag -a v<version> -m "Release v<version>"`
