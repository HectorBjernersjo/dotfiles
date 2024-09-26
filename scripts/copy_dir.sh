#!/bin/bash

# Function to display usage
function usage() {
    echo "Usage: $0 source_directory destination_directory"
    exit 1
}

# Check if correct number of arguments are passed
if [ "$#" -ne 2 ]; then
    usage
fi

# Assign arguments to variables
SOURCE_DIR=$1
DESTINATION_DIR=$2

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory $SOURCE_DIR does not exist!"
    exit 1
fi

# Check if destination directory exists
if [ ! -d "$DESTINATION_DIR" ]; then
    echo "Destination directory $DESTINATION_DIR does not exist!"
    exit 1
fi

# Extract the directory name (basename) from the source directory path
DIR_NAME=$(basename "$SOURCE_DIR")

# Create a zip file of the source directory
ZIP_FILE="${DIR_NAME}.zip"
echo "Zipping the directory..."
zip -r "$ZIP_FILE" "$SOURCE_DIR"

# Move the zip file to the destination directory
echo "Moving the zip file to the destination..."
mv "$ZIP_FILE" "$DESTINATION_DIR"

# Unzip the file in the destination directory
echo "Unzipping in the destination directory..."
unzip "$DESTINATION_DIR/$ZIP_FILE" -d "$DESTINATION_DIR"

# Remove the zip file after extraction
echo "Cleaning up the zip file..."
rm "$DESTINATION_DIR/$ZIP_FILE"

echo "Process complete! Directory has been moved and unzipped."
