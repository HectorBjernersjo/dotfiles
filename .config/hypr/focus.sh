#!/bin/bash

# Launch the application
$1 &

# Wait for a short period to ensure the application is fully started
sleep 1

# Focus the window
hyprctl dispatch focuswindow $2

