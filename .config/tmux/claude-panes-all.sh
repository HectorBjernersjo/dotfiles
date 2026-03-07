#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Find all panes running claude across ALL sessions
tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index}	#{pane_current_command}	#{pane_title}" \
  | while IFS=$'\t' read -r target cmd title; do
      if [[ "$cmd" == *claude* ]] || [[ "$title" == *claude* ]] || [[ "$cmd" == *node* && "$title" == *claude* ]]; then
        echo "$target"
      fi
    done \
  | "$CURRENT_DIR/claude-picker.sh" "All Claude Code panes (ctrl-r to refresh preview)"
