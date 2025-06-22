#!/bin/bash
# -----------------------------------------------------------------------------
# dotnet-tester.sh: A script to run specific dotnet tests in a dedicated tmux window.
#
# Usage: ./dotnet-tester.sh {test_name} [directory]
#
# Arguments:
#   {test_name}  The fully qualified test name to run
#   {directory}  (Optional) The path to the .NET test project directory
#
# This script will:
# 1. Use tmuxhelper.sh to manage tmux windows and panes
# 2. Run `dotnet test --filter "FullyQualifiedName={test_name}"` in the specified directory
# 3. Create a window named "tests" with a single pane
# -----------------------------------------------------------------------------

set -euo pipefail

# --- Configuration ---
readonly WINDOW_NAME="tests"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly TMUX_HELPER="$SCRIPT_DIR/tmuxhelper.sh"

# --- Function Definitions ---

# Function to display usage information
usage() {
    echo "Usage: $0 {test_name} [directory]" >&2
    echo "" >&2
    echo "Arguments:" >&2
    echo "  test_name   The fully qualified test name to run" >&2
    echo "  directory   (Optional) The path to the .NET test project directory" >&2
    echo "" >&2
    echo "Example:" >&2
    echo "  $0 'Flex.Net.IntegrationTests.DataAccess.Mapping.Entities.Chatbot.ChatbotUserProfileMapTests.Verify_Mappings'" >&2
    echo "  $0 'MyProject.Tests.MyTestClass.MyTestMethod' /path/to/test/project" >&2
    exit 1
}

# --- Argument Parsing ---

# Check for the correct number of arguments
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
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

# --- Setup ---
TEST_NAME="$1"
TARGET_DIR="${2:-$(pwd)}"

# Convert to an absolute path
if [[ "$TARGET_DIR" != /* ]]; then
    TARGET_DIR="$(pwd)/$TARGET_DIR"
fi

# Check if the directory actually exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' not found." >&2
    exit 1
fi

# Use "test-runner" as the pane name
readonly PANE_NAME="test-runner"

# Construct the dotnet test command
readonly TEST_COMMAND="dotnet test --filter \"FullyQualifiedName=$TEST_NAME\""

# --- Main Logic ---

# Source the tmux helper functions
source "$TMUX_HELPER"

echo "=== Starting dotnet test runner for '$TEST_NAME' ==="
echo "Directory: $TARGET_DIR"
echo "Command: $TEST_COMMAND"
echo ""

# Run the test using the tmux helper
manage_tmux_session "$WINDOW_NAME" "$PANE_NAME" "$TEST_COMMAND" "$TARGET_DIR"

echo ""
echo "=== Test runner started ===" 