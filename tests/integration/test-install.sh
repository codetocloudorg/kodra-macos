#!/usr/bin/env bash
#
# Kodra macOS — Integration Tests
# Run on macOS (GitHub Actions macos-14/macos-15 runners = Apple Silicon)
# Validates actual tool installation via Homebrew
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

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

# Verify we're on macOS
if [[ "$(uname -s)" == "Darwin" ]]; then
    assert_pass "Running on macOS $(sw_vers -productVersion)"
else
    assert_fail "Not running on macOS" "uname: $(uname -s)"
    exit 1
fi

# Check architecture
ARCH="$(uname -m)"
if [[ "$ARCH" == "arm64" ]]; then
    assert_pass "Apple Silicon (arm64)"
else
    assert_pass "Intel ($ARCH) — tests still valid"
fi

# Check Homebrew
if command -v brew &>/dev/null; then
    assert_pass "Homebrew available at $(which brew)"
else
    assert_fail "Homebrew not found"
    exit 1
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Integration: CLI Tool Installation${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

test_brew_install() {
    local name="$1"
    local script="$ROOT_DIR/install/cli-tools/${name}.sh"

    if [[ ! -f "$script" ]]; then
        assert_skip "$name (no installer script)"
        return
    fi

    bash "$script" 2>/dev/null
    if command -v "$name" &>/dev/null; then
        assert_pass "$name installed successfully"
    elif brew list "$name" &>/dev/null; then
        assert_pass "$name installed (brew list confirms)"
    else
        assert_fail "$name installation failed"
    fi
}

# Test a subset of fast-installing tools
test_brew_install "bat"
test_brew_install "eza"
test_brew_install "fd"
test_brew_install "fzf"
test_brew_install "ripgrep"
test_brew_install "yq"
test_brew_install "zoxide"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Integration: Cloud Tools${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

test_cloud_tool() {
    local name="$1"
    local cmd="${2:-$1}"
    local script="$ROOT_DIR/install/cloud/${name}.sh"

    if [[ ! -f "$script" ]]; then
        assert_skip "$name (no installer)"
        return
    fi

    bash "$script" 2>/dev/null
    if command -v "$cmd" &>/dev/null; then
        assert_pass "$name → $cmd available"
    else
        assert_fail "$name → $cmd not found after install"
    fi
}

test_cloud_tool "kubectl"
test_cloud_tool "helm"
test_cloud_tool "k9s"
test_cloud_tool "opentofu" "tofu"

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Integration: Kodra CLI${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Test kodra CLI responds
export KODRA_DIR="$ROOT_DIR"
KODRA_BIN="$ROOT_DIR/bin/kodra"

if bash "$KODRA_BIN" version 2>/dev/null | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    assert_pass "kodra version outputs semver"
else
    assert_fail "kodra version" "unexpected output"
fi

if bash "$KODRA_BIN" help 2>/dev/null | grep -q "macOS Edition"; then
    assert_pass "kodra help shows macOS Edition"
else
    assert_fail "kodra help" "missing macOS branding"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Integration: Desktop Defaults (dry-run validation)${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Verify defaults scripts have valid syntax (don't actually apply in CI)
for script in "$ROOT_DIR"/install/desktop/*.sh; do
    if bash -n "$script" 2>/dev/null; then
        assert_pass "desktop syntax: $(basename "$script")"
    else
        assert_fail "desktop syntax: $(basename "$script")"
    fi
done

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Summary
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ""
echo -e "  ${C_GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
TOTAL=$((PASS + FAIL))
echo -e "  Results: ${C_GREEN}$PASS passed${C_RESET}, ${C_RED}$FAIL failed${C_RESET}, ${C_YELLOW}$SKIP skipped${C_RESET} ($TOTAL total)"
echo ""

exit $FAIL
