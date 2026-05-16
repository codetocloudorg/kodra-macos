#!/usr/bin/env bash
# Kodra macOS — Install tmux terminal multiplexer
source "$(dirname "${BASH_SOURCE[0]}")/../../lib/utils.sh"

brew_install tmux

# Deploy tmux configuration
cat > "$HOME/.tmux.conf" << 'EOF'
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Kodra — tmux Configuration
# Agentic Multi-Project Workspace ⚡
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ─── Prefix ───────────────────────────────────────────────────
# Use Ctrl+a instead of Ctrl+b (easier to reach)
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# ─── General ──────────────────────────────────────────────────
set -g default-terminal "xterm-256color"
set -ga terminal-overrides ",xterm-256color:Tc"
set -g mouse on
set -g base-index 1
setw -g pane-base-index 1
set -g renumber-windows on
set -g history-limit 50000
set -sg escape-time 0
set -g focus-events on

# ─── Status Bar (bottom) ─────────────────────────────────────
set -g status-position bottom
set -g status-style "bg=#1a1a2e,fg=#c0c0c0"
set -g status-left-length 30
set -g status-right-length 60
set -g status-left "#[fg=#00ffcc,bold] ⚡ #S #[default]│ "
set -g status-right "#[fg=#888888]%H:%M #[fg=#00ffcc]│ #[fg=#ff6ec7]Kodra"

# ─── Window (tab) Styling ────────────────────────────────────
setw -g window-status-format "#[fg=#555555] #I:#W "
setw -g window-status-current-format "#[fg=#00ffcc,bold,bg=#2a2a4e] ▸ #I:#W "
setw -g window-status-separator ""

# ─── Pane Borders ─────────────────────────────────────────────
set -g pane-border-style "fg=#333355"
set -g pane-active-border-style "fg=#00ffcc"

# ─── Navigation ──────────────────────────────────────────────
# Switch windows (tabs) with Alt+number
bind -n M-1 select-window -t 1
bind -n M-2 select-window -t 2
bind -n M-3 select-window -t 3
bind -n M-4 select-window -t 4
bind -n M-5 select-window -t 5

# Switch panes with Alt+arrows
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# ─── Sidebar Toggle ──────────────────────────────────────────
# Ctrl+a then s to toggle the sidebar menu
bind s run-shell "~/.config/ghostty/sidebar-menu.sh"

# ─── Splits ──────────────────────────────────────────────────
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind c new-window -c "#{pane_current_path}"

# ─── Reload ──────────────────────────────────────────────────
bind r source-file ~/.tmux.conf \; display "Config reloaded ⚡"
EOF

# Deploy the sidebar menu script
mkdir -p "$HOME/.config/ghostty"
cp "$(dirname "${BASH_SOURCE[0]}")/../../configs/sidebar-menu.sh" "$HOME/.config/ghostty/sidebar-menu.sh"
chmod +x "$HOME/.config/ghostty/sidebar-menu.sh"
