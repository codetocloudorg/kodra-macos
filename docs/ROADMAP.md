# Kodra macOS — Roadmap

## Current: v0.1.0 (Initial Release)

✅ One-command installer with interactive profiles
✅ 25+ developer tools via Homebrew + native packages
✅ Ghostty terminal with splits and Tokyo Night theme
✅ Starship prompt with custom config
✅ Colima for Docker (no Docker Desktop licensing)
✅ Full zsh configuration with modern aliases
✅ kodra CLI (doctor, update, cleanup, help)
✅ CI/CD with ShellCheck and E2E on Apple Silicon
✅ Install logging and error handling
✅ State tracking and uninstaller

## Planned: v0.2.0

- [ ] `kodra repair` command — interactive repair of broken tools
- [ ] `kodra doctor --fix` — auto-remediation mode
- [ ] Enhanced `kodra update` — update all 25+ tools individually
- [ ] `gum` integration for prettier interactive menus
- [ ] Tool update tracking (which tools have updates available)
- [ ] Configs directory — externalized btop, fastfetch configs
- [ ] Shell completions for `kodra` CLI

## Planned: v0.3.0

- [ ] `kodra setup` — first-run wizard (GitHub auth, Azure login, Git config)
- [ ] Dotfiles backup/restore
- [ ] Custom tool profiles (save/load your selection)
- [ ] Plugin system for community tool installers
- [ ] Homebrew Bundle integration (`Brewfile` export/import)

## Future

- [ ] Landing page at kodra.macos.codetocloud.io
- [ ] SEO pages (llms.txt, sitemap.xml)
- [ ] VS Code devcontainer support
- [ ] Nix package manager as alternative to Homebrew
- [ ] Multi-architecture support (Intel Mac testing)
- [ ] Integration with Kodra WSL for cross-platform teams

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for how to help with these items.
