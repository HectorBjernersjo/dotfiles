#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/.envs"

# List tmux sessions
if [[ -z "$TMUX_FZF_SESSION_FORMAT" ]]; then
    sessions=$(tmux list-sessions)
else
    sessions=$(tmux list-sessions -F "#S: $TMUX_FZF_SESSION_FORMAT")
fi

# Exclude the current session
if [[ -z "$TMUX_FZF_SWITCH_CURRENT" ]]; then
    current_session=$(tmux display-message -p '#S')
    sessions=$(echo "$sessions" | grep -v "^$current_session: ")
fi

# Set FZF options
FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --header='Select a session to switch to.'"

# Run fzf to select a session
selected_session=$(printf "%s\n[cancel]" "$sessions" | eval "$TMUX_FZF_BIN $TMUX_FZF_OPTIONS")

# Exit if no session was selected
[[ "$selected_session" == "[cancel]" || -z "$selected_session" ]] && exit

# Extract the session name and switch to it
target=$(echo "$selected_session" | sed -e 's/:.*$//')
tmux switch-client -t "$target"

