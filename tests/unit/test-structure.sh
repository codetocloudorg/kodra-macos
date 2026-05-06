#!/usr/bin/env bash
#
# Kodra macOS — Unit Tests
# Validates script syntax, library functions, and installer structure
#

set +e  # We track failures manually

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Colors
C_RESET='\033[0m'
C_GREEN='\033[0;32m'
C_RED='\033[0;31m'
C_CYAN='\033[0;36m'
C_GRAY='\033[0;90m'

PASS=0
FAIL=0

assert_pass() {
    local desc="$1"
    PASS=$((PASS + 1))
    echo -e "  ${C_GREEN}✔${C_RESET} $desc"
}

assert_fail() {
    local desc="$1"
    local detail="${2:-}"
    FAIL=$((FAIL + 1))
    echo -e "  ${C_RED}✖${C_RESET} $desc"
    [[ -n "$detail" ]] && echo -e "    ${C_GRAY}$detail${C_RESET}"
}

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Shell Script Syntax${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SYNTAX_ERRORS=0
while IFS= read -r script; do
    if bash -n "$script" 2>/dev/null; then
        assert_pass "syntax: $(basename "$script")"
    else
        assert_fail "syntax: $(basename "$script")" "bash -n failed"
        SYNTAX_ERRORS=$((SYNTAX_ERRORS + 1))
    fi
done < <(find "$ROOT_DIR" -name "*.sh" -not -path "*/.git/*" -not -path "*/node_modules/*")

# Also check bin/kodra
if bash -n "$ROOT_DIR/bin/kodra" 2>/dev/null; then
    assert_pass "syntax: bin/kodra"
else
    assert_fail "syntax: bin/kodra"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Required Files Exist${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

REQUIRED_FILES=(
    "boot.sh"
    "install.sh"
    "uninstall.sh"
    "VERSION"
    "LICENSE"
    "README.md"
    "bin/kodra"
    "lib/logging.sh"
    "lib/utils.sh"
    "lib/checks.sh"
    "lib/state.sh"
)

for f in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$ROOT_DIR/$f" ]]; then
        assert_pass "exists: $f"
    else
        assert_fail "exists: $f" "file missing"
    fi
done

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Installer Structure${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

INSTALL_DIRS=(
    "install/cli-tools"
    "install/cloud"
    "install/containers"
    "install/dev-tools"
    "install/terminal"
    "install/desktop"
)

for d in "${INSTALL_DIRS[@]}"; do
    if [[ -d "$ROOT_DIR/$d" ]]; then
        count=$(find "$ROOT_DIR/$d" -name "*.sh" | wc -l | tr -d ' ')
        if [[ "$count" -gt 0 ]]; then
            assert_pass "installers: $d ($count scripts)"
        else
            assert_fail "installers: $d" "directory empty"
        fi
    else
        assert_fail "installers: $d" "directory missing"
    fi
done

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Installer Scripts Source lib/utils.sh${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

while IFS= read -r script; do
    if grep -q "lib/utils.sh" "$script" 2>/dev/null; then
        assert_pass "sources utils: $(basename "$script")"
    else
        assert_fail "sources utils: $(basename "$script")" "does not source lib/utils.sh"
    fi
done < <(find "$ROOT_DIR/install" -name "*.sh" -not -name "shell-config.sh")

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: No Hardcoded x86_64 Paths${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Ensure no script assumes /usr/local (Intel Homebrew path)
INTEL_REFS=0
while IFS= read -r script; do
    if grep -q "/usr/local/bin/brew" "$script" 2>/dev/null && ! grep -q "/opt/homebrew" "$script" 2>/dev/null; then
        assert_fail "arch-safe: $(basename "$script")" "only references /usr/local (Intel)"
        INTEL_REFS=$((INTEL_REFS + 1))
    fi
done < <(find "$ROOT_DIR/install" -name "*.sh")

if [[ "$INTEL_REFS" -eq 0 ]]; then
    assert_pass "arch-safe: no Intel-only Homebrew paths"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: VERSION File${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

VERSION=$(cat "$ROOT_DIR/VERSION" | tr -d '[:space:]')
if [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    assert_pass "version: valid semver ($VERSION)"
else
    assert_fail "version: invalid format ($VERSION)" "expected X.Y.Z"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: No apt-get References (macOS only)${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

APT_REFS=$(grep -rl "apt-get\|apt " "$ROOT_DIR/install" "$ROOT_DIR/lib" "$ROOT_DIR/bin" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$APT_REFS" -eq 0 ]]; then
    assert_pass "no-apt: no apt-get/apt references in install scripts"
else
    assert_fail "no-apt: found $APT_REFS files referencing apt-get"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Library Files${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

LIB_FILES=(
    "lib/backup.sh"
    "lib/config.sh"
    "lib/ui.sh"
    "lib/package.sh"
)

for f in "${LIB_FILES[@]}"; do
    if [[ -f "$ROOT_DIR/$f" ]]; then
        if [[ -x "$ROOT_DIR/$f" ]]; then
            assert_pass "lib exists+exec: $f"
        else
            assert_pass "lib exists: $f (not executable — sourced only)"
        fi
    else
        assert_fail "lib exists: $f" "file missing"
    fi
done

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Uninstall Scripts${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

UNINSTALL_SCRIPTS=(
    "uninstall/azure-cli.sh"
    "uninstall/colima.sh"
    "uninstall/docker-cli.sh"
    "uninstall/ghostty.sh"
    "uninstall/github-cli.sh"
    "uninstall/helm.sh"
    "uninstall/k9s.sh"
    "uninstall/kubectl.sh"
    "uninstall/lazydocker.sh"
    "uninstall/lazygit.sh"
    "uninstall/mise.sh"
    "uninstall/powershell.sh"
    "uninstall/starship.sh"
    "uninstall/terraform.sh"
    "uninstall/vscode.sh"
)

for f in "${UNINSTALL_SCRIPTS[@]}"; do
    if [[ -f "$ROOT_DIR/$f" && -x "$ROOT_DIR/$f" ]]; then
        assert_pass "uninstall exists+exec: $(basename "$f")"
    elif [[ -f "$ROOT_DIR/$f" ]]; then
        assert_fail "uninstall exec: $(basename "$f")" "exists but not executable"
    else
        assert_fail "uninstall exists: $(basename "$f")" "file missing"
    fi
done

# Ensure uninstall scripts don't reference apt/dpkg (macOS only)
UNINSTALL_APT_REFS=$(grep -rl "apt-get\|apt \|dpkg" "$ROOT_DIR/uninstall" 2>/dev/null | wc -l | tr -d ' ')
if [[ "$UNINSTALL_APT_REFS" -eq 0 ]]; then
    assert_pass "no-apt: uninstall scripts use brew (not apt/dpkg)"
else
    assert_fail "no-apt: found $UNINSTALL_APT_REFS uninstall scripts referencing apt/dpkg"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Migrations${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if [[ -d "$ROOT_DIR/migrations" ]]; then
    migration_count=$(find "$ROOT_DIR/migrations" -name "*.sh" | wc -l | tr -d ' ')
    if [[ "$migration_count" -gt 0 ]]; then
        assert_pass "migrations: directory exists ($migration_count migration(s))"
    else
        assert_fail "migrations: directory exists but empty"
    fi
else
    assert_fail "migrations: directory missing"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Shell Completions${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if [[ -f "$ROOT_DIR/configs/completions/_kodra" ]]; then
    assert_pass "completions: _kodra (zsh) exists"
else
    assert_fail "completions: _kodra (zsh) missing"
fi

if [[ -f "$ROOT_DIR/configs/completions/kodra.bash" ]]; then
    assert_pass "completions: kodra.bash exists"
else
    assert_fail "completions: kodra.bash missing"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Summary
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo ""
echo -e "  ${C_GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
TOTAL=$((PASS + FAIL))
if [[ "$FAIL" -eq 0 ]]; then
    echo -e "  ${C_GREEN}✔ All $TOTAL tests passed${C_RESET}"
else
    echo -e "  ${C_RED}✖ $FAIL/$TOTAL tests failed${C_RESET}"
fi
echo ""

exit $FAIL
