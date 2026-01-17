#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURRENT_DIR/.envs"

# Define the directory containing the list of directories
DIRECTORIES_FILE="$HOME/.config/tmux/directories.txt"

# Get worktree directories from HRM.git
HRM_REPO="$HOME/HRM"
worktree_dirs=""

if [[ -d "$HRM_REPO" ]]; then
    # Get worktree paths (skip the main repo itself)
    worktree_dirs=$(cd "$HRM_REPO" && git worktree list --porcelain 2>/dev/null | grep "^worktree" | awk '{print $2}' | grep -v "^$HRM_REPO$")
fi

# Ensure the directories file exists
if [[ ! -f "$DIRECTORIES_FILE" ]]; then
    echo "Directory list file not found: $DIRECTORIES_FILE"
    exit 1
fi

# Read directories from the file
file_directories=$(cat "$DIRECTORIES_FILE")

# Combine file directories and worktree directories
directories=$(printf "%s\n%s" "$file_directories" "$worktree_dirs" | grep -v '^$')

# List tmux sessions
if [[ -z "$TMUX_FZF_SESSION_FORMAT" ]]; then
    sessions=$(tmux list-sessions -F "#S")
else
    sessions=$(tmux list-sessions -F "#S: $TMUX_FZF_SESSION_FORMAT")
fi

# Get the list of session names
session_names=$(tmux list-sessions -F "#S")

# Filter directories to exclude those that already have a session
filtered_directories=$(echo "$directories" | while read -r dir; do
    # Skip if directory doesn't exist
    [[ ! -d "$dir" ]] && continue
    
    dir_name=$(basename "$dir")
    if ! echo "$session_names" | grep -q "^$dir_name$"; then
        echo "$dir"
    fi
done)

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
    # Switch to the existing session
    tmux switch-client -t "$selected_option"
else
  target=$(basename "$selected_option" | tr '.' '_')

  # Build -e VAR=VALUE args from .env (strip surrounding quotes)
  envargs=()
  if [[ -f "$selected_option/.env" ]]; then
    while IFS='=' read -r k v; do
      # skip blanks/comments
      [[ -z "$k" || "$k" =~ ^# ]] && continue
      # trim whitespace
      k="${k#"${k%%[![:space:]]*}"}"; k="${k%"${k##*[![:space:]]}"}"
      v="${v#"${v%%[![:space:]]*}"}"; v="${v%"${v##*[![:space:]]}"}"
      # remove surrounding quotes if present
      [[ "$v" == \"*\" && "$v" == *\" ]] && v="${v:1:-1}"
      envargs+=(-e "$k=$v")
    done < "$selected_option/.env"
  fi

  # Create the session WITH env vars applied
  # (tmux >= 3.2 supports multiple -e)
  tmux new-session -d -s "$target" -c "$selected_option" "${envargs[@]}"

  # Optional: also set them in tmux's env for future windows in this session
  if [[ -n "${envargs[*]}" ]]; then
    while IFS='=' read -r k v; do
      [[ -z "$k" || "$k" =~ ^# ]] && continue
      [[ "$v" == \"*\" && "$v" == *\" ]] && v="${v:1:-1}"
      tmux set-environment -t "$target" "$k" "$v"
    done < "$selected_option/.env"
  fi

  # Per-project hook after env is in place
  if [[ -x "$selected_option/.tmux.sh" ]]; then
    "$selected_option/.tmux.sh" "$target" "$selected_option"
  fi

  tmux switch-client -t "$target"
fi
