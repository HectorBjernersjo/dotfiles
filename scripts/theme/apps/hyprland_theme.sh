#!/usr/bin/env bash

valid_options=("everforest-dark" "everforest-light" "gruvbox-dark" "gruvbox-light" "solarized-dark" "tokyo-night")

if printf "%s\n" "${valid_options[@]}" | grep -qx -- "$1"; then
    echo "source=./themes/$1.conf" > "$HOME/.config/hypr/theme.conf"
else
    echo "Invalid hyprland theme $1"
fi
