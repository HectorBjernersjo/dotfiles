#!/bin/bash

# Check if a file name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <package_list_file>"
    exit 1
fi

# Check if the provided file exists
if [ ! -f "$1" ]; then
    echo "File not found: $1"
    exit 1
fi

# Read the package list from the file
PACKAGE_LIST=$(cat "$1")

# Update the package database
echo "Updating package database..."
sudo pacman -Sy

# Install each package
for PACKAGE in $PACKAGE_LIST; do
    echo "Installing package: $PACKAGE"
    sudo pacman -S --noconfirm $PACKAGE
done

echo "All packages have been installed."
