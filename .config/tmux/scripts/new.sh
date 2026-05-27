#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/../.envs"

# Define the directory containing the list of directories
DIRECTORIES_FILE="$HOME/.config/tmux/directories.txt"

# Ensure the directories file exists
if [[ ! -f "$DIRECTORIES_FILE" ]]; then
  echo "Directory list file not found: $DIRECTORIES_FILE"
  exit 1
fi

# Read directories from the file, expanding git worktrees
directories=$(
  while read -r dir; do
    [[ -z "$dir" || ! -d "$dir" ]] && continue
    # Check if this directory is inside a git repo (or is a bare repo) with worktrees
    repo_root=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null)
    if [[ -z "$repo_root" ]] && [[ "$(git -C "$dir" rev-parse --is-bare-repository 2>/dev/null)" == "true" ]]; then
      repo_root="$dir"
    fi
    if [[ -n "$repo_root" ]]; then
      worktrees=$(git -C "$repo_root" worktree list --porcelain 2>/dev/null \
        | awk '/^worktree /{print $2}')
      # More than one worktree means it's using worktrees
      wt_count=$(echo "$worktrees" | wc -l)
      if [[ $wt_count -gt 1 ]]; then
        echo "$worktrees"
      else
        echo "$dir"
      fi
    else
      echo "$dir"
    fi
  done < "$DIRECTORIES_FILE" | sort -u
)

# List tmux sessions
if [[ -z "$TMUX_FZF_SESSION_FORMAT" ]]; then
  sessions=$(tmux list-sessions -F "#S")
else
  sessions=$(tmux list-sessions -F "#S: $TMUX_FZF_SESSION_FORMAT")
fi

# Get the list of session names
session_names=$(tmux list-sessions -F "#S")

# Filter directories to exclude those that already have a session
filtered_directories=$(
  echo "$directories" | while read -r dir; do
    [[ ! -d "$dir" ]] && continue

    dir_name=$(basename "$dir")
    if ! echo "$session_names" | grep -q "^$dir_name$"; then
      echo "$dir"
    fi
  done
)

# Combine sessions and directories for FZF selection
options=$(printf "%s\n%s" "$sessions" "$filtered_directories")

# Set FZF options
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --header='Select a tmux session or a directory to create a new session.'"

# Run fzf to select a session or directory
selected_option=$(printf "%s\n[cancel]" "$options" | eval "$TMUX_FZF_BIN $TMUX_FZF_OPTIONS")

# Exit if no option was selected
[[ "$selected_option" == "[cancel]" || -z "$selected_option" ]] && exit

# Determine if the selected option is a session or a directory
if echo "$session_names" | grep -q "^$selected_option$"; then
  tmux switch-client -t "$selected_option"
else
  target=$(basename "$selected_option" | tr '.' '_')

  tmux new-session -d -s "$target" -c "$selected_option"

  # Per-project hook
  if [[ -x "$selected_option/.tmux.sh" ]]; then
    "$selected_option/.tmux.sh" "$target" "$selected_option"
  fi

  tmux switch-client -t "$target"
fi
