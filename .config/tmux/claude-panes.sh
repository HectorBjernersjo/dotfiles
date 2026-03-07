#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# Find claude panes in worktree sessions + current session
find_claude_panes() {
  local session="$1"
  tmux list-panes -s -t "$session" -F "#{session_name}:#{window_index}.#{pane_index}	#{pane_current_command}	#{pane_title}" \
    | while IFS=$'\t' read -r target cmd title; do
        if [[ "$cmd" == *claude* ]] || [[ "$title" == *claude* ]] || [[ "$cmd" == *node* && "$title" == *claude* ]]; then
          echo "$target"
        fi
      done
}

claude_panes=""
while read -r dir; do
  [[ -z "$dir" || ! -d "$dir" ]] && continue
  session_name=$(basename "$dir" | tr '.' '_')
  echo "$session_names" | grep -q "^${session_name}$" || continue
  claude_panes=$(printf "%s\n%s" "$claude_panes" "$(find_claude_panes "$session_name")")
done <<< "$worktree_dirs"

current_session=$(tmux display-message -p '#S')
claude_panes=$(printf "%s\n%s" "$claude_panes" "$(find_claude_panes "$current_session")")

# Dedupe, trim, and pipe to picker
echo "$claude_panes" \
  | sed '/^[[:space:]]*$/d' \
  | awk '!seen[$0]++' \
  | "$CURRENT_DIR/claude-picker.sh" "Worktree Claude panes (ctrl-r to refresh preview)"
