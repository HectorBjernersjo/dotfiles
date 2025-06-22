#!/bin/bash
# -----------------------------------------------------------------------------
# tmuxhelper.sh: A reusable script for managing tmux windows and panes.
#
# Usage: ./tmuxhelper.sh {window_name} {pane_name} {command} [directory]
#
# Arguments:
#   {window_name}  The name of the tmux window to use/create
#   {pane_name}    The title for the pane
#   {command}      The command to run in the pane
#   {directory}    (Optional) The directory to run the command in
#
# This script will:
# 1. Check if it's running inside a tmux session
# 2. Look for the specified tmux window, creating it if needed
# 3. Look for a pane with the specified title in that window
# 4. If the pane doesn't exist, create it with a vertical split
# 5. Check if the target pane is idle (sitting at a shell prompt)
# 6. If idle, execute the specified command
# 7. If already running, switch to that pane
# -----------------------------------------------------------------------------

set -euo pipefail

# --- Configuration ---
readonly IDLE_COMMANDS=("bash" "zsh" "sh" "fish" "tcsh" "ksh")

# --- Function Definitions ---

# Checks if a pane is idle (running a standard shell)
# Usage: is_pane_idle {pane_id}
is_pane_idle() {
    local pane_id="$1"
    local current_command
    current_command=$(tmux display-message -p -t "$pane_id" '#{pane_current_command}')

    for cmd in "${IDLE_COMMANDS[@]}"; do
        if [ "$current_command" == "$cmd" ]; then
            return 0 # 0 for true in bash functions
        fi
    done
    return 1 # 1 for false
}

# Find or create a tmux window
# Usage: find_or_create_window {window_name} [directory]
# Returns: window_id via echo
find_or_create_window() {
    local window_name="$1"
    local directory="${2:-$(pwd)}"
    local window_id

    if tmux list-windows -F '#W' | grep -q "^${window_name}$"; then
        echo "Window '$window_name' found." >&2
        window_id=$(tmux list-windows -F '#{window_id}:#{window_name}' | grep ":${window_name}$" | cut -d: -f1)
    else
        echo "Window '$window_name' not found. Creating it..." >&2
        window_id=$(tmux new-window -n "$window_name" -c "$directory" -P -F '#{window_id}')
        echo "Created new window '$window_name' (#$window_id)." >&2
    fi
    
    echo "$window_id"
}

# Find or create a pane in a window
# Usage: find_or_create_pane {window_name} {pane_name} [directory]
# Returns: pane_id via echo
find_or_create_pane() {
    local window_name="$1"
    local pane_name="$2"
    local directory="${3:-$(pwd)}"
    local pane_id=""

    # Convert to absolute path if directory is provided
    if [[ "$directory" != /* ]]; then
        directory="$(pwd)/$directory"
    fi

    # Search for existing pane
    echo "Searching for pane '$pane_name' in window '$window_name'..." >&2
    for pane in $(tmux list-panes -t "$window_name" -F '#{pane_id}'); do
        local pane_title
        pane_title=$(tmux display-message -p -t "$pane" '#T')
        if [[ "$pane_title" == "$pane_name" ]]; then
            pane_id="$pane"
            echo "Found existing pane '$pane_name' (#$pane_id)." >&2
            break
        fi
    done

    # Create pane if not found
    if [ -z "$pane_id" ]; then
        # Check if there's only one pane in the window (the default one)
        local pane_count
        pane_count=$(tmux list-panes -t "$window_name" | wc -l)
        
        if [ "$pane_count" -eq 1 ]; then
            # Use the existing single pane and just retitle it
            echo "Using existing single pane in window '$window_name' for '$pane_name'..." >&2
            pane_id=$(tmux list-panes -t "$window_name" -F '#{pane_id}' | head -1)
            tmux select-pane -t "$pane_id" -T "$pane_name"
            # Set the working directory if needed
            tmux send-keys -t "$pane_id" "cd '$directory'" C-m
            echo "Configured pane '$pane_name' (#$pane_id)." >&2
        else
            # Multiple panes exist, create a new split
            echo "Pane '$pane_name' not found. Creating a new one..." >&2
            pane_id=$(tmux split-window -v -t "$window_name" -c "$directory" -P -F '#{pane_id}')
            tmux select-pane -t "$pane_id" -T "$pane_name"
            echo "Created new pane '$pane_name' (#$pane_id)." >&2
        fi
    fi

    echo "$pane_id"
}

# Run command in pane if idle, otherwise just switch to it
# Usage: run_command_in_pane {pane_id} {pane_name} {command}
run_command_in_pane() {
    local pane_id="$1"
    local pane_name="$2"
    local command="$3"

    if is_pane_idle "$pane_id"; then
        echo "Pane '$pane_name' (#$pane_id) is idle. Running: '$command'..." >&2
        tmux send-keys -t "$pane_id" "$command" C-m
    else
        local current_cmd
        current_cmd=$(tmux display-message -p -t "$pane_id" '#{pane_current_command}')
        echo "Pane '$pane_name' (#$pane_id) is already running: '$current_cmd'." >&2
    fi
}

# Main function to manage tmux window/pane and run command
# Usage: manage_tmux_session {window_name} {pane_name} {command} [directory]
manage_tmux_session() {
    local window_name="$1"
    local pane_name="$2" 
    local command="$3"
    local directory="${4:-$(pwd)}"

    # Find or create window
    local window_id
    window_id=$(find_or_create_window "$window_name" "$directory")

    # Find or create pane
    local pane_id
    pane_id=$(find_or_create_pane "$window_name" "$pane_name" "$directory")

    # Run command in pane
    run_command_in_pane "$pane_id" "$pane_name" "$command"

    # Switch to the pane
    echo "Switching to pane '$pane_name' in window '$window_name'." >&2
    tmux select-window -t "$window_name"
    tmux select-pane -t "$pane_id"

    return 0
}

# --- Main Script Logic (when run directly) ---

# Function to display usage information
usage() {
    echo "Usage: $0 {window_name} {pane_name} {command} [directory]" >&2
    echo "" >&2
    echo "Arguments:" >&2
    echo "  window_name  The name of the tmux window to use/create" >&2
    echo "  pane_name    The title for the pane" >&2
    echo "  command      The command to run in the pane" >&2
    echo "  directory    (Optional) The directory to run the command in" >&2
    exit 1
}

# Only run main logic if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Check if tmux is installed
    if ! command -v tmux &> /dev/null; then
        echo "Error: tmux is not installed or not in your PATH." >&2
        exit 1
    fi

    # Check if the script is run from within a tmux session
    if [ -z "${TMUX-}" ]; then
        echo "Error: This script must be run from within a tmux session." >&2
        exit 1
    fi

    # Check for the correct number of arguments
    if [ "$#" -lt 3 ] || [ "$#" -gt 4 ]; then
        usage
    fi

    # Run the main function with provided arguments
    manage_tmux_session "$1" "$2" "$3" "${4:-$(pwd)}"
fi
