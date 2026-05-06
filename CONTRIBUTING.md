# Contributing to Kodra macOS

Thank you for your interest in contributing to Kodra macOS! This document provides guidelines for contributing.

## Code of Conduct

Be respectful and constructive. We welcome contributors of all skill levels.

## How to Contribute

### Reporting Issues

1. Check if the issue already exists in [GitHub Issues](https://github.com/codetocloudorg/kodra-macos/issues)
2. If not, create a new issue with:
   - Clear, descriptive title
   - Steps to reproduce
   - Expected vs actual behavior
   - Your environment (macOS version, chip, Homebrew version)
   - Output of `kodra doctor`

### Suggesting Features

Open a GitHub issue with the `enhancement` label. Include:
- What problem does this solve?
- How should it work?
- Any alternatives you've considered

### Pull Requests

1. **Fork** the repository
2. **Create a branch** for your feature: `git checkout -b feature/my-feature`
3. **Test your changes** on a macOS Apple Silicon machine
4. **Commit** with clear messages: `git commit -m "Add: new feature description"`
5. **Push** to your fork: `git push origin feature/my-feature`
6. **Open a PR** against `main`

## Development Setup

### Local Testing

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/kodra-macos.git
cd kodra-macos

# Make scripts executable
chmod +x boot.sh install.sh bin/kodra

# Test specific installers
export KODRA_DIR=$(pwd)
bash install/cloud/azure-cli.sh
```

### Testing on macOS VM

GitHub Actions `macos-15` runners provide Apple Silicon (M1) environments for CI testing.

## Code Style

### Shell Scripts

- Use `#!/usr/bin/env bash`
- Use `set -e` for critical scripts
- Quote variables: `"$var"` not `$var`
- Use `[[ ]]` for conditionals
- Add comments for non-obvious code
- Follow existing naming conventions

### Installers

Each tool installer in `install/` should:

1. Source utility functions
2. Check if already installed (via Homebrew)
3. Install the tool
4. Verify installation
5. Show success/failure

Example:

```bash
#!/usr/bin/env bash
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

if has_command tool; then
    log_info "tool already installed"
    exit 0
fi

brew_install tool
```

## Adding New Tools

1. Create installer script in appropriate `install/` subdirectory
2. Add to `install.sh` in the correct section
3. Add check to `bin/kodra` doctor subcommand
4. Update `README.md` tool list
5. Test on a macOS Apple Silicon machine

## Commit Messages

Use conventional commits:

- `Add:` New feature
- `Fix:` Bug fix
- `Update:` Update existing feature
- `Remove:` Remove feature
- `Docs:` Documentation only
- `Refactor:` Code refactoring

## Questions?

- Open a [GitHub Discussion](https://github.com/codetocloudorg/kodra-macos/discussions)
- Join our [Discord](https://discord.gg/vwfwq2EpXJ)

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
