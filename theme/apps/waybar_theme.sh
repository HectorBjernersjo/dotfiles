#!/usr/bin/env bash

valid_options=("everforest-dark" "everforest-light" "gruvbox-dark" "gruvbox-light" "solarized-dark" "tokyo-night")

if printf "%s\n" "${valid_options[@]}" | grep -qx -- "$1"; then
    echo "@import 'themes/$1.css';" > $HOME/.config/waybar/theme.css
    pkill waybar
    waybar &
else
    echo "Invalid waybar theme: $1"
fi
