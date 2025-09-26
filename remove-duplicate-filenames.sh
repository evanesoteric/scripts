#!/bin/bash

# ==============================================================================
# WARNING: THIS SCRIPT PERMANENTLY DELETES FILES.
# USE AT YOUR OWN RISK. ALWAYS HAVE A BACKUP.
#
# By default, it runs in DRY RUN mode. It will only show what it *would* do.
# To actually delete files, you must run the script with the --delete flag:
# ./remove-duplicate-filenames.sh --delete
# ==============================================================================

# --- Configuration ---
TARGET_DIR="$HOME/Music"

# --- Safety Checks and Argument Parsing ---
DRY_RUN=true
if [[ "$1" == "--delete" ]]; then
  DRY_RUN=false
fi

# Use ANSI color codes for warnings
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

if [ ! -d "$TARGET_DIR" ]; then
  echo -e "${RED}Error: Directory '$TARGET_DIR' does not exist.${NC}"
  exit 1
fi

# Final confirmation if we are in delete mode
if [ "$DRY_RUN" = false ]; then
  echo -e "${RED}WARNING: You are in live delete mode.${NC}"
  read -p "This will permanently delete files in '$TARGET_DIR'. Are you absolutely sure? (y/N) " confirm
  # Default to 'no' if user just hits Enter
  if [[ ! "$confirm" =~ ^[yY]([eE][sS])?$ ]]; then
    echo "Aborting operation. No files were deleted."
    exit 0
  fi
else
  echo -e "${YELLOW}Running in DRY RUN mode. No files will be deleted.${NC}"
  echo "To delete files, run this script with the --delete flag."
fi

echo # Spacer
echo "Starting scan for duplicate filenames..."
echo

# --- Main Logic ---

# Get a unique list of filenames that appear more than once
find "$TARGET_DIR" -type f -printf "%f\n" | sort | uniq -d | while read -r filename; do
  
  # Skip empty lines, just in case
  if [[ -z "$filename" ]]; then
    continue
  fi

  echo "--- Processing duplicates for: '$filename' ---"

  # Find all paths for the current duplicate filename and store them in an array, sorted.
  # Sorting provides a predictable order, so we always keep the "first" one alphabetically.
  mapfile -t paths < <(find "$TARGET_DIR" -type f -name "$filename" | sort)

  # The first item in the sorted array is the one we will keep.
  keep_file="${paths[0]}"
  
  if [ "$DRY_RUN" = true ]; then
    echo -e "${GREEN}WOULD KEEP:  ${keep_file}${NC}"
  else
    echo -e "${GREEN}KEEPING:     ${keep_file}${NC}"
  fi

  # Loop through the rest of the array (from the second item) to delete them.
  for (( i=1; i<${#paths[@]}; i++ )); do
    delete_file="${paths[$i]}"
    if [ "$DRY_RUN" = true ]; then
      echo -e "${YELLOW}WOULD DELETE:${delete_file}${NC}"
    else
      echo -e "${RED}DELETING:    ${delete_file}${NC}"
      rm "$delete_file"
    fi
  done
  echo # Add a blank line for readability

done

echo "Scan complete."
