#!/usr/bin/env bash
#
# Kodra macOS — Backup/Restore Library
# Manages backup and restore of dotfiles and tool configurations
#

KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
KODRA_BACKUP_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kodra/backups"

source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true

# Files and directories to back up
BACKUP_DOTFILES=(
    "$HOME/.zshrc"
    "$HOME/.zprofile"
    "$HOME/.zshenv"
    "$HOME/.gitconfig"
)

BACKUP_CONFIG_DIRS=(
    "$HOME/.config/starship.toml"
    "$HOME/.config/ghostty"
    "$HOME/.config/btop"
    "$HOME/.config/fastfetch"
    "$HOME/.config/kodra"
    "$HOME/.config/lazygit"
    "$HOME/.config/bat"
)

# Create a labeled backup of all dotfiles and configs
create_backup() {
    local label="${1:-manual}"
    local timestamp
    timestamp="$(date +%Y%m%d-%H%M%S)"
    local backup_name="${timestamp}-${label}"
    local backup_path="${KODRA_BACKUP_DIR}/${backup_name}"

    mkdir -p "$backup_path"

    log_info "Creating backup: ${backup_name}"

    # Back up dotfiles
    local count=0
    for file in "${BACKUP_DOTFILES[@]}"; do
        if [[ -f "$file" ]]; then
            cp "$file" "$backup_path/$(basename "$file")"
            count=$((count + 1))
        fi
    done

    # Back up config directories
    for item in "${BACKUP_CONFIG_DIRS[@]}"; do
        if [[ -e "$item" ]]; then
            local dest_name
            dest_name="config-$(basename "$item")"
            if [[ -d "$item" ]]; then
                cp -R "$item" "$backup_path/$dest_name"
            else
                cp "$item" "$backup_path/$dest_name"
            fi
            count=$((count + 1))
        fi
    done

    # Write metadata
    cat > "$backup_path/metadata.json" << EOF
{
  "label": "${label}",
  "timestamp": "${timestamp}",
  "hostname": "$(hostname -s)",
  "user": "$(whoami)",
  "file_count": ${count},
  "kodra_version": "$(cat "$KODRA_DIR/VERSION" 2>/dev/null || echo "unknown")"
}
EOF

    log_success "Backup created: ${backup_name} (${count} items)"
    echo "    ${C_GRAY}${backup_path}${C_RESET}"
}

# Restore from a backup
restore_backup() {
    local backup_path="$1"

    if [[ -z "$backup_path" ]]; then
        log_error "Usage: kodra backup restore <backup-path>"
        return 1
    fi

    if [[ ! -d "$backup_path" ]]; then
        # Try relative to backup dir
        backup_path="${KODRA_BACKUP_DIR}/${backup_path}"
    fi

    if [[ ! -d "$backup_path" ]]; then
        log_error "Backup not found: $backup_path"
        return 1
    fi

    if [[ ! -f "$backup_path/metadata.json" ]]; then
        log_error "Invalid backup (missing metadata.json)"
        return 1
    fi

    log_info "Restoring from: $(basename "$backup_path")"

    # Restore dotfiles
    local count=0
    for file in "${BACKUP_DOTFILES[@]}"; do
        local basename_file
        basename_file="$(basename "$file")"
        if [[ -f "$backup_path/$basename_file" ]]; then
            cp "$backup_path/$basename_file" "$file"
            count=$((count + 1))
        fi
    done

    # Restore config directories
    for item in "${BACKUP_CONFIG_DIRS[@]}"; do
        local dest_name
        dest_name="config-$(basename "$item")"
        if [[ -e "$backup_path/$dest_name" ]]; then
            local parent_dir
            parent_dir="$(dirname "$item")"
            mkdir -p "$parent_dir"
            if [[ -d "$backup_path/$dest_name" ]]; then
                rm -rf "$item"
                cp -R "$backup_path/$dest_name" "$item"
            else
                cp "$backup_path/$dest_name" "$item"
            fi
            count=$((count + 1))
        fi
    done

    log_success "Restored ${count} items from backup"
}

# List all available backups
list_backups() {
    if [[ ! -d "$KODRA_BACKUP_DIR" ]]; then
        log_info "No backups found"
        return 0
    fi

    local backups
    backups="$(find "$KODRA_BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort -r)"

    if [[ -z "$backups" ]]; then
        log_info "No backups found"
        return 0
    fi

    echo ""
    echo -e "    ${C_PURPLE}Kodra Backups${C_RESET}"
    echo -e "    ${C_GRAY}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}"
    echo ""

    while IFS= read -r backup_dir; do
        local name
        name="$(basename "$backup_dir")"
        local size
        size="$(du -sh "$backup_dir" 2>/dev/null | awk '{print $1}')"

        if [[ -f "$backup_dir/metadata.json" ]]; then
            local label
            label="$(python3 -c "import json; print(json.load(open('$backup_dir/metadata.json')).get('label',''))" 2>/dev/null)"
            echo -e "    ${C_CYAN}→${C_RESET} ${name} ${C_GRAY}(${size}, ${label})${C_RESET}"
        else
            echo -e "    ${C_CYAN}→${C_RESET} ${name} ${C_GRAY}(${size})${C_RESET}"
        fi
    done <<< "$backups"

    echo ""
}

# Delete a backup
delete_backup() {
    local backup_path="$1"

    if [[ -z "$backup_path" ]]; then
        log_error "Usage: kodra backup delete <backup-name>"
        return 1
    fi

    if [[ ! -d "$backup_path" ]]; then
        backup_path="${KODRA_BACKUP_DIR}/${backup_path}"
    fi

    if [[ ! -d "$backup_path" ]]; then
        log_error "Backup not found: $backup_path"
        return 1
    fi

    local name
    name="$(basename "$backup_path")"
    rm -rf "$backup_path"
    log_success "Deleted backup: ${name}"
}

# Verify backup integrity
verify_backup() {
    local backup_path="$1"

    if [[ -z "$backup_path" ]]; then
        log_error "Usage: kodra backup verify <backup-path>"
        return 1
    fi

    if [[ ! -d "$backup_path" ]]; then
        backup_path="${KODRA_BACKUP_DIR}/${backup_path}"
    fi

    if [[ ! -d "$backup_path" ]]; then
        log_error "Backup not found: $backup_path"
        return 1
    fi

    local errors=0

    # Check metadata
    if [[ -f "$backup_path/metadata.json" ]]; then
        if python3 -c "import json; json.load(open('$backup_path/metadata.json'))" 2>/dev/null; then
            log_success "metadata.json valid"
        else
            log_error "metadata.json corrupted"
            errors=$((errors + 1))
        fi
    else
        log_error "metadata.json missing"
        errors=$((errors + 1))
    fi

    # Count files
    local file_count
    file_count="$(find "$backup_path" -type f | wc -l | tr -d ' ')"
    log_info "Backup contains ${file_count} files"

    if [[ "$errors" -eq 0 ]]; then
        log_success "Backup integrity OK"
    else
        log_error "Backup has ${errors} issue(s)"
        return 1
    fi
}

# Get backup size
get_backup_size() {
    local backup_path="$1"

    if [[ -z "$backup_path" ]]; then
        backup_path="$KODRA_BACKUP_DIR"
    elif [[ ! -d "$backup_path" ]]; then
        backup_path="${KODRA_BACKUP_DIR}/${backup_path}"
    fi

    if [[ -d "$backup_path" ]]; then
        du -sh "$backup_path" 2>/dev/null | awk '{print $1}'
    else
        echo "0B"
    fi
}
