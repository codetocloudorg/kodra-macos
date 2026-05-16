#!/usr/bin/env bash
# Kodra macOS — Shell Configuration (zsh)
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

ZSHRC="$HOME/.zshrc"

# Backup existing config
if [[ -f "$ZSHRC" ]] && [[ ! -f "$ZSHRC.kodra-backup" ]]; then
    cp "$ZSHRC" "$ZSHRC.kodra-backup"
fi

# Create Kodra shell config snippet
mkdir -p "$HOME/.config/kodra"
cat > "$HOME/.config/kodra/shell.zsh" << 'EOF'
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Kodra macOS — Shell Configuration
# A Code To Cloud Project ☁️
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)" 2>/dev/null

# PATH
export PATH="$HOME/.local/bin:$HOME/.kodra/bin:$PATH"

# ─── Aliases: Git ──────────────────────────────────────────────
alias g="git"
alias gs="git status -sb"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline -20"
alias gd="git diff"
alias gb="git branch"
alias gco="git checkout"
alias gcm="git commit -m"

# ─── Aliases: Modern CLI replacements ─────────────────────────
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias lt="eza --tree --level=2 --icons"
alias cat="bat --paging=never"
alias grep="rg"
alias find="fd"
alias cd="z"
alias top="btop"

# ─── Aliases: Docker ──────────────────────────────────────────
alias d="docker"
alias dc="docker compose"
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dlogs="docker logs -f"

# ─── Aliases: Kubernetes ──────────────────────────────────────
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgs="kubectl get svc"
alias kgd="kubectl get deployments"
alias kns="kubectl config set-context --current --namespace"

# ─── Aliases: Azure ───────────────────────────────────────────
alias azl="az login"
alias azs="az account show"
alias azls="az account list -o table"

# ─── Aliases: Terraform ───────────────────────────────────────
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfa="terraform apply"

# ─── FZF configuration ────────────────────────────────────────
export FZF_DEFAULT_OPTS="
  --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7
  --color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff
  --color=info:#7aa2f7,prompt:#7dcfff,pointer:#bb9af7
  --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
  --height=40% --layout=reverse --border=rounded"

# ─── History ──────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# ─── Completions ──────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ─── Tools init ───────────────────────────────────────────────
eval "$(zoxide init zsh)" 2>/dev/null
eval "$(fzf --zsh)" 2>/dev/null
eval "$(mise activate zsh)" 2>/dev/null
eval "$(starship init zsh)" 2>/dev/null

# ─── Container runtime environment ───────────────────────────
[[ -f "$HOME/.config/kodra/podman-env.zsh" ]] && source "$HOME/.config/kodra/podman-env.zsh"
EOF

# Source Kodra config from .zshrc
append_to_shell_config '# Kodra macOS'
append_to_shell_config 'source "$HOME/.config/kodra/shell.zsh"'
