#!/bin/bash
theme=$(cat "$HOME/dotfiles/wallpapers/theme.txt")
style=$(cat "$HOME/dotfiles/wallpapers/style.txt")

if [ "$style" == "all" ]; then
    wallpapersDir="$HOME/dotfiles/wallpapers/$theme"
else
    wallpapersDir="$HOME/dotfiles/wallpapers/$theme/$style"
fi

echo "Wallpaper directory: $wallpapersDir"

# Use globbing to correctly expand the files in the directory
if [ "$style" == "all" ]; then
    wallpapers=("$wallpapersDir"/*/*)  # Fetch all wallpapers from all style directories
else
    wallpapers=("$wallpapersDir"/*)  # Fetch wallpapers from the specific style directory
fi

# Check if any wallpapers were found
if [ ${#wallpapers[@]} -eq 0 ]; then
    echo "No wallpapers found in $wallpapersDir"
    exit 1
fi

# Select a random wallpaper from the array
wallpaperIndex=$(( RANDOM % ${#wallpapers[@]} ))
selectedWallpaper="${wallpapers[$wallpaperIndex]}"

echo "Selected wallpaper: $selectedWallpaper"

# Update the wallpaper using the swww img command
# swww img "$selectedWallpaper"
swww img "$selectedWallpaper" --transition-type=center --transition-duration=1
