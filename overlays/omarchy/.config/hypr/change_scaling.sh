#!/usr/bin/env bash

# Path to the scaling configuration
CONFIG="$HOME/.config/hypr/scaling.conf"

# Scaling profiles
CUSTOM="monitor=HDMI-A-1,preferred,auto,1.25
monitor=DP-1 ,preferred,auto,1.07"

UNSCALED="monitor=HDMI-A-1,preferred,auto,1
monitor=DP-1 ,preferred,auto,1"

# Check which mode is currently active
if grep -q "1.25" "$CONFIG"; then
    echo "Switching to unscaled mode..."
    echo "$UNSCALED" > "$CONFIG"
else
    echo "Switching to custom scaling..."
    echo "$CUSTOM" > "$CONFIG"
fi

# Reload Hyprland configuration
hyprctl reload
