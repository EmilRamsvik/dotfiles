# ============================================================================
# Environment Configuration
# ============================================================================
# PATH configuration and environment variables
# Location: ~/dotfiles/zsh/environment.zsh
# ============================================================================

# ------------------------------------------------------------------------------
# Core PATH Configuration
# ------------------------------------------------------------------------------

# Ensures user-installed binaries take precedence over system binaries
export PATH="/usr/local/bin:$PATH"

# Homebrew (sets PATH, MANPATH, etc.)
if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ------------------------------------------------------------------------------
# Programming Languages
# ------------------------------------------------------------------------------

# Python
export PATH="/usr/local/opt/python@3.12/bin:$PATH"
export PATH="$HOME/Library/Python/3.x/bin:$PATH"

# Java
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"

# Node.js (NVM) — do NOT source nvm.sh here! The OMZ nvm plugin lazy-loads it
# (see plugins.zsh); a manual source would defeat the lazy loading and add
# ~500ms to every shell startup.
export NVM_DIR="$HOME/.nvm"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Go (if installed)
if [ -d "/usr/local/go/bin" ]; then
  export PATH="/usr/local/go/bin:$PATH"
  export GOPATH="$HOME/go"
  export PATH="$GOPATH/bin:$PATH"
fi

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ------------------------------------------------------------------------------
# Python Environment Management
# ------------------------------------------------------------------------------

# Pipenv - create virtualenvs in project directory
export PIPENV_VENV_IN_PROJECT=1

# UV - Python package installer (faster alternative to pip)
export UV_PYTHON_PREFERENCE="managed"

# ------------------------------------------------------------------------------
# Editor Configuration
# ------------------------------------------------------------------------------

export EDITOR="cursor"
export VISUAL="cursor"

# ------------------------------------------------------------------------------
# Application Configuration
# ------------------------------------------------------------------------------

# GPG
export GPG_TTY=$(tty)

# Less - better defaults for the pager
export LESS="-R -F -X"

# bat as man-page pager (syntax-highlighted man pages)
if command -v bat &> /dev/null; then
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=50000
export SAVEHIST=50000

# ------------------------------------------------------------------------------
# Ollama Configuration
# ------------------------------------------------------------------------------

# Ollama API endpoint (default is localhost)
export OLLAMA_HOST="http://localhost:11434"

# Ollama models directory (optional, uncomment if needed)
# export OLLAMA_MODELS="$HOME/.ollama/models"

# ------------------------------------------------------------------------------
# Cloud Provider CLI Tools
# ------------------------------------------------------------------------------

# AWS
if [ -d "$HOME/.aws" ]; then
  export AWS_CONFIG_FILE="$HOME/.aws/config"
  export AWS_SHARED_CREDENTIALS_FILE="$HOME/.aws/credentials"
fi

# Google Cloud SDK
if [ -d "$HOME/google-cloud-sdk" ]; then
  source "$HOME/google-cloud-sdk/path.zsh.inc"
  source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi
