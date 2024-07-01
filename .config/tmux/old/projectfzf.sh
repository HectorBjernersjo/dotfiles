#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/.envs"

# Define the directory containing the list of directories
DIRECTORIES_FILE="$HOME/.config/tmux/directories.txt"

# Ensure the directories file exists
if [[ ! -f "$DIRECTORIES_FILE" ]]; then
    echo "Directory list file not found: $DIRECTORIES_FILE"
    exit 1
fi

# Read directories from the file
directories=$(cat "$DIRECTORIES_FILE")

# Exclude the current session
if [[ -z "$TMUX_FZF_SWITCH_CURRENT" ]]; then
    current_session=$(tmux display-message -p '#S')
fi

# Set FZF options
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --header='Select a directory to switch to or create a new session.'"

# Run fzf to select a directory
selected_directory=$(printf "%s\n[cancel]" "$directories" | eval "$TMUX_FZF_BIN $TMUX_FZF_OPTIONS")

# Exit if no directory was selected
[[ "$selected_directory" == "[cancel]" || -z "$selected_directory" ]] && exit

# Extract the target directory name (basename)
target=$(basename "$selected_directory")

# List tmux sessions
if [[ -z "$TMUX_FZF_SESSION_FORMAT" ]]; then
    sessions=$(tmux list-sessions)
else
    sessions=$(tmux list-sessions -F "#S: $TMUX_FZF_SESSION_FORMAT")
fi

# Check if a tmux session with the target name already exists
if echo "$sessions" | grep -q "^$target"; then
    # Switch to the existing session
    tmux switch-client -t "$target"
else
    # Create a new tmux session with the name of the target directory
    tmux new-session -d -s "$target" -c "$selected_directory"
    tmux switch-client -t "$target"
fi
