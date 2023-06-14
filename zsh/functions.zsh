move_file_to_dir() {
    # Extract file name and extension
    file_name=$(basename "$1")
    base_name="${file_name%.*}"
    extension="${file_name##*.}"

    # Check if file exists before creating the directory and moving the file
    if [ -f "$file_name" ]; then
        # Create a directory with the base name if it does not exist
        if [ ! -d "$base_name" ]; then
            mkdir "$base_name"
        fi
        mv "$file_name" "$base_name"
        echo "Moved $file_name to directory $base_name."
    else
        echo "File $file_name does not exist."
    fi
}