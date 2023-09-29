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

alias move=move_file_to_dir


# Define the function
make_virtual_env() {
  # Create a Python virtual environment
  python3 -m venv .venv

  # Activate the virtual environment
  source .venv/bin/activate

  # Upgrade pip
  pip install --upgrade pip

  # Print Python version
  python --version
}

# Create an alias
alias venv='make_virtual_env'
