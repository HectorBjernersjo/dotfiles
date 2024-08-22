#!/bin/bash

# File containing the list of themes
command_file="themes.txt"

# Show the list using rofi and capture the selected option
selection=$(cat "$command_file" | rofi -dmenu -p "Select Theme:")

# Execute the theme script with the selected theme
if [ -n "$selection" ]; then
    ./theme.sh "$selection"
else
    echo "No theme selected."
fi
