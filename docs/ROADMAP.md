# Kodra macOS — Roadmap

## Current: v0.5.0 (Full Uninstall & Podman Integration)

✅ Everything from v0.4.0 plus:
✅ Full uninstall removes all apps, tools, and configs (48 packages)
✅ Uninstall option (5) and Exit option (6) in install menu (now 6 options)
✅ Podman environment integration (DOCKER_HOST, VS Code settings, Testcontainers)
✅ krunkit for Podman Apple Silicon virtualization
✅ Copilot CLI installed as standalone cask
✅ Docker CLI always installed regardless of container runtime choice
✅ Unit tests expanded to 313
✅ E2E pipeline expanded with 8 new verification steps

## v0.4.0 (Podman & Container Choice)

✅ Everything from v0.3.0 plus:
✅ Podman as alternative container runtime option alongside Docker (Colima)
✅ Interactive container runtime selection during install (Docker or Podman)
✅ 9 new CLI tools: jq, delta, direnv, neovim, httpie, shellcheck, tldr, act
✅ Container security tools: trivy, dive
✅ Red Hat ecosystem: OpenShift CLI (oc), Ansible
✅ Tool count increased from 25+ to 40+

## v0.3.0 (CLI Parity & Uninstallers)

✅ Everything from v0.2.0 plus:
✅ 12 missing uninstallers — every installer now has a matching uninstaller
✅ Per-letter gradient ASCII art matching kodra and kodra-wsl
✅ Categorized CLI help sections (System, Configuration, Data, Development, Info)
✅ All commands visible in help text (resume, banner, db, ci)

## v0.2.0 (Feature Parity)

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

## Planned: v0.6.0

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
