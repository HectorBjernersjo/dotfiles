#!/bin/bash
# -----------------------------------------------------------------------------
# dotnet-runner.sh: A script to manage dotnet run tasks in a dedicated tmux window.
#
# Usage: ./dotnet-runner.sh [--ts] {directory}
#
# Arguments:
#   --ts         (Optional) Also launch a TypeScript watch compiler in a
#                parallel pane.
#   {directory}  The path to the .NET project directory.
#
# This script will:
# 1. Use tmuxhelper.sh to manage tmux windows and panes
# 2. Run `dotnet run` in the specified directory
# 3. Optionally run `npx tsc --watch` in a parallel pane if --ts is specified
# -----------------------------------------------------------------------------

set -euo pipefail

# --- Configuration ---
readonly WINDOW_NAME="runner"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly TMUX_HELPER="$SCRIPT_DIR/tmuxhelper.sh"

# --- Function Definitions ---

# Function to display usage information
usage() {
    echo "Usage: $0 [--ts] {path/to/your/project_directory}" >&2
    exit 1
}

# --- Argument Parsing ---

# Parse command-line options
LAUNCH_TS=false
while getopts ":-:" opt; do
    case ${opt} in
        -)
            case "${OPTARG}" in
                ts)
                    LAUNCH_TS=true
                    ;;
                *)
                    echo "Invalid option: --${OPTARG}" >&2
                    usage
                    ;;
            esac;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# Check for the correct number of arguments
if [ "$#" -ne 1 ]; then
    usage
fi

# --- Validation ---

# Check if tmux helper exists
if [ ! -f "$TMUX_HELPER" ]; then
    echo "Error: tmux helper script not found at '$TMUX_HELPER'." >&2
    exit 1
fi

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

# --- Path Setup ---
TARGET_DIR="$1"

# Convert to an absolute path
if [[ "$TARGET_DIR" != /* ]]; then
    TARGET_DIR="$(pwd)/$TARGET_DIR"
fi

# Check if the directory actually exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' not found." >&2
    exit 1
fi

# Use the directory's base name as a human-friendly identifier for the pane title
readonly PANE_NAME=$(basename "$TARGET_DIR")
readonly TS_PANE_NAME="${PANE_NAME}-ts"

# --- Main Logic ---

# Source the tmux helper functions
source "$TMUX_HELPER"

echo "=== Starting dotnet runner for '$TARGET_DIR' ==="

# Ensure window exists first
find_or_create_window "$WINDOW_NAME" "$TARGET_DIR" > /dev/null

# Find or create the dotnet pane
dotnet_pane_id=$(find_or_create_pane "$WINDOW_NAME" "$PANE_NAME" "$TARGET_DIR")

# Run dotnet command
run_command_in_pane "$dotnet_pane_id" "$PANE_NAME" "dotnet run -p:WarningLevel=0"

# Handle TypeScript if requested
if [ "$LAUNCH_TS" = true ]; then
    echo ""
    echo "=== Starting TypeScript compiler ==="
    
    # Check if TS pane already exists
    ts_pane_id=""
    for pane in $(tmux list-panes -t "$WINDOW_NAME" -F '#{pane_id}'); do
        pane_title=$(tmux display-message -p -t "$pane" '#T')
        if [[ "$pane_title" == "$TS_PANE_NAME" ]]; then
            ts_pane_id="$pane"
            echo "Found existing TypeScript pane '$TS_PANE_NAME' (#$ts_pane_id)."
            break
        fi
    done
    
    # Create TS pane if it doesn't exist
    if [ -z "$ts_pane_id" ]; then
        echo "Creating TypeScript pane '$TS_PANE_NAME'..."
        ts_pane_id=$(tmux split-window -h -t "$dotnet_pane_id" -c "$TARGET_DIR" -P -F '#{pane_id}')
        tmux select-pane -t "$ts_pane_id" -T "$TS_PANE_NAME"
    fi
    
    # Run TypeScript compiler
    run_command_in_pane "$ts_pane_id" "$TS_PANE_NAME" "tsc --watch"
fi

# Switch to the dotnet pane
echo "Switching to pane '$PANE_NAME' in window '$WINDOW_NAME'."
tmux select-window -t "$WINDOW_NAME"
tmux select-pane -t "$dotnet_pane_id"

echo ""
echo "=== Setup complete ===" 
