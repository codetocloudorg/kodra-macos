#!/usr/bin/env bash
# Kodra macOS — Install Starship prompt
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_install starship

# Add starship init to shell
append_to_shell_config 'eval "$(starship init zsh)"'

# Configure Starship with Kodra theme
mkdir -p "$HOME/.config"
cat > "$HOME/.config/starship.toml" << 'EOF'
# Kodra macOS — Starship Prompt Configuration
format = """
[╭─](bold purple) $directory$git_branch$git_status$azure$kubernetes$docker_context
[╰─](bold purple) $character"""

[character]
success_symbol = "[❯](bold cyan)"
error_symbol = "[❯](bold red)"

[directory]
style = "bold blue"
truncation_length = 4
truncate_to_repo = true

[git_branch]
style = "bold purple"
format = "on [$symbol$branch]($style) "

[git_status]
style = "bold red"

[azure]
disabled = false
format = "on [$symbol($subscription)]($style) "
symbol = "☁️ "
style = "bold blue"

[kubernetes]
disabled = false
format = "on [$symbol$context( \\($namespace\\))]($style) "
style = "bold cyan"

[docker_context]
disabled = false
format = "via [$symbol$context]($style) "
style = "bold blue"

[cmd_duration]
min_time = 2_000
format = "took [$duration](bold yellow) "
EOF
