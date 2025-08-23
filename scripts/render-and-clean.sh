#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- A. Determine script and project paths ---
# A robust way to get the absolute path of the script's directory.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Assuming the project root is one level up from the script directory.
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# --- B. Define file and directory names ---
# Get the filename from the first argument (e.g., presentations/01_Introduction.qmd).
FILE_PATH="$1"
# Get the file's name and directory, relative to the project root.
FILE_BASENAME_NO_EXTENSION=$(basename "$FILE_PATH" .qmd) # e.g., '01_Introduction'
FILE_DIRNAME=$(dirname "$FILE_PATH") # e.g., 'presentations'

# Define target directories using absolute paths.
SRV_DIR="$PROJECT_ROOT/srv"
DIST_DIR="$PROJECT_ROOT/dist"

# --- C. Core workflow ---
# 1. Create the srv and dist directories in the project root.
echo "Ensuring '$SRV_DIR' and '$DIST_DIR' directories exist..."
mkdir -p "$SRV_DIR"
mkdir -p "$DIST_DIR"

# 2. Render the Quarto document. Quarto will use the output paths in the YAML file.
echo "Rendering '$FILE_PATH'..."
quarto render "$FILE_PATH"

# 3. Move the rendered files from the subdirectory to the srv/ root for zipping.
# This corrects Quarto's default behavior of adding the 'presentations' subdirectory.
QUARTO_OUTPUT_HTML_FILE="$SRV_DIR/$FILE_DIRNAME/${FILE_BASENAME_NO_EXTENSION}.html"
QUARTO_OUTPUT_FILES_DIR="$SRV_DIR/$FILE_DIRNAME/${FILE_BASENAME_NO_EXTENSION}_files"
SRV_HTML_FILE="$SRV_DIR/${FILE_BASENAME_NO_EXTENSION}.html"
SRV_FILES_DIR="$SRV_DIR/${FILE_BASENAME_NO_EXTENSION}_files"

echo "Moving output files from '$SRV_DIR/$FILE_DIRNAME' to '$SRV_DIR'..."
if [ -f "$QUARTO_OUTPUT_HTML_FILE" ]; then
    mv "$QUARTO_OUTPUT_HTML_FILE" "$SRV_DIR/"
    if [ -d "$QUARTO_OUTPUT_FILES_DIR" ]; then
        mv "$QUARTO_OUTPUT_FILES_DIR" "$SRV_DIR/"
    fi
fi

# 4. Package the output from srv into a zip file and place it in the dist directory.
ZIP_FILE_PATH="$DIST_DIR/${FILE_BASENAME_NO_EXTENSION}.zip"

echo "Creating zip file '$ZIP_FILE_PATH' for LMS distribution..."
if [ -f "$SRV_HTML_FILE" ]; then
    (
        cd "$SRV_DIR"
        zip -r "../$ZIP_FILE_PATH" "${FILE_BASENAME_NO_EXTENSION}.html" "${FILE_BASENAME_NO_EXTENSION}_files"
    )
    echo "Successfully created zip file: $ZIP_FILE_PATH"
else
    echo "Error: HTML file '$SRV_HTML_FILE' not found. Skipping zip creation."
fi

# 5. Clean up the rendered files and temporary folders.
echo "Cleaning up temporary files from '$SRV_DIR' and '$FILE_DIRNAME'..."
rm -f "$SRV_HTML_FILE"
rm -rf "$SRV_FILES_DIR"
rm -rf "$SRV_DIR/$FILE_DIRNAME" # Cleans up the empty subdirectory left by Quarto
rm -f "$PROJECT_ROOT/$FILE_DIRNAME/.gitignore"
rm -rf "$PROJECT_ROOT/$FILE_DIRNAME/${FILE_BASENAME_NO_EXTENSION}_files"

echo "Rendering, zipping, and cleanup complete. 🎉"