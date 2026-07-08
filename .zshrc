# ============================================================================
# ZSH Configuration
# ============================================================================
# Main configuration file that sources all modular components
# Location: ~/.zshrc
# ============================================================================

DOTFILES_ZSH="${HOME}/dotfiles/zsh"

# ------------------------------------------------------------------------------
# Pre-Oh-My-Zsh setup
# ------------------------------------------------------------------------------
# Order matters: environment and the plugins array MUST be defined before
# oh-my-zsh.sh is sourced — OMZ reads $plugins at load time.

# Environment variables and PATH configuration
[ -f "${DOTFILES_ZSH}/environment.zsh" ] && source "${DOTFILES_ZSH}/environment.zsh"

# Plugin list and plugin configuration
[ -f "${DOTFILES_ZSH}/plugins.zsh" ] && source "${DOTFILES_ZSH}/plugins.zsh"

# ------------------------------------------------------------------------------
# Oh-My-Zsh
# ------------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

# Prompt is rendered by Starship (see ~/dotfiles/starship.toml).
# Fall back to the classic OMZ theme if starship isn't installed yet.
if command -v starship &> /dev/null; then
  ZSH_THEME=""
else
  ZSH_THEME="robbyrussell"
fi

# Update mode: reminder (will prompt when updates are available)
zstyle ':omz:update' mode reminder

source "$ZSH/oh-my-zsh.sh"

# ------------------------------------------------------------------------------
# Post-Oh-My-Zsh setup
# ------------------------------------------------------------------------------

# Shell settings and preferences
[ -f "${DOTFILES_ZSH}/settings.zsh" ] && source "${DOTFILES_ZSH}/settings.zsh"

# Custom functions
[ -f "${DOTFILES_ZSH}/functions.zsh" ] && source "${DOTFILES_ZSH}/functions.zsh"

# Aliases and shortcuts
[ -f "${DOTFILES_ZSH}/alias.zsh" ] && source "${DOTFILES_ZSH}/alias.zsh"

# Local overrides (machine-specific settings, not tracked in git)
[ -f "${DOTFILES_ZSH}/local.zsh" ] && source "${DOTFILES_ZSH}/local.zsh"

# ------------------------------------------------------------------------------
# Prompt
# ------------------------------------------------------------------------------
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
