# Changelog

All notable changes to Kodra macOS will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-05-05

### Added
- Initial release of Kodra macOS — Apple Silicon developer environment
- One-command installer via `boot.sh` (curl | bash entry point)
- Interactive install menu with 4 profiles (Full, Minimal, Developer, Cloud Engineer)
- Install logging to file with error handler and system info dump
- 12 CLI tools: bat, btop, eza, fastfetch, fd, fzf, ripgrep, yq, zoxide, GitHub CLI, Copilot CLI, lazygit
- 9 cloud/infrastructure tools: Azure CLI, azd, Bicep, Terraform, OpenTofu, kubectl, Helm, k9s, PowerShell (native .pkg)
- 3 container tools: Colima (Docker Desktop alternative), Docker CLI + Compose, lazydocker
- Ghostty terminal with Tokyo Night theme and split keybindings
- Starship prompt with custom configuration
- Full zsh shell configuration with aliases, keybindings, and tool integrations
- Nerd Fonts (JetBrainsMono) installation
- mise for Node.js and Python version management
- VS Code with curated extension list
- macOS desktop customization (Dock, Finder, keyboard, trackpad, dark mode)
- Colima auto-start via launchd plist
- `kodra` CLI with doctor, update, cleanup, fetch, defaults, refresh, shortcuts, version, help
- State tracking via JSON (`~/.local/state/kodra/state.json`)
- Comprehensive unit tests (95 tests — syntax, structure, conventions)
- Integration tests (full install + tool verification)
- CI workflow with ShellCheck on macOS-15
- E2E workflow mimicking real user install on Apple Silicon runner
- Clean uninstaller (`uninstall.sh`)

[0.1.0]: https://github.com/codetocloudorg/kodra-macos/releases/tag/v0.1.0
