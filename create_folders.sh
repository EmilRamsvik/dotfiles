# create_folders.sh

#!/bin/bash

# Define the directories to create
directories=(
    "$HOME/Documents/dev"
    "$HOME/Documents/notebooks"
    "$HOME/Documents/admin"
    "$HOME/Documents/projects"
)

# Loop through the directories and create them if they don't exist
for dir in "${directories[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "Created directory: $dir"
    else
        echo "Directory already exists: $dir"
    fi
done