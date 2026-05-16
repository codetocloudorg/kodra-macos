#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# Kodra — Sidebar Agent Menu
# Quickly switch between agent workspaces
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Display menu in tmux
tmux display-menu -T "#[fg=#00ffcc,bold] ⚡ Agent Workspaces" \
  "" \
  "🏠 Landing Page"    l "select-window -t kodra:landing"  \
  "🔧 Kodra Core"      k "select-window -t kodra:kodra"    \
  "🖥  Kodra macOS"     m "select-window -t kodra:macos"    \
  "" \
  "───────────────" "" "" \
  "➕ New Shell"        n "new-window -t kodra -c ~/Dev"    \
  "🔄 Reload Config"   r "source-file ~/.tmux.conf"
