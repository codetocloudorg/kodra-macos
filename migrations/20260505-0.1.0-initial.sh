#!/usr/bin/env bash
#
# Kodra macOS — Migration: 20260505-0.1.0-initial
# Description: Initial macOS Kodra setup
#

KODRA_DIR="${KODRA_DIR:-$HOME/.kodra}"
MIGRATION_ID="20260505-0.1.0-initial"
MIGRATION_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kodra/migrations"

source "$KODRA_DIR/lib/logging.sh" 2>/dev/null || true
source "$KODRA_DIR/lib/utils.sh" 2>/dev/null || true

# Check if this migration has already been applied
is_applied() {
    [[ -f "$MIGRATION_DIR/$MIGRATION_ID.done" ]]
}

# Apply the migration
migrate_up() {
    if is_applied; then
        log_info "Migration $MIGRATION_ID already applied"
        return 0
    fi

    log_info "Applying migration: $MIGRATION_ID"

    # Ensure config directories exist
    mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/kodra"
    mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/kodra/backups"
    mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/kodra/migrations"
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/state/kodra"

    # Install shell completions
    local completions_dir="$KODRA_DIR/configs/completions"
    if [[ -d "$completions_dir" ]]; then
        # zsh completions — link to site-functions if available
        local zsh_comp_dir
        zsh_comp_dir="$(brew_prefix)/share/zsh/site-functions"
        if [[ -d "$zsh_comp_dir" ]]; then
            ln -sf "$completions_dir/_kodra" "$zsh_comp_dir/_kodra" 2>/dev/null || true
            log_success "Installed zsh completions"
        fi

        # bash completions
        local bash_comp_dir
        bash_comp_dir="$(brew_prefix)/etc/bash_completion.d"
        if [[ -d "$bash_comp_dir" ]]; then
            ln -sf "$completions_dir/kodra.bash" "$bash_comp_dir/kodra" 2>/dev/null || true
            log_success "Installed bash completions"
        fi
    fi

    # Mark migration as done
    mkdir -p "$MIGRATION_DIR"
    date "+%Y-%m-%dT%H:%M:%S" > "$MIGRATION_DIR/$MIGRATION_ID.done"

    log_success "Migration $MIGRATION_ID applied"
}

# Reverse the migration
migrate_down() {
    if ! is_applied; then
        log_info "Migration $MIGRATION_ID not applied — nothing to reverse"
        return 0
    fi

    log_info "Reverting migration: $MIGRATION_ID"

    # Remove shell completions
    local zsh_comp_dir
    zsh_comp_dir="$(brew_prefix)/share/zsh/site-functions"
    rm -f "$zsh_comp_dir/_kodra" 2>/dev/null || true

    local bash_comp_dir
    bash_comp_dir="$(brew_prefix)/etc/bash_completion.d"
    rm -f "$bash_comp_dir/kodra" 2>/dev/null || true

    # Remove migration marker
    rm -f "$MIGRATION_DIR/$MIGRATION_ID.done"

    log_success "Migration $MIGRATION_ID reverted"
}

# Show migration status
show_status() {
    if is_applied; then
        local applied_at
        applied_at="$(cat "$MIGRATION_DIR/$MIGRATION_ID.done" 2>/dev/null)"
        echo -e "  ${C_GREEN}✔${C_RESET} $MIGRATION_ID ${C_GRAY}(applied: ${applied_at})${C_RESET}"
    else
        echo -e "  ${C_YELLOW}⚠${C_RESET} $MIGRATION_ID ${C_GRAY}(not applied)${C_RESET}"
    fi
}

# Entry point
case "${1:-status}" in
    up)     migrate_up ;;
    down)   migrate_down ;;
    status) show_status ;;
    *)
        echo "Usage: $0 {up|down|status}"
        exit 1
        ;;
esac
