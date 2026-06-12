#!/bin/bash
###############################################################################
# Script: file_organizer.sh
# Purpose: Organize files in a target directory into subdirectories based on
#          their file extension.
#          .log -> logs/    .sh -> scripts/    .md -> docs/
# Usage:   ./file_organizer.sh [target_directory]
#          Defaults to current directory if no argument is given.
###############################################################################

set -euo pipefail
# -e: exit immediately if any command fails
# -u: treat unset variables as an error
# -o pipefail: a pipeline fails if any command within it fails

# ---- Configuration ----
TARGET_DIR="${1:-.}"   # Use arg1, or default to current directory

# Associative array (2D-style mapping): extension -> destination folder name
declare -A EXT_MAP=(
    [log]="logs"
    [sh]="scripts"
    [md]="docs"
)

# Associative array to track how many files were moved into each folder
declare -A MOVE_COUNT=(
    [logs]=0
    [scripts]=0
    [docs]=0
)

# ---- Process Files ----
for file in "$TARGET_DIR"/*; do
    # Skip if not a regular file (e.g. directories)
    [[ -f "$file" ]] || continue

    filename=$(basename "$file")
    ext="${filename##*.}"     # Strip everything up to the last '.' -> extension

    # Check if this extension has a mapped destination
    # ${EXT_MAP[$ext]:-} safely returns empty string if key doesn't exist
    # (avoids "unbound variable" error under set -u)
    if [[ -n "${EXT_MAP[$ext]:-}" ]]; then
        dest_dir="$TARGET_DIR/${EXT_MAP[$ext]}"
        mkdir -p "$dest_dir"          # Create destination dir if missing
        mv "$file" "$dest_dir/"       # Move the file
        ((MOVE_COUNT[${EXT_MAP[$ext]}]++))  # Increment counter for this folder
    fi
done

# ---- Print Summary ----
echo "=== File Organizer Summary ==="
for dir in "${!MOVE_COUNT[@]}"; do
    echo "$dir: ${MOVE_COUNT[$dir]} file(s) moved"
done
