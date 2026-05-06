# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security seriously. If you discover a security vulnerability in Kodra macOS, please report it responsibly.

### How to Report

**Do NOT open a public GitHub issue for security vulnerabilities.**

Instead, please:

1. **Email**: Send details to security@codetocloud.io
2. **Discord**: DM a maintainer on our [Discord server](https://discord.gg/vwfwq2EpXJ)

### What to Include

Please include the following information:

- Description of the vulnerability
- Steps to reproduce the issue
- Potential impact assessment
- Any suggested fixes (optional)

### Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 7 days
- **Resolution Target**: Within 30 days for critical issues

### Security Best Practices for Users

When using Kodra macOS:

1. **Review scripts before running**: Always inspect `boot.sh` and installation scripts before execution
2. **Keep macOS updated**: Run Software Update regularly
3. **Update Kodra tools**: Run `kodra update` to get the latest tool versions
4. **Secure your credentials**:
   - Don't commit Azure credentials to repos
   - Use `az login` for authentication
   - Store secrets in Azure Key Vault

### Third-Party Tools

Kodra macOS installs several third-party tools. Security updates for these tools are managed by their respective maintainers:

- **Colima/Docker**: [Colima Security](https://github.com/abiosoft/colima)
- **Azure CLI**: [Microsoft Security Updates](https://docs.microsoft.com/security-updates/)
- **GitHub CLI**: [GitHub Security](https://github.com/security)
- **Terraform/OpenTofu**: [HashiCorp Security](https://www.hashicorp.com/security)
- **Homebrew**: [Homebrew Security](https://docs.brew.sh/Security)

We recommend running `kodra update` regularly to get the latest versions.

### macOS-Specific Security

- Homebrew installs to `/opt/homebrew` (Apple Silicon) with user-level permissions
- Colima runs Docker in a lightweight Lima VM, isolated from the host
- No system-level daemons are installed — only user-level launchd agents
- Shell config modifications are limited to `~/.zshrc` sourcing

## Acknowledgments

We appreciate responsible security researchers who help keep Kodra macOS safe. Contributors who report valid security issues will be acknowledged (with permission) in our release notes.
