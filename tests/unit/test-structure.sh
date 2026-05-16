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
echo -e "\n${C_CYAN}▶ Test Suite: Version Consistency${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# VERSION file must exist and contain a valid semver
if [[ -f "$ROOT_DIR/VERSION" ]]; then
    VERSION_VALUE="$(cat "$ROOT_DIR/VERSION" | tr -d '[:space:]')"
    if [[ "$VERSION_VALUE" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        assert_pass "version: VERSION file is valid semver ($VERSION_VALUE)"
    else
        assert_fail "version: VERSION file is not valid semver" "$VERSION_VALUE"
    fi
else
    assert_fail "version: VERSION file missing"
fi

# README badge must reference current version
if [[ -f "$ROOT_DIR/README.md" ]] && [[ -n "${VERSION_VALUE:-}" ]]; then
    if grep -q "$VERSION_VALUE" "$ROOT_DIR/README.md" 2>/dev/null; then
        assert_pass "version: README.md references $VERSION_VALUE"
    else
        assert_fail "version: README.md does not reference $VERSION_VALUE"
    fi
fi

# CHANGELOG must reference current version
if [[ -f "$ROOT_DIR/CHANGELOG.md" ]] && [[ -n "${VERSION_VALUE:-}" ]]; then
    if grep -q "$VERSION_VALUE" "$ROOT_DIR/CHANGELOG.md" 2>/dev/null; then
        assert_pass "version: CHANGELOG.md references $VERSION_VALUE"
    else
        assert_fail "version: CHANGELOG.md does not reference $VERSION_VALUE"
    fi
fi

# llms.txt must reference current version
if [[ -f "$ROOT_DIR/llms-full.txt" ]] && [[ -n "${VERSION_VALUE:-}" ]]; then
    if grep -q "$VERSION_VALUE" "$ROOT_DIR/llms-full.txt" 2>/dev/null; then
        assert_pass "version: llms-full.txt references $VERSION_VALUE"
    else
        assert_fail "version: llms-full.txt does not reference $VERSION_VALUE"
    fi
fi

# bin/kodra must be able to show version
if [[ -x "$ROOT_DIR/bin/kodra" ]]; then
    CLI_VER="$(KODRA_DIR="$ROOT_DIR" bash "$ROOT_DIR/bin/kodra" version 2>/dev/null | tr -d '[:space:]')"
    if [[ "$CLI_VER" == "${VERSION_VALUE:-}" ]]; then
        assert_pass "version: kodra CLI reports $CLI_VER"
    else
        assert_fail "version: kodra CLI reports '$CLI_VER' but VERSION file says '${VERSION_VALUE:-}'"
    fi
fi

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
    "uninstall/opentofu.sh"
    "uninstall/bicep.sh"
    "uninstall/copilot-cli.sh"
    "uninstall/azd.sh"
    "uninstall/bat.sh"
    "uninstall/btop.sh"
    "uninstall/eza.sh"
    "uninstall/fd.sh"
    "uninstall/fzf.sh"
    "uninstall/ripgrep.sh"
    "uninstall/yq.sh"
    "uninstall/zoxide.sh"
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
echo -e "\n${C_CYAN}▶ Test Suite: HTTPS URLs${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# All user-facing URLs must use HTTPS
http_violations=$(grep -rn "http://kodra\." "$ROOT_DIR/boot.sh" "$ROOT_DIR/install.sh" "$ROOT_DIR/bin/kodra" "$ROOT_DIR/README.md" 2>/dev/null || true)
if [[ -z "$http_violations" ]]; then
    assert_pass "https: all kodra URLs use HTTPS"
else
    assert_fail "https: found http:// URLs (should be https://)" "$http_violations"
fi

# Site files exist
for site_file in llms.txt llms-full.txt robots.txt sitemap.xml index.html 404.html CNAME manifest.json; do
    if [[ -f "$ROOT_DIR/$site_file" ]]; then
        assert_pass "site: $site_file exists"
    else
        assert_fail "site: $site_file missing"
    fi
done

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: CLI Command Parity${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

cli_file="$ROOT_DIR/bin/kodra"
for cmd in doctor update cleanup repair setup install uninstall dev extensions fetch defaults refresh shortcuts backup restore migrate menu welcome version help resume motd banner db database ci; do
    if grep -q "${cmd}" "$cli_file" 2>/dev/null; then
        assert_pass "cli-cmd: $cmd"
    else
        assert_fail "cli-cmd: $cmd not in CLI"
    fi
done

# Command aliases
if grep -qE "remove\)" "$cli_file" 2>/dev/null; then
    assert_pass "cli-alias: uninstall|remove"
else
    assert_fail "cli-alias: uninstall|remove not in CLI"
fi

if grep -qE "alias|aliases" "$cli_file" 2>/dev/null; then
    assert_pass "cli-alias: shortcuts|aliases"
else
    assert_fail "cli-alias: shortcuts|aliases not in CLI"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: State Resume Infrastructure${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

STATE_FUNCS=("mark_step_complete" "is_step_complete" "mark_step_failed" "get_failed_steps" "get_pending_steps" "get_resume_point" "clear_state" "show_state_summary" "get_install_progress" "can_resume")
for fn in "${STATE_FUNCS[@]}"; do
    if grep -q "$fn" "$ROOT_DIR/lib/state.sh" 2>/dev/null; then
        assert_pass "state-fn: $fn"
    else
        assert_fail "state-fn: $fn missing from lib/state.sh"
    fi
done

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Enhanced Checks${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CHECK_FUNCS=("check_internet" "check_memory" "check_shell" "check_dns" "run_all_checks" "show_checks_summary")
for fn in "${CHECK_FUNCS[@]}"; do
    if grep -q "$fn" "$ROOT_DIR/lib/checks.sh" 2>/dev/null; then
        assert_pass "checks-fn: $fn"
    else
        assert_fail "checks-fn: $fn missing from lib/checks.sh"
    fi
done

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: File Logging${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

LOG_FUNCS=("init_log" "_rotate_logs" "_write_log")
for fn in "${LOG_FUNCS[@]}"; do
    if grep -q "$fn" "$ROOT_DIR/lib/logging.sh" 2>/dev/null; then
        assert_pass "logging-fn: $fn"
    else
        assert_fail "logging-fn: $fn missing from lib/logging.sh"
    fi
done

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Granular Backup/Restore${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

BACKUP_FUNCS=("backup_dotfiles" "backup_shell_config" "backup_tool_configs" "restore_dotfiles" "restore_shell_config" "restore_tool_configs")
for fn in "${BACKUP_FUNCS[@]}"; do
    if grep -q "$fn" "$ROOT_DIR/lib/backup.sh" 2>/dev/null; then
        assert_pass "backup-fn: $fn"
    else
        assert_fail "backup-fn: $fn missing from lib/backup.sh"
    fi
done

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Extended Utilities${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

UTIL_FUNCS=("check_internet_connection" "elapsed_time" "cleanup_on_exit" "ensure_dir" "log_to_file" "get_kodra_version")
for fn in "${UTIL_FUNCS[@]}"; do
    if grep -q "$fn" "$ROOT_DIR/lib/utils.sh" 2>/dev/null; then
        assert_pass "utils-fn: $fn"
    else
        assert_fail "utils-fn: $fn missing from lib/utils.sh"
    fi
done

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Logging Available in Installer Subshells${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Verify that sourcing utils.sh in a fresh subshell makes all logging functions available
# This mimics what happens when run_installer spawns 'bash <installer>.sh'
SUBSHELL_FUNCS=("log_info" "log_success" "log_warn" "log_error" "log_debug" "log_section")
for fn in "${SUBSHELL_FUNCS[@]}"; do
    if bash -c "source '$ROOT_DIR/lib/utils.sh' && type $fn" &>/dev/null; then
        assert_pass "subshell-logging: $fn available via utils.sh"
    else
        assert_fail "subshell-logging: $fn NOT available via utils.sh"
    fi
done

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: boot.sh TTY Handling${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Verify boot.sh uses /dev/tty redirect for Homebrew install (curl | bash support)
if grep -q '/dev/tty' "$ROOT_DIR/boot.sh" 2>/dev/null; then
    assert_pass "boot-tty: /dev/tty redirect present for Homebrew install"
else
    assert_fail "boot-tty: /dev/tty redirect missing (curl | bash will fail)"
fi

# Verify boot.sh provides fallback message when /dev/tty unavailable
if grep -q 'interactive terminal' "$ROOT_DIR/boot.sh" 2>/dev/null; then
    assert_pass "boot-tty: fallback message for non-TTY environments"
else
    assert_fail "boot-tty: fallback message missing"
fi

# Verify boot.sh skips Homebrew install when already present
if grep -q 'command -v brew' "$ROOT_DIR/boot.sh" 2>/dev/null; then
    assert_pass "boot-tty: skips Homebrew if already installed"
else
    assert_fail "boot-tty: missing Homebrew presence check"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Container Runtime Selection${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Verify install.sh supports both Docker and Podman paths
if grep -q 'CONTAINER_RUNTIME' "$ROOT_DIR/install.sh" 2>/dev/null; then
    assert_pass "container-runtime: CONTAINER_RUNTIME variable used"
else
    assert_fail "container-runtime: CONTAINER_RUNTIME variable missing"
fi

if grep -q 'KODRA_CONTAINER_RUNTIME' "$ROOT_DIR/install.sh" 2>/dev/null; then
    assert_pass "container-runtime: KODRA_CONTAINER_RUNTIME env override supported"
else
    assert_fail "container-runtime: KODRA_CONTAINER_RUNTIME env override missing"
fi

# Verify Docker CLI is installed regardless of runtime choice
if grep -q 'docker-cli.sh' "$ROOT_DIR/install.sh" 2>/dev/null; then
    assert_pass "container-runtime: docker-cli.sh always installed"
else
    assert_fail "container-runtime: docker-cli.sh missing from install"
fi

# Verify interactive prompts read from /dev/tty
if grep -q '< /dev/tty' "$ROOT_DIR/install.sh" 2>/dev/null; then
    assert_pass "container-runtime: prompts read from /dev/tty for piped installs"
else
    assert_fail "container-runtime: /dev/tty redirect missing from prompts"
fi

# Verify KODRA_SKIP_PROMPTS is respected
if grep -q 'KODRA_SKIP_PROMPTS' "$ROOT_DIR/install.sh" 2>/dev/null; then
    assert_pass "container-runtime: KODRA_SKIP_PROMPTS supported for CI"
else
    assert_fail "container-runtime: KODRA_SKIP_PROMPTS missing"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Podman Installer${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Verify podman.sh installs krunkit (required on Apple Silicon)
if grep -q 'krunkit' "$ROOT_DIR/install/containers/podman.sh" 2>/dev/null; then
    assert_pass "podman: krunkit dependency included"
else
    assert_fail "podman: krunkit dependency missing (Apple Silicon will fail)"
fi

# Verify podman.sh sets up DOCKER_HOST environment
if grep -q 'DOCKER_HOST' "$ROOT_DIR/install/containers/podman.sh" 2>/dev/null; then
    assert_pass "podman: DOCKER_HOST configured for Podman socket"
else
    assert_fail "podman: DOCKER_HOST not configured"
fi

# Verify podman.sh configures VS Code
if grep -q 'dev.containers.dockerPath' "$ROOT_DIR/install/containers/podman.sh" 2>/dev/null; then
    assert_pass "podman: VS Code Dev Containers configured for Podman"
else
    assert_fail "podman: VS Code Dev Containers not configured"
fi

# Verify podman.sh sets up Testcontainers support
if grep -q 'TESTCONTAINERS' "$ROOT_DIR/install/containers/podman.sh" 2>/dev/null; then
    assert_pass "podman: Testcontainers environment configured"
else
    assert_fail "podman: Testcontainers environment missing"
fi

# Verify podman.sh creates podman-env.zsh for shell sourcing
if grep -q 'podman-env.zsh' "$ROOT_DIR/install/containers/podman.sh" 2>/dev/null; then
    assert_pass "podman: podman-env.zsh shell config created"
else
    assert_fail "podman: podman-env.zsh shell config missing"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Shell Config Container Awareness${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Verify shell-config.sh sources podman-env.zsh when present
if grep -q 'podman-env.zsh' "$ROOT_DIR/install/terminal/shell-config.sh" 2>/dev/null; then
    assert_pass "shell-config: sources podman-env.zsh when present"
else
    assert_fail "shell-config: does not source podman-env.zsh"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Copilot CLI Installer${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Verify copilot-cli.sh installs the standalone cask
if grep -q 'brew_cask_install copilot-cli' "$ROOT_DIR/install/cli-tools/copilot-cli.sh" 2>/dev/null; then
    assert_pass "copilot-cli: standalone cask installed (brew install --cask copilot-cli)"
else
    assert_fail "copilot-cli: standalone cask missing"
fi

# Verify copilot-cli.sh also installs gh extension
if grep -q 'gh extension install' "$ROOT_DIR/install/cli-tools/copilot-cli.sh" 2>/dev/null; then
    assert_pass "copilot-cli: gh-copilot extension installed"
else
    assert_fail "copilot-cli: gh-copilot extension missing"
fi

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
echo -e "\n${C_CYAN}▶ Test Suite: Dependabot${C_RESET}\n"
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

if [[ -f "$ROOT_DIR/.github/dependabot.yml" ]]; then
    assert_pass "dependabot: .github/dependabot.yml exists"
    if grep -q "github-actions" "$ROOT_DIR/.github/dependabot.yml" 2>/dev/null; then
        assert_pass "dependabot: github-actions ecosystem configured"
    else
        assert_fail "dependabot: github-actions ecosystem missing"
    fi
else
    assert_fail "dependabot: .github/dependabot.yml missing"
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
