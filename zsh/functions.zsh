# ============================================================================
# Custom Functions
# ============================================================================
# Useful shell functions for common tasks
# Location: ~/dotfiles/zsh/functions.zsh
# ============================================================================

# ------------------------------------------------------------------------------
# Development Environment Functions
# ------------------------------------------------------------------------------

# Create and activate Python virtual environment
# Usage: venv [python_version]
# Example: venv 3.11
make_virtual_env() {
  local python_version="${1:-3}"

  # Determine python command
  if [ ! -z "$1" ]; then
    python_cmd="python$1"
  else
    python_cmd="python3"
  fi

  # Check if python version exists
  if ! command -v "$python_cmd" &> /dev/null; then
    echo "❌ Error: $python_cmd not found"
    return 1
  fi

  echo "📦 Creating virtual environment with $python_cmd..."
  $python_cmd -m venv .venv

  echo "🔌 Activating virtual environment..."
  source .venv/bin/activate

  echo "⬆️  Upgrading pip..."
  pip install --upgrade pip

  echo "✅ Virtual environment ready!"
  python --version
}
alias venv='make_virtual_env'

# Activate virtual environment if it exists in current directory
# Usage: va
activate_venv() {
  if [ -d ".venv" ]; then
    source .venv/bin/activate
    echo "✅ Virtual environment activated"
    python --version
  elif [ -d "venv" ]; then
    source venv/bin/activate
    echo "✅ Virtual environment activated"
    python --version
  else
    echo "❌ No virtual environment found (.venv or venv)"
    return 1
  fi
}
alias va='activate_venv'

# ------------------------------------------------------------------------------
# Directory and File Management
# ------------------------------------------------------------------------------

# Create directory and navigate into it
# Usage: mc <directory_name>
make_dir_and_go_to_it() {
  if [ -z "$1" ]; then
    echo "❌ Directory name is required"
    return 1
  fi

  mkdir -p "$1" && cd "$1"
  echo "✅ Created and entered directory: $1"
}
alias mc="make_dir_and_go_to_it"

# Move file to a directory with the same base name
# Usage: move <filename>
move_file_to_dir() {
  if [ -z "$1" ]; then
    echo "❌ Filename is required"
    return 1
  fi

  local file_name=$(basename "$1")
  local base_name="${file_name%.*}"

  if [ ! -f "$file_name" ]; then
    echo "❌ File $file_name does not exist"
    return 1
  fi

  if [ ! -d "$base_name" ]; then
    mkdir "$base_name"
    echo "📁 Created directory: $base_name"
  fi

  mv "$file_name" "$base_name"
  echo "✅ Moved $file_name to directory $base_name"
}
alias move=move_file_to_dir

# Extract various archive types
# Usage: extract <archive_file>
extract() {
  if [ -z "$1" ]; then
    echo "Usage: extract <archive_file>"
    return 1
  fi

  if [ ! -f "$1" ]; then
    echo "❌ File not found: $1"
    return 1
  fi

  case "$1" in
    *.tar.bz2)   tar xjf "$1"     ;;
    *.tar.gz)    tar xzf "$1"     ;;
    *.bz2)       bunzip2 "$1"     ;;
    *.rar)       unrar x "$1"     ;;
    *.gz)        gunzip "$1"      ;;
    *.tar)       tar xf "$1"      ;;
    *.tbz2)      tar xjf "$1"     ;;
    *.tgz)       tar xzf "$1"     ;;
    *.zip)       unzip "$1"       ;;
    *.Z)         uncompress "$1"  ;;
    *.7z)        7z x "$1"        ;;
    *)           echo "❌ Cannot extract '$1' - unknown format" ;;
  esac
}

# ------------------------------------------------------------------------------
# Editor Functions
# ------------------------------------------------------------------------------

# Open VS Code in current directory or specified path
# Usage: v [path]
execute_vscode() {
  if [ "$#" -eq 0 ]; then
    code .
  else
    code "$1"
  fi
}
alias v="execute_vscode"

# Open Cursor in current directory or specified path
# Usage: c [path]
execute_cursor() {
  if [ "$#" -eq 0 ]; then
    cursor .
  else
    cursor "$1"
  fi
}
alias c="execute_cursor"

# ------------------------------------------------------------------------------
# Git Helper Functions
# ------------------------------------------------------------------------------

# Create a new git branch and switch to it
# Usage: gnb <branch_name>
git_new_branch() {
  if [ -z "$1" ]; then
    echo "❌ Branch name is required"
    return 1
  fi

  git checkout -b "$1"
  echo "✅ Created and switched to branch: $1"
}
alias gnb='git_new_branch'

# Quick commit with message
# Usage: gq "commit message"
git_quick_commit() {
  if [ -z "$1" ]; then
    echo "❌ Commit message is required"
    return 1
  fi

  git add -A
  git commit -m "$1"
  echo "✅ Changes committed"
}
alias gq='git_quick_commit'

# ------------------------------------------------------------------------------
# Ollama Helper Functions
# ------------------------------------------------------------------------------

# Quick chat with Ollama model
# Usage: olc <model_name> [prompt]
# Example: olc llama3.2 "Hello, how are you?"
ollama_chat() {
  if [ -z "$1" ]; then
    echo "❌ Model name is required"
    echo "Available models:"
    ollama list
    return 1
  fi

  local model="$1"
  shift

  if [ -z "$*" ]; then
    # Interactive mode
    ollama run "$model"
  else
    # Single prompt mode
    echo "$*" | ollama run "$model"
  fi
}
alias olc='ollama_chat'

# Pull and run an Ollama model in one command
# Usage: olpr <model_name>
ollama_pull_run() {
  if [ -z "$1" ]; then
    echo "❌ Model name is required"
    return 1
  fi

  echo "📥 Pulling model: $1..."
  ollama pull "$1" && ollama run "$1"
}
alias olpr='ollama_pull_run'

# ------------------------------------------------------------------------------
# Network and System Functions
# ------------------------------------------------------------------------------

# Find process using a specific port
# Usage: port <port_number>
port() {
  if [ -z "$1" ]; then
    echo "❌ Port number is required"
    return 1
  fi

  lsof -i ":$1"
}

# Kill process on specific port
# Usage: killport <port_number>
killport() {
  if [ -z "$1" ]; then
    echo "❌ Port number is required"
    return 1
  fi

  lsof -ti ":$1" | xargs kill -9
  echo "✅ Killed process on port $1"
}

# ------------------------------------------------------------------------------
# Project Initialization Functions
# ------------------------------------------------------------------------------

# Initialize a new Python project with structure
# Usage: pyinit <project_name>
pyinit() {
  if [ -z "$1" ]; then
    echo "❌ Project name is required"
    return 1
  fi

  local project_name="$1"

  echo "📦 Creating Python project: $project_name"
  mkdir -p "$project_name"/{src,tests,docs}
  cd "$project_name"

  # Create basic files
  touch README.md
  touch requirements.txt
  touch .gitignore

  # Add Python gitignore
  cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
.venv/
venv/
ENV/
env/
EOF

  # Create basic README
  cat > README.md << EOF
# $project_name

## Installation

\`\`\`bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
\`\`\`

## Usage

TODO: Add usage instructions

## Development

TODO: Add development instructions
EOF

  echo "✅ Project structure created!"
  ls -la
}

# Initialize a new Node.js project with structure
# Usage: jsinit <project_name>
jsinit() {
  if [ -z "$1" ]; then
    echo "❌ Project name is required"
    return 1
  fi

  local project_name="$1"

  echo "📦 Creating Node.js project: $project_name"
  mkdir -p "$project_name"/{src,tests,public}
  cd "$project_name"

  # Initialize npm
  npm init -y

  # Create basic files
  touch README.md
  touch .gitignore

  # Add Node gitignore
  cat > .gitignore << 'EOF'
# Node
node_modules/
npm-debug.log
yarn-error.log
.env
.env.local
dist/
build/
*.log
.DS_Store
EOF

  echo "✅ Project structure created!"
  ls -la
}

echo "✓ Functions loaded"
