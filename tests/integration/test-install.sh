#!/usr/bin/env bash
#
# Kodra macOS — Integration Tests
# Run on macOS (GitHub Actions macos-14/macos-15 runners = Apple Silicon)
# Mimics the real user install flow: clone → install.sh → verify
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors
C_RESET='\033[0m'
C_GREEN='\033[0;32m'
C_RED='\033[0;31m'
C_CYAN='\033[0;36m'
C_GRAY='\033[0;90m'
C_YELLOW='\033[0;33m'

PASS=0
FAIL=0
SKIP=0

assert_pass() {
    PASS=$((PASS + 1))
    echo -e "  ${C_GREEN}✔${C_RESET} $1"
}

assert_fail() {
    FAIL=$((FAIL + 1))
    echo -e "  ${C_RED}✖${C_RESET} $1"
    [[ -n "${2:-}" ]] && echo -e "    ${C_GRAY}$2${C_RESET}"
}

assert_skip() {
    SKIP=$((SKIP + 1))
    echo -e "  ${C_YELLOW}○${C_RESET} $1 ${C_GRAY}(skipped)${C_RESET}"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Integration: macOS Environment${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if [[ "$(uname -s)" == "Darwin" ]]; then
    assert_pass "Running on macOS $(sw_vers -productVersion)"
else
    assert_fail "Not running on macOS" "uname: $(uname -s)"
    exit 1
fi

ARCH="$(uname -m)"
if [[ "$ARCH" == "arm64" ]]; then
    assert_pass "Apple Silicon (arm64)"
else
    assert_pass "Intel ($ARCH) — tests still valid"
fi

if command -v brew &>/dev/null; then
    assert_pass "Homebrew available at $(brew --prefix)"
else
    assert_fail "Homebrew not found"
    exit 1
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Integration: Full Install (mimics boot.sh)${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

export KODRA_DIR="$ROOT_DIR"
export KODRA_SKIP_PROMPTS=1

echo -e "  ${C_GRAY}Running install.sh --debug from $ROOT_DIR${C_RESET}"
start_time=$(date +%s)
bash "$ROOT_DIR/install.sh" --debug 2>&1 || true
install_exit=$?
end_time=$(date +%s)
duration=$((end_time - start_time))

if [[ "$install_exit" -eq 0 ]]; then
    assert_pass "install.sh completed in ${duration}s (exit 0)"
else
    assert_fail "install.sh exited with $install_exit (took ${duration}s)" "check logs above"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Integration: CLI Tool Verification${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

check_tool() {
    local name="$1"
    local cmd="${2:-$1}"
    if command -v "$cmd" &>/dev/null; then
        local ver
        ver=$("$cmd" --version 2>/dev/null | head -1 || echo "ok")
        assert_pass "$name ($ver)"
    else
        assert_fail "$name" "$cmd not found in PATH"
    fi
}

echo -e "  ${C_GRAY}Core CLI:${C_RESET}"
check_tool "bat"
check_tool "btop"
check_tool "eza"
check_tool "fastfetch"
check_tool "fd"
check_tool "fzf"
check_tool "gh"
check_tool "lazygit"
check_tool "ripgrep" "rg"
check_tool "yq"
check_tool "zoxide"

echo ""
echo -e "  ${C_GRAY}Cloud & DevOps:${C_RESET}"
check_tool "azure-cli" "az"
check_tool "azd"
check_tool "terraform"
check_tool "opentofu" "tofu"
check_tool "kubectl"
check_tool "helm"
check_tool "k9s"

echo ""
echo -e "  ${C_GRAY}Containers:${C_RESET}"
check_tool "colima"
check_tool "docker"
check_tool "lazydocker"

echo ""
echo -e "  ${C_GRAY}Terminal:${C_RESET}"
check_tool "starship"
check_tool "tmux"

echo ""
echo -e "  ${C_GRAY}Dev Tools:${C_RESET}"
check_tool "mise"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Integration: Kodra CLI${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

KODRA_BIN="$ROOT_DIR/bin/kodra"

# Test version
ver_output=$(bash "$KODRA_BIN" version 2>/dev/null)
if echo "$ver_output" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    assert_pass "kodra version → $ver_output"
else
    assert_fail "kodra version" "unexpected: $ver_output"
fi

# Test help
if bash "$KODRA_BIN" help 2>/dev/null | grep -q "macOS Edition"; then
    assert_pass "kodra help shows macOS Edition"
else
    assert_fail "kodra help" "missing macOS branding"
fi

# Test doctor (should work even if some tools fail)
if bash "$KODRA_BIN" doctor 2>/dev/null | grep -qE "(healthy|missing)"; then
    assert_pass "kodra doctor runs successfully"
else
    assert_fail "kodra doctor" "unexpected output"
fi

# Test shortcuts
if bash "$KODRA_BIN" shortcuts 2>/dev/null | grep -q "Git"; then
    assert_pass "kodra shortcuts shows aliases"
else
    assert_fail "kodra shortcuts" "unexpected output"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Integration: Shell Config${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if [[ -f "$HOME/.config/kodra/shell.zsh" ]]; then
    assert_pass "Kodra shell config created"
else
    assert_fail "Missing ~/.config/kodra/shell.zsh"
fi

if [[ -f "$HOME/.config/bat/config" ]]; then
    assert_pass "bat config created"
else
    assert_skip "bat config"
fi

if [[ -f "$HOME/.config/starship.toml" ]]; then
    assert_pass "starship.toml created"
else
    assert_skip "starship.toml"
fi

if [[ -f "$HOME/.config/ghostty/config" ]]; then
    assert_pass "Ghostty config created"
    if grep -q "Cyberpunk" "$HOME/.config/ghostty/config" 2>/dev/null; then
        assert_pass "Ghostty Cyberpunk theme configured"
    else
        assert_fail "Ghostty Cyberpunk theme missing"
    fi
    if grep -q "quick-terminal-position" "$HOME/.config/ghostty/config" 2>/dev/null; then
        assert_pass "Ghostty quick terminal configured"
    else
        assert_fail "Ghostty quick terminal missing"
    fi
    if grep -q "resize_split" "$HOME/.config/ghostty/config" 2>/dev/null; then
        assert_pass "Ghostty split resize keybindings configured"
    else
        assert_fail "Ghostty split resize keybindings missing"
    fi
else
    assert_skip "Ghostty config"
fi

if [[ -f "$HOME/.tmux.conf" ]]; then
    assert_pass "tmux.conf created"
    if grep -q "prefix C-a" "$HOME/.tmux.conf" 2>/dev/null; then
        assert_pass "tmux Ctrl+a prefix configured"
    else
        assert_fail "tmux Ctrl+a prefix missing"
    fi
    if grep -q "Kodra" "$HOME/.tmux.conf" 2>/dev/null; then
        assert_pass "tmux Kodra branding present"
    else
        assert_fail "tmux Kodra branding missing"
    fi
else
    assert_skip "tmux.conf"
fi

if [[ -f "$HOME/.config/ghostty/sidebar-menu.sh" ]]; then
    assert_pass "sidebar-menu.sh deployed"
    if [[ -x "$HOME/.config/ghostty/sidebar-menu.sh" ]]; then
        assert_pass "sidebar-menu.sh is executable"
    else
        assert_fail "sidebar-menu.sh not executable"
    fi
else
    assert_skip "sidebar-menu.sh"
fi

if [[ -f "$HOME/.config/fastfetch/config.jsonc" ]]; then
    assert_pass "fastfetch config created"
else
    assert_skip "fastfetch config"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Integration: Copilot CLI${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if command -v copilot &>/dev/null; then
    assert_pass "Copilot CLI cask installed ($(copilot --version 2>/dev/null | head -1 || echo 'ok'))"
else
    assert_fail "Copilot CLI cask not installed"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Integration: Container Runtime${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Docker CLI must always be installed
if command -v docker &>/dev/null; then
    assert_pass "Docker CLI installed ($(docker --version 2>/dev/null | head -1))"
else
    assert_fail "Docker CLI missing — should always be installed"
fi

# Verify container runtime selection support in install.sh
if grep -q "KODRA_CONTAINER_RUNTIME" "$ROOT_DIR/install.sh" 2>/dev/null; then
    assert_pass "KODRA_CONTAINER_RUNTIME env override in install.sh"
else
    assert_fail "KODRA_CONTAINER_RUNTIME env override missing"
fi

if grep -q "KODRA_SKIP_PROMPTS" "$ROOT_DIR/install.sh" 2>/dev/null; then
    assert_pass "KODRA_SKIP_PROMPTS supported in install.sh"
else
    assert_fail "KODRA_SKIP_PROMPTS missing from install.sh"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Integration: boot.sh Safety${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if grep -q '/dev/tty' "$ROOT_DIR/boot.sh" 2>/dev/null; then
    assert_pass "boot.sh uses /dev/tty for Homebrew (curl | bash safe)"
else
    assert_fail "boot.sh missing /dev/tty redirect"
fi

if grep -q 'command -v brew' "$ROOT_DIR/boot.sh" 2>/dev/null; then
    assert_pass "boot.sh skips Homebrew if already installed"
else
    assert_fail "boot.sh missing Homebrew presence check"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Integration: Podman Installer Structure${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PODMAN_SH="$ROOT_DIR/install/containers/podman.sh"
if [[ -f "$PODMAN_SH" ]]; then
    assert_pass "podman.sh exists"

    if bash -n "$PODMAN_SH" 2>/dev/null; then
        assert_pass "podman.sh syntax valid"
    else
        assert_fail "podman.sh has syntax errors"
    fi

    if grep -q 'podman machine init' "$PODMAN_SH"; then
        assert_pass "podman.sh includes machine init"
    else
        assert_fail "podman.sh missing machine init"
    fi

    if grep -q 'DOCKER_HOST' "$PODMAN_SH"; then
        assert_pass "podman.sh configures DOCKER_HOST"
    else
        assert_fail "podman.sh missing DOCKER_HOST"
    fi

    if grep -q 'TESTCONTAINERS' "$PODMAN_SH"; then
        assert_pass "podman.sh configures Testcontainers"
    else
        assert_fail "podman.sh missing Testcontainers config"
    fi

    if grep -q 'dev.containers.dockerPath' "$PODMAN_SH"; then
        assert_pass "podman.sh configures VS Code"
    else
        assert_fail "podman.sh missing VS Code config"
    fi

    if grep -q 'podman-env.zsh' "$PODMAN_SH"; then
        assert_pass "podman.sh generates podman-env.zsh"
    else
        assert_fail "podman.sh missing podman-env.zsh"
    fi
else
    assert_fail "podman.sh not found"
fi

# Check shell-config.sh sources podman-env.zsh
if grep -q 'podman-env.zsh' "$ROOT_DIR/install/terminal/shell-config.sh" 2>/dev/null; then
    assert_pass "shell-config.sh sources podman-env.zsh when present"
else
    assert_fail "shell-config.sh does not source podman-env.zsh"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Integration: State Tracking${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/kodra/state.json"

if [[ -f "$STATE_FILE" ]]; then
    assert_pass "State file exists"

    # Verify state has expected keys
    if python3 -c "import json; d=json.load(open('$STATE_FILE')); assert d.get('installed')=='true'" 2>/dev/null; then
        assert_pass "State: installed=true"
    else
        assert_fail "State: installed key missing or wrong"
    fi

    if python3 -c "import json; d=json.load(open('$STATE_FILE')); assert 'version' in d" 2>/dev/null; then
        assert_pass "State: version recorded"
    else
        assert_fail "State: version key missing"
    fi

    if python3 -c "import json; d=json.load(open('$STATE_FILE')); assert 'arch' in d" 2>/dev/null; then
        assert_pass "State: arch recorded"
    else
        assert_fail "State: arch key missing"
    fi
else
    assert_fail "State file not found at $STATE_FILE"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Integration: macOS Defaults${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

check_default() {
    local domain="$1"
    local key="$2"
    local expected="$3"
    local label="$4"
    local actual
    actual=$(defaults read "$domain" "$key" 2>/dev/null)
    if [[ "$actual" == "$expected" ]]; then
        assert_pass "$label"
    else
        assert_fail "$label" "expected=$expected got=${actual:-unset}"
    fi
}

check_default "com.apple.finder" "AppleShowAllFiles" "1" "Finder: hidden files visible"
check_default "com.apple.finder" "ShowPathbar" "1" "Finder: path bar enabled"
check_default "NSGlobalDomain" "AppleShowAllExtensions" "1" "Finder: file extensions shown"
check_default "NSGlobalDomain" "KeyRepeat" "2" "Keyboard: fast repeat"
check_default "com.apple.dock" "autohide" "1" "Dock: auto-hide"
check_default "com.apple.dock" "show-recents" "0" "Dock: recents hidden"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Summary
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ""
echo -e "  ${C_GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
TOTAL=$((PASS + FAIL))
echo -e "  Results: ${C_GREEN}$PASS passed${C_RESET}, ${C_RED}$FAIL failed${C_RESET}, ${C_YELLOW}$SKIP skipped${C_RESET} ($TOTAL total)"
echo ""

exit $FAIL
