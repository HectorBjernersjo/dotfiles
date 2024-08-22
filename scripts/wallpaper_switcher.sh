#!/bin/bash
wallpapersDir="$HOME/dotfiles/wallpapers/$1"
echo "Wallpaper directory: $wallpapersDir"

# Use globbing to correctly expand the files in the directory
wallpapers=("$wallpapersDir"/*)

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
swww img $selectedWallpaper --transition-type=random --transition-duration=1
