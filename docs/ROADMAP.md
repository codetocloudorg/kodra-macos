# Kodra macOS — Roadmap

## Current: v0.2.0 (Feature Parity)

✅ Everything from v0.1.0 plus:
✅ Resume interrupted installations (`kodra resume`)
✅ MOTD/banner command with system info (`kodra banner`)
✅ State database inspection (`kodra db`)
✅ CI status reporting (`kodra ci`)
✅ Enhanced pre-flight checks (internet, memory, shell, DNS)
✅ File logging with rotation (5-file retention)
✅ Granular dotfile/shell/tool config backup & restore
✅ Extended utility functions (internet check, elapsed time, cleanup)
✅ Command aliases (`remove`, `aliases`)
✅ Dependabot for GitHub Actions
✅ 200+ unit tests with version consistency validation
✅ Full feature parity with kodra and kodra-wsl

## v0.1.0 (Initial Release)

✅ One-command installer with interactive profiles
✅ 30+ developer tools via Homebrew + native packages
✅ Ghostty terminal with splits and Tokyo Night theme
✅ Starship prompt with custom config
✅ Colima for Docker (no Docker Desktop licensing)
✅ Full zsh configuration with modern aliases
✅ kodra CLI with 20+ commands
✅ CI/CD with ShellCheck and E2E on Apple Silicon
✅ Install logging and error handling
✅ State tracking and uninstaller

## Planned: v0.3.0

- [ ] `kodra doctor --fix` — auto-remediation mode
- [ ] `gum` integration for prettier interactive menus
- [ ] Tool update tracking (which tools have updates available)
- [ ] Plugin system for community tool installers
- [ ] Homebrew Bundle integration (`Brewfile` export/import)
- [ ] VS Code devcontainer support
- [ ] Nix package manager as alternative to Homebrew
- [ ] Multi-architecture support (Intel Mac testing)
- [ ] Integration with Kodra WSL for cross-platform teams

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for how to help with these items.
