# Kodra macOS — Shell Aliases
# Sourced by ~/.config/kodra/shell.zsh

# Modern replacements
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first'
alias la='eza -a --icons'
alias lt='eza --tree --level=2 --icons'
alias cat='bat --paging=never'
alias grep='rg'
alias find='fd'
alias top='btop'

# Git shortcuts
alias lg='lazygit'
alias gs='git status'
alias gp='git pull'
alias gd='git diff'
alias gc='git commit'
alias gco='git checkout'
alias gb='git branch'

# Docker shortcuts
alias ld='lazydocker'
alias dc='docker compose'
alias dps='docker ps'

# Kubernetes shortcuts
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kga='kubectl get all'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Misc
alias cls='clear'
alias reload='source ~/.zshrc'
alias path='echo $PATH | tr ":" "\n"'
alias myip='curl -s ifconfig.me'
