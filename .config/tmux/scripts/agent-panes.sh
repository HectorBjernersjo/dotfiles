#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/agent-pane-match.sh"

pane_path=$(tmux display-message -p '#{pane_current_path}')
repo_root=$(git -C "$pane_path" rev-parse --show-toplevel 2>/dev/null)

if [[ -z "$repo_root" ]]; then
  echo "Not inside a git repository."
  exit 1
fi

# Get all worktree directories
worktree_dirs=$(
  cd "$repo_root" || exit
  git worktree list --porcelain 2>/dev/null \
    | awk '/^worktree /{print $2}'
)

session_names=$(tmux list-sessions -F "#S")

# Find agent panes in worktree sessions + current session
find_agent_panes() {
  local session="$1"
  tmux list-panes -s -t "$session" -F "#{session_name}:#{window_index}.#{pane_index}	#{pane_current_command}	#{pane_title}" \
    | while IFS=$'\t' read -r target cmd title; do
        if matches_agent_pane "$cmd" "$title"; then
          echo "$target"
        fi
      done
}

agent_panes=""
while read -r dir; do
  [[ -z "$dir" || ! -d "$dir" ]] && continue
  session_name=$(basename "$dir" | tr '.' '_')
  echo "$session_names" | grep -q "^${session_name}$" || continue
  agent_panes=$(printf "%s\n%s" "$agent_panes" "$(find_agent_panes "$session_name")")
done <<< "$worktree_dirs"

current_session=$(tmux display-message -p '#S')
agent_panes=$(printf "%s\n%s" "$agent_panes" "$(find_agent_panes "$current_session")")

# Dedupe, trim, and pipe to picker
echo "$agent_panes" \
  | sed '/^[[:space:]]*$/d' \
  | awk '!seen[$0]++' \
  | "$CURRENT_DIR/agent-picker.sh" "Worktree AI agent panes (ctrl-r to refresh preview)"
