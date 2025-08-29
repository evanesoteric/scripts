#!/bin/bash
#
# web root permissions (/var/www)

# Define the base directory where we want to begin our search for "perm.sh" scripts.
BASE_DIR="/var/www"

cd $BASE_DIR

# enforce permissions
find . -maxdepth 1 -type d -exec chown www-data:www-data {} +
find . -maxdepth 2 -type f -name "perm.sh" -exec chown root:root {} +
find . -maxdepth 2 -type f -name "perm.sh" -exec chmod 700 {} +

# Start a loop to iterate over all direct subdirectories within the BASE_DIR.
for dir in "${BASE_DIR}"/*/
do
    # For each subdirectory, construct the full path to the "perm.sh" script
    # within that subdirectory.
    script="${dir}perm.sh"

    # Check if the constructed path points to a regular file (i.e., the "perm.sh" script exists in that subdirectory).
    if [[ -f "$script" ]]; then
        # Using a subshell (denoted by the parentheses) to ensure that any directory change
        # with "cd" command doesn't affect our main script's current directory.
        (
            # Try to change the current directory to the subdirectory.
            # If unsuccessful (maybe due to permissions or a directory being removed),
            # the "continue" command will skip the rest of this loop iteration.
            cd "$dir" || continue

            # Execute the "perm.sh" script within its own directory.
            bash "perm.sh"
        )
    fi
    # If the "perm.sh" script doesn't exist in the current subdirectory, the loop simply
    # moves to the next subdirectory without doing anything.
done
