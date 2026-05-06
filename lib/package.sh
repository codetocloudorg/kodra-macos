#!/usr/bin/env bash
#
# Kodra macOS — Package Management Abstraction
# Homebrew-based package management utilities
#

KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"

source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

# Install a Homebrew formula
pkg_install() {
    local formula="$1"

    if [[ -z "$formula" ]]; then
        log_error "Usage: pkg_install <formula>"
        return 1
    fi

    ensure_brew_path

    if brew list "$formula" &>/dev/null 2>&1; then
        log_debug "$formula already installed"
        return 0
    fi

    log_info "Installing ${formula}..."
    if brew install "$formula" 2>/dev/null; then
        log_success "${formula} installed"
    else
        log_error "Failed to install ${formula}"
        return 1
    fi
}

# Remove a Homebrew formula
pkg_remove() {
    local formula="$1"

    if [[ -z "$formula" ]]; then
        log_error "Usage: pkg_remove <formula>"
        return 1
    fi

    ensure_brew_path

    if ! brew list "$formula" &>/dev/null 2>&1; then
        log_debug "$formula not installed"
        return 0
    fi

    log_info "Removing ${formula}..."
    if brew uninstall "$formula" 2>/dev/null; then
        log_success "${formula} removed"
    else
        log_error "Failed to remove ${formula}"
        return 1
    fi
}

# Check if a Homebrew formula is installed
pkg_is_installed() {
    local formula="$1"
    ensure_brew_path
    brew list "$formula" &>/dev/null 2>&1
}

# Update Homebrew formula index
pkg_update() {
    ensure_brew_path
    log_info "Updating Homebrew..."
    brew update --quiet
    log_success "Homebrew updated"
}

# Upgrade all installed formulae
pkg_upgrade() {
    ensure_brew_path
    log_info "Upgrading packages..."
    brew upgrade --quiet
    log_success "Packages upgraded"
}

# Clean up old versions and cache
pkg_clean() {
    ensure_brew_path
    log_info "Cleaning up..."
    brew cleanup --prune=7 -s 2>/dev/null
    log_success "Cleanup complete"
}

# List installed formulae
pkg_list_installed() {
    ensure_brew_path
    brew list --formula 2>/dev/null
}

# Search for a formula
pkg_search() {
    local query="$1"

    if [[ -z "$query" ]]; then
        log_error "Usage: pkg_search <query>"
        return 1
    fi

    ensure_brew_path
    brew search "$query" 2>/dev/null
}

# Get the latest release tag from a GitHub repository
get_latest_github_release() {
    local repo="$1"

    if [[ -z "$repo" ]]; then
        log_error "Usage: get_latest_github_release <owner/repo>"
        return 1
    fi

    curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" 2>/dev/null \
        | python3 -c "import sys,json; print(json.load(sys.stdin).get('tag_name',''))" 2>/dev/null
}

# Download and install a binary from a GitHub release
install_from_github_release() {
    local repo="$1"
    local binary_name="$2"
    local asset_pattern="${3:-}"
    local install_dir="${4:-$HOME/.local/bin}"

    if [[ -z "$repo" || -z "$binary_name" ]]; then
        log_error "Usage: install_from_github_release <owner/repo> <binary-name> [asset-pattern] [install-dir]"
        return 1
    fi

    local tag
    tag="$(get_latest_github_release "$repo")"

    if [[ -z "$tag" ]]; then
        log_error "Failed to get latest release for ${repo}"
        return 1
    fi

    # Default asset pattern for macOS arm64
    if [[ -z "$asset_pattern" ]]; then
        asset_pattern="darwin.*arm64"
    fi

    log_info "Fetching ${binary_name} ${tag} from ${repo}..."

    local download_url
    download_url="$(curl -fsSL "https://api.github.com/repos/${repo}/releases/tags/${tag}" 2>/dev/null \
        | python3 -c "
import sys, json, re
data = json.load(sys.stdin)
for asset in data.get('assets', []):
    if re.search('${asset_pattern}', asset['name'], re.IGNORECASE):
        print(asset['browser_download_url'])
        break
" 2>/dev/null)"

    if [[ -z "$download_url" ]]; then
        log_error "No matching asset found for ${asset_pattern}"
        return 1
    fi

    mkdir -p "$install_dir"
    local filename
    filename="$(basename "$download_url")"

    if curl -fsSL -o "${install_dir}/${filename}" "$download_url"; then
        # Handle archives vs raw binaries
        case "$filename" in
            *.tar.gz|*.tgz)
                tar -xzf "${install_dir}/${filename}" -C "$install_dir" "$binary_name" 2>/dev/null || \
                    tar -xzf "${install_dir}/${filename}" -C "$install_dir" 2>/dev/null
                rm -f "${install_dir}/${filename}"
                ;;
            *.zip)
                unzip -o "${install_dir}/${filename}" -d "$install_dir" 2>/dev/null
                rm -f "${install_dir}/${filename}"
                ;;
            *)
                mv "${install_dir}/${filename}" "${install_dir}/${binary_name}"
                ;;
        esac

        chmod +x "${install_dir}/${binary_name}" 2>/dev/null
        log_success "${binary_name} ${tag} installed to ${install_dir}"
    else
        log_error "Failed to download ${binary_name}"
        return 1
    fi
}
