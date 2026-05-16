# Kodra macOS — Troubleshooting

## Installation Issues

### "Command not found" after install

**Problem**: Tools are installed but not found in PATH.

**Fix**:
```bash
# Restart terminal or reload shell
source ~/.zshrc

# Verify PATH includes local bin
echo $PATH | tr ':' '\n' | grep -E '(homebrew|local/bin)'
```

### Homebrew not found

**Problem**: `brew` command not available.

**Fix**:
```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel (if applicable)
eval "$(/usr/local/bin/brew shellenv)"
```

### Install script fails partway through

**Problem**: Installation stops at a specific tool.

**Fix**:
1. Check the log: `cat ~/.config/kodra/install.log`
2. Re-run in debug mode to skip failures: `~/.kodra/install.sh --debug`
3. Install the failed tool manually using the specific installer

### Permission denied errors

**Problem**: Scripts aren't executable.

**Fix**:
```bash
chmod +x ~/.kodra/boot.sh ~/.kodra/install.sh ~/.kodra/bin/kodra
find ~/.kodra/install -name "*.sh" -exec chmod +x {} \;
```

## Tool-Specific Issues

### Colima

#### Won't start
```bash
# Check status
colima status

# Delete and recreate
colima delete
colima start --cpu 2 --memory 4

# Check logs
colima logs
```

#### Docker commands fail
```bash
# Verify Colima is running
colima status

# Verify Docker context
docker context ls
docker context use colima
```

#### Auto-start not working
```bash
# Check launchd agent
launchctl list | grep colima

# Reload agent
launchctl unload ~/Library/LaunchAgents/com.kodra.colima.plist
launchctl load ~/Library/LaunchAgents/com.kodra.colima.plist
```

### Podman

#### Machine won't start
```bash
# Check machine status
podman machine info

# Remove and recreate
podman machine rm
podman machine init --cpus 4 --memory 8192 --rootful
podman machine start
```

#### "docker" command not found (Podman stack)
```bash
# Install Docker CLI compatibility shim
brew install podman-docker

# Verify
docker --version  # Should show "podman version ..."
```

#### Podman Desktop won't connect
```bash
# Ensure machine is running
podman machine start

# Verify socket
podman info
```

#### Auto-start not working
```bash
# Check launchd agent
launchctl list | grep podman

# Reload agent
launchctl unload ~/Library/LaunchAgents/com.kodra.podman.plist
launchctl load ~/Library/LaunchAgents/com.kodra.podman.plist
```

### Ghostty

#### Font not rendering correctly
```bash
# Verify Nerd Font installed
fc-list | grep -i "JetBrainsMono Nerd"

# Reinstall font
brew install --cask font-jetbrains-mono-nerd-font
```

#### Config not loading
```bash
# Verify config exists
cat ~/.config/ghostty/config

# Restart Ghostty completely (Cmd+Q, reopen)
```

### Starship

#### Prompt not showing
```bash
# Check if starship is installed
command -v starship

# Verify .zshrc has init
grep starship ~/.zshrc

# Manually add if missing
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
```

### Azure CLI

#### Login issues
```bash
# Clear cached credentials
az account clear

# Re-login
az login

# Use device code flow if browser auth fails
az login --use-device-code
```

### PowerShell

#### "pwsh" not found after install
```bash
# PowerShell .pkg installs to /usr/local/bin
ls -la /usr/local/bin/pwsh

# May need to add to PATH
export PATH="/usr/local/bin:$PATH"
```

## Shell Configuration

### zshrc conflicts
**Problem**: Custom `.zshrc` conflicts with Kodra config.

**Fix**: Kodra sources `~/.config/kodra/shell.zsh` from `.zshrc`. You can:
1. Edit `~/.config/kodra/shell.zsh` to customize Kodra's config
2. Add your own config after the Kodra source line in `.zshrc`
3. Remove the Kodra source line if you want to manage config yourself

### Aliases override my existing ones
The Kodra shell config sets aliases like `ls`, `cat`, `grep`. To override:
```bash
# Add AFTER the Kodra source line in ~/.zshrc
alias ls='ls -G'  # Override back to default
```

## General

### How to check system health
```bash
kodra doctor
```

### How to see what was installed
```bash
cat ~/.local/state/kodra/state.json | python3 -m json.tool
```

### How to completely reset
```bash
# Uninstall everything
~/.kodra/uninstall.sh

# Remove all Kodra state
rm -rf ~/.config/kodra ~/.local/state/kodra

# Reinstall
curl -fsSL https://kodra.macos.codetocloud.io/boot.sh | bash
```

### Getting help
- Run `kodra help` for CLI commands
- Check [FAQ.md](FAQ.md) for common questions
- Open a [GitHub Issue](https://github.com/codetocloudorg/kodra-macos/issues)
- Join [Discord](https://discord.gg/vwfwq2EpXJ)
