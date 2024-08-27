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
  # Default Python version
  python_version="python3"

  # Check if Python version argument is provided
  if [ ! -z "$1" ]; then
    python_version="python$1"
  fi

  # Create a Python virtual environment
  $python_version -m venv .venv

  # Activate the virtual environment
  source .venv/bin/activate

  # Upgrade pip
  pip install --upgrade pip

  # Print Python version
  python --version
}

# Create an alias
alias venv='make_virtual_env'


execute_zed() {
  if [ "$#" -eq 0 ]; then
    zed .
  else
    zed "$1"
  fi
}

alias z="execute_zed"

execute_vscode() {
  if [ "$#" -eq 0 ]; then
    code .
  else
    code "$1"
  fi
}

alias c="execute_vscode"



make_dir_and_go_to_it() {
  # Check if directory name is provided
  if [ -z "$1" ]; then
    echo "Directory name is required."
    return 1
  fi

  # Create a directory
  mkdir "$1"

  # Go to the directory
  cd "$1"
}

alias mdc="make_dir_and_go_to_it"
