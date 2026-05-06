#!/usr/bin/env bash
#
# Kodra macOS — Bash Completion
# Install: copy to /opt/homebrew/etc/bash_completion.d/kodra
#

_kodra_completions() {
    local cur prev commands backup_commands
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    commands="doctor repair update cleanup setup dev extensions fetch defaults refresh shortcuts version help backup"
    backup_commands="create list restore delete verify"

    case "$prev" in
        kodra)
            COMPREPLY=($(compgen -W "$commands" -- "$cur"))
            ;;
        doctor)
            COMPREPLY=($(compgen -W "--fix" -- "$cur"))
            ;;
        repair)
            COMPREPLY=($(compgen -W "--all" -- "$cur"))
            ;;
        backup)
            COMPREPLY=($(compgen -W "$backup_commands" -- "$cur"))
            ;;
        restore|delete|verify)
            # Complete with backup directory names
            local backup_dir="${XDG_CONFIG_HOME:-$HOME/.config}/kodra/backups"
            if [[ -d "$backup_dir" ]]; then
                COMPREPLY=($(compgen -W "$(ls "$backup_dir" 2>/dev/null)" -- "$cur"))
            fi
            ;;
        *)
            COMPREPLY=($(compgen -W "--verbose" -- "$cur"))
            ;;
    esac
}

complete -F _kodra_completions kodra
