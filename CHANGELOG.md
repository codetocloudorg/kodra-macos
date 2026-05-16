# Changelog

All notable changes to Kodra macOS will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.6.0] - 2026-05-16

### Added
- tmux terminal multiplexer with Kodra-branded config (Ctrl+a prefix, Cyberpunk status bar)
- Sidebar agent menu for tmux (`Ctrl+a s`) to switch between workspaces
- Enhanced Ghostty config: Cyberpunk theme, background opacity/blur, quick terminal (Cmd+`), split resize keybindings, tab management
- `configs/sidebar-menu.sh` for tmux workspace switching

### Changed
- Ghostty theme changed from Tokyo Night to Cyberpunk with visual enhancements
- Doctor health check now includes tmux and terminal fix path
- Uninstall now removes tmux, tmux.conf, and sidebar-menu.sh
- Unit tests expanded to 360 (from 313) with Ghostty and tmux coverage
- E2E pipeline expanded with Ghostty/tmux config verification

## [0.5.0] - 2026-05-15

### Added
- Full uninstall removes all apps, tools, and configs (48 packages total)
- Uninstall option (5) and Exit option (6) in install menu (now 6 options)
- Podman environment integration (DOCKER_HOST, VS Code settings, Testcontainers)
- krunkit for Podman Apple Silicon virtualization
- Copilot CLI installed as standalone cask

### Fixed
- Homebrew sudo prompt failure when running via `curl | bash` (piped stdin)
- `log_debug` command not found in subshell installers
- Box formatting alignment with emoji widths

### Changed
- Docker CLI always installed regardless of container runtime choice
- Uninstall now removes everything (was partial before)
- Unit tests expanded to 313 (from ~270)
- E2E pipeline expanded with 8 new verification steps

## [0.4.0] - 2026-05-15

### Added
- Podman as alternative container runtime option alongside Docker (Colima)
- New installer: `install/containers/podman.sh` — installs Podman, podman-compose, Podman Desktop, and podman-docker
- Interactive container runtime selection during install (Docker or Podman)
- Podman machine auto-init for Apple Silicon (4 CPU, 8GB RAM, rootful)
- Podman launchd plist for auto-start on login (`com.kodra.podman.plist`)
- Docker CLI compatibility via `podman-docker` when Podman is selected
- 9 new CLI tools: jq, delta (git-delta), direnv, neovim, httpie, shellcheck, tldr, act
- Container security tools: trivy (vulnerability scanner), dive (image layer explorer)
- Red Hat ecosystem: OpenShift CLI (oc), Ansible
- delta auto-configured as git pager with side-by-side diffs and line numbers
- direnv hooked into zsh shell config

### Changed
- `install.sh` — new container runtime prompt: option 1 (Docker/Colima) or option 2 (Podman/Podman Desktop)
- `install.sh` — cloud section renamed to "Azure, Red Hat & Cloud Tools" with oc and ansible
- `bin/kodra doctor` — checks all new tools; detects saved container runtime from state
- `bin/kodra cleanup` — prunes images for whichever runtime is installed (Docker and/or Podman)
- `bin/kodra install` menu — updated container label to reflect both options
- `uninstall.sh` — cleans up both Colima and Podman launchd plists
- Container runtime selection saved to state (`container.runtime`) for doctor and other commands
- Next-steps banner dynamically shows Colima or Podman start command based on selection
- Updated README, llms.txt, llms-full.txt, cheatsheet, FAQ, troubleshooting docs
- Tool count increased from 25+ to 40+

## [0.3.0] - 2026-05-06

### Added
- 12 missing uninstallers: opentofu, bicep, copilot-cli, azd, bat, btop, eza, fd, fzf, ripgrep, yq, zoxide
- Every installer now has a matching uninstaller (complete parity)

### Changed
- CLI help: per-letter gradient ASCII art matching kodra and kodra-wsl
- CLI help: categorized sections (System, Configuration, Data, Development, Info)
- CLI help: all new commands (resume, banner, db, ci) now visible in help text
- Wider separator lines matching kodra upstream style
- Removed azure-storage-explorer (not applicable)

## [0.2.0] - 2026-05-06

### Added
- `resume` CLI command — resume interrupted installations from where they left off
- `motd|banner` CLI command — display ASCII logo and system info
- `db|database` CLI command — inspect Kodra state database
- `ci-report|ci` CLI command — show CI pipeline status via GitHub CLI
- `lib/state.sh` resume infrastructure — 10 functions: `mark_step_complete`, `is_step_complete`, `mark_step_failed`, `get_failed_steps`, `get_pending_steps`, `get_resume_point`, `clear_state`, `show_state_summary`, `get_install_progress`, `can_resume`
- `lib/checks.sh` enhanced pre-flight — `check_internet`, `check_memory`, `check_shell`, `check_dns`, `run_all_checks`, `show_checks_summary`
- `lib/logging.sh` file logging — `init_log`, `_rotate_logs`, `_write_log` with automatic log rotation (5 files)
- `lib/backup.sh` granular backup/restore — per-category functions for dotfiles, shell config, and tool configs
- `lib/utils.sh` extended utilities — `check_internet_connection`, `elapsed_time`, `cleanup_on_exit`, `ensure_dir`, `log_to_file`, `get_kodra_version`
- Command aliases: `uninstall|remove`, `shortcuts|alias|aliases`
- `.github/dependabot.yml` — automated GitHub Actions dependency updates
- Version consistency tests — VERSION semver validation, cross-file version checks, CLI version output verification
- 200+ unit tests (up from 168)

### Changed
- Bumped version to 0.2.0
- Full feature parity with kodra and kodra-wsl (no critical or moderate gaps)
- All lib files now have WSL-equivalent function coverage

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

[0.6.0]: https://github.com/codetocloudorg/kodra-macos/releases/tag/v0.6.0
[0.5.0]: https://github.com/codetocloudorg/kodra-macos/releases/tag/v0.5.0
[0.4.0]: https://github.com/codetocloudorg/kodra-macos/releases/tag/v0.4.0
[0.3.0]: https://github.com/codetocloudorg/kodra-macos/releases/tag/v0.3.0
[0.2.0]: https://github.com/codetocloudorg/kodra-macos/releases/tag/v0.2.0
[0.1.0]: https://github.com/codetocloudorg/kodra-macos/releases/tag/v0.1.0
