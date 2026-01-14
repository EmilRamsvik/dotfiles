# ============================================================================
# Plugins Configuration
# ============================================================================
# Oh-My-Zsh plugins and additional plugin configurations
# Location: ~/dotfiles/zsh/plugins.zsh
# ============================================================================

# ------------------------------------------------------------------------------
# Oh-My-Zsh Plugins
# ------------------------------------------------------------------------------

plugins=(
  # Git integration
  git

  # Docker command completion and aliases
  docker
  docker-compose

  # macOS specific commands and utilities
  macos

  # Python development
  python
  pip

  # Node.js and npm
  node
  npm

  # Terraform
  terraform

  # Command suggestions as you type
  zsh-autosuggestions

  # Command correction tool
  thefuck

  # Quick directory navigation
  autojump

  # Syntax highlighting (should be last)
  zsh-syntax-highlighting
)

# ------------------------------------------------------------------------------
# Plugin Configurations
# ------------------------------------------------------------------------------

# zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# zsh-syntax-highlighting
# Enable highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# Main highlighter styles
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue'

echo "✓ Plugins configured"
