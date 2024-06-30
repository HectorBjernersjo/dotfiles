#!/bin/bash

# Check if the file is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <file_with_package_list>"
  exit 1
fi

PACKAGE_FILE="$1"

# Check if the file exists
if [ ! -f "$PACKAGE_FILE" ]; then
  echo "File not found: $PACKAGE_FILE"
  exit 1
fi

# Read package names from the file and install each one
while IFS= read -r package || [[ -n "$package" ]]; do
  if [[ ! -z "$package" ]]; then
    echo "Installing package: $package"
    yay -S --noconfirm "$package"
    if [ $? -ne 0 ]; then
      echo "Failed to install package: $package"
    fi
  fi
done < "$PACKAGE_FILE"

echo "All packages installed."

