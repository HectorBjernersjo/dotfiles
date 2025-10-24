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
    # Extract the target directory name (basename)
    target=$(basename "$selected_option" | tr '.' '_')
    
    # Create a new tmux session with the name of the target directory
    tmux new-session -d -s "$target" -c "$selected_option"
    tmux switch-client -t "$target"
fi
