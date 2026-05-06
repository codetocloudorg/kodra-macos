#!/usr/bin/env bash
# Kodra macOS — Install Colima (Docker runtime without Docker Desktop)
# Colima provides a lightweight Linux VM to run containers on macOS
# No Docker Desktop license required
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_install colima

# Start Colima with sensible defaults for Apple Silicon
if ! colima status &>/dev/null; then
    log_debug "Colima not running — will start on first 'docker' command"
fi

# Configure Colima to auto-start (launchd)
mkdir -p "$HOME/Library/LaunchAgents"
cat > "$HOME/Library/LaunchAgents/com.kodra.colima.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.kodra.colima</string>
    <key>ProgramArguments</key>
    <array>
        <string>$(brew --prefix)/bin/colima</string>
        <string>start</string>
        <string>--cpu</string>
        <string>4</string>
        <string>--memory</string>
        <string>8</string>
        <string>--arch</string>
        <string>aarch64</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
</dict>
</plist>
EOF

log_debug "Colima launchd plist created (auto-start on login)"
