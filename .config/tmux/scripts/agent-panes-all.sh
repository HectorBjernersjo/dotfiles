#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/agent-pane-match.sh"

# Find all panes running supported agents across ALL sessions
tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index}	#{pane_current_command}	#{pane_title}" \
  | while IFS=$'\t' read -r target cmd title; do
      if matches_agent_pane "$cmd" "$title"; then
        echo "$target"
      fi
    done \
  | "$CURRENT_DIR/agent-picker.sh" "All AI agent panes (ctrl-r to refresh preview)"
