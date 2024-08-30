#!/bin/bash

# # Desired workspace
WORKSPACE_NAME=$1

# Shift the positional parameters so that "$@" contains the command and its arguments
shift

# # Check if the specified workspace exists and if the command is running in the desired workspace
# TEST=$(swaymsg -p -t get_workspaces | grep -A 3 "Workspace $WORKSPACE_NAME" | grep "Representation")
# LENGHT=${#TEST}

# if [ "$LENGHT" -gt 21 ] || echo $TEST | grep null; then
if ! swaymsg -p -t get_workspaces | grep -A 3 "Workspace $WORKSPACE_NAME" | grep "Representation" | grep null; then
    # Launch the application in the desired workspace
	echo $TEST
	echo "hej"
else
    # Just switch to the desired workspace if the application is already running there
	"$@" &
fi
