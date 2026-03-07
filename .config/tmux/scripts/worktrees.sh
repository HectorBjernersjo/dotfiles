#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/../.envs"

# Get the pane's current working directory
pane_path=$(tmux display-message -p '#{pane_current_path}')

# Get the root of the current git repo
repo_root=$(git -C "$pane_path" rev-parse --show-toplevel 2>/dev/null)
if [[ -z "$repo_root" ]]; then
  echo "Not inside a git repository."
  exit 1
fi

# Collect all worktree directories (including the main one)
worktree_dirs=$(
  cd "$repo_root" || exit
  git worktree list --porcelain 2>/dev/null \
    | awk '/^worktree /{print $2}'
)

if [[ -z "$worktree_dirs" ]]; then
  echo "No worktrees found."
  exit 1
fi

# List tmux sessions
if [[ -z "$TMUX_FZF_SESSION_FORMAT" ]]; then
  sessions=$(tmux list-sessions -F "#S")
else
  sessions=$(tmux list-sessions -F "#S: $TMUX_FZF_SESSION_FORMAT")
fi

# Get the list of session names
session_names=$(tmux list-sessions -F "#S")

# Split worktree dirs into those with existing sessions and those without
existing_sessions=""
new_directories=""

while read -r dir; do
  [[ -z "$dir" || ! -d "$dir" ]] && continue
  dir_name=$(basename "$dir" | tr '.' '_')
  if echo "$session_names" | grep -q "^${dir_name}$"; then
    if [[ -z "$TMUX_FZF_SESSION_FORMAT" ]]; then
      existing_sessions=$(printf "%s\n%s" "$existing_sessions" "$dir_name")
    else
      session_line=$(tmux list-sessions -F "#S: $TMUX_FZF_SESSION_FORMAT" | grep "^${dir_name}:")
      existing_sessions=$(printf "%s\n%s" "$existing_sessions" "$session_line")
    fi
  else
    new_directories=$(printf "%s\n%s" "$new_directories" "$dir")
  fi
done <<< "$worktree_dirs"

# Trim leading blank lines
existing_sessions=$(echo "$existing_sessions" | sed '/^[[:space:]]*$/d')
new_directories=$(echo "$new_directories" | sed '/^[[:space:]]*$/d')

# Combine: existing sessions first, then directories
options=$(printf "%s\n%s" "$existing_sessions" "$new_directories" | sed '/^[[:space:]]*$/d')

if [[ -z "$options" ]]; then
  echo "No worktrees found."
  exit 1
fi

# Set FZF options
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --header='Select a worktree session or directory to create a new session.'"

# Run fzf to select a session or directory
selected_option=$(printf "%s\n[cancel]" "$options" | eval "$TMUX_FZF_BIN $TMUX_FZF_OPTIONS")

# Exit if no option was selected
[[ "$selected_option" == "[cancel]" || -z "$selected_option" ]] && exit

# Determine if the selected option is an existing session or a directory
selected_name=$(echo "$selected_option" | sed 's/:.*//')
if echo "$session_names" | grep -q "^${selected_name}$"; then
  tmux switch-client -t "$selected_name"
else
  target=$(basename "$selected_option" | tr '.' '_')

  tmux new-session -d -s "$target" -c "$selected_option"

  # Per-project hook
  if [[ -x "$selected_option/.tmux.sh" ]]; then
    "$selected_option/.tmux.sh" "$target" "$selected_option"
  fi

  tmux switch-client -t "$target"
fi
