#!/bin/bash

# Directory containing the images
IMAGE_DIR=.

# Check if the required tools are installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick's 'convert' is required but not installed. Install it and try again."
    exit 1
fi

if ! command -v chafa &> /dev/null; then
    echo "'chafa' is required but not installed. Install it and try again."
    exit 1
fi

# List all image files in the directory and use fzf to select
selected_image=$(find "$IMAGE_DIR" -type f \( -iname \*.jpg -o -iname \*.png -o -iname \*.jpeg -o -iname \*.gif \) | \
    fzf --preview 'convert {} -resize 100x40\> - | chafa --colors 256 -' \
        --height=40% --layout=reverse --border)

# If an image was selected, show a larger preview in the terminal
if [[ -n "$selected_image" ]]; then
    clear
    convert "$selected_image" -resize 600x300\> - | chafa --colors 256 -
fi
