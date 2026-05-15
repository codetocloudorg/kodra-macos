#!/usr/bin/env bash
# Kodra macOS — Install Podman (container runtime alternative to Docker)
# Podman is a daemonless container engine — no Docker Desktop license required
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_install podman

# Install podman-compose for docker-compose compatibility
brew_install podman-compose

# Initialize the Podman machine if not already created
if ! podman machine info &>/dev/null 2>&1; then
    log_debug "Initializing Podman machine for Apple Silicon..."
    podman machine init --cpus 4 --memory 8192 --rootful 2>/dev/null || {
        log_debug "Podman machine init skipped (may already exist)"
    }
fi

# Configure Podman machine to auto-start (launchd)
mkdir -p "$HOME/Library/LaunchAgents"
cat > "$HOME/Library/LaunchAgents/com.kodra.podman.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.kodra.podman</string>
    <key>ProgramArguments</key>
    <array>
        <string>$(brew --prefix)/bin/podman</string>
        <string>machine</string>
        <string>start</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
</dict>
</plist>
EOF

log_debug "Podman launchd plist created (auto-start on login)"

# Install Podman Desktop (GUI for managing containers, images, pods)
brew_cask_install podman-desktop

# Optional: set up Docker CLI compatibility via podman-docker
if ! has_command docker; then
    brew_install podman-docker
    log_debug "podman-docker installed (docker CLI alias)"
fi
