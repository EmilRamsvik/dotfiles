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
export PATH="/opt/homebrew/bin:$PATH"

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

# Node.js (NVM)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Go (if installed)
if [ -d "/usr/local/go/bin" ]; then
  export PATH="/usr/local/go/bin:$PATH"
  export GOPATH="$HOME/go"
  export PATH="$GOPATH/bin:$PATH"
fi

# ------------------------------------------------------------------------------
# Development Tools
# ------------------------------------------------------------------------------

# Flutter
if [ -d "$HOME/opt/homebrew/bin/flutter" ]; then
  export PATH="$PATH:$HOME/opt/homebrew/bin/flutter"
  export ENABLE_FLUTTER_DESKTOP="true"
fi

# Dart (usually included with Flutter)
if [ -d "$HOME/usr/local/opt/flutter/stable/bin/cache/dart-sdk" ]; then
  export PATH="$PATH:$HOME/usr/local/opt/flutter/stable/bin/cache/dart-sdk"
fi

# ------------------------------------------------------------------------------
# Python Environment Management
# ------------------------------------------------------------------------------

# Pipenv - create virtualenvs in project directory
if command -v pipenv &> /dev/null; then
  export PIPENV_VENV_IN_PROJECT=1
fi

# UV - Python package installer (faster alternative to pip)
if command -v uv &> /dev/null; then
  export UV_PYTHON_PREFERENCE="managed"
fi

# ------------------------------------------------------------------------------
# Editor Configuration
# ------------------------------------------------------------------------------

# Default editor
export EDITOR="cursor"
export VISUAL="cursor"

# ------------------------------------------------------------------------------
# Shell Enhancement Tools
# ------------------------------------------------------------------------------

# Autojump - quick directory navigation
if [ -f "$(brew --prefix)/etc/profile.d/autojump.sh" ]; then
  . "$(brew --prefix)/etc/profile.d/autojump.sh"
fi

# Thefuck - command correction tool
if command -v thefuck &> /dev/null; then
  eval $(thefuck --alias)
  eval $(thefuck --alias fk) # Shorter alias
fi

# ------------------------------------------------------------------------------
# Application Configuration
# ------------------------------------------------------------------------------

# Homebrew
if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# GPG
export GPG_TTY=$(tty)

# Less - better defaults for the pager
export LESS="-R -F -X"

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

# ------------------------------------------------------------------------------
# Performance Optimization
# ------------------------------------------------------------------------------

# Skip compinit for faster shell startup (zinit handles this)
skip_global_compinit=1

echo "✓ Environment configured"
