#!/bin/bash

# Capture the selected region using grim and save it directly to a file
grim -g "$(slurp)" /tmp/image.png

# Use tesseract to extract text from the image and save it to a text file
tesseract /tmp/image.png /tmp/extracted_text

# Determine the display server and copy the text to the clipboard accordingly
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    # Use wl-copy for Wayland
    cat /tmp/extracted_text.txt | wl-copy
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
    # Use xclip for X11
    cat /tmp/extracted_text.txt | xclip -selection clipboard
else
    echo "Unsupported display server. Please use Wayland or X11."
    exit 1
fi

# Optional: Remove the temporary text file
rm /tmp/extracted_text.txt
