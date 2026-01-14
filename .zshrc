# ============================================================================
# ZSH Configuration
# ============================================================================
# Main configuration file that sources all modular components
# Location: ~/.zshrc
# ============================================================================

# ------------------------------------------------------------------------------
# Oh-My-Zsh Configuration
# ------------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

# Update mode: reminder (will prompt when updates are available)
zstyle ':omz:update' mode reminder

# Load Oh-My-Zsh
source $ZSH/oh-my-zsh.sh

# ------------------------------------------------------------------------------
# Load Modular Configuration Files
# ------------------------------------------------------------------------------
# Order matters: environment → settings → plugins → functions → aliases → local

DOTFILES_ZSH="${HOME}/dotfiles/zsh"

# Environment variables and PATH configuration
[ -f "${DOTFILES_ZSH}/environment.zsh" ] && source "${DOTFILES_ZSH}/environment.zsh"

# Shell settings and preferences
[ -f "${DOTFILES_ZSH}/settings.zsh" ] && source "${DOTFILES_ZSH}/settings.zsh"

# Plugin configuration
[ -f "${DOTFILES_ZSH}/plugins.zsh" ] && source "${DOTFILES_ZSH}/plugins.zsh"

# Custom functions
[ -f "${DOTFILES_ZSH}/functions.zsh" ] && source "${DOTFILES_ZSH}/functions.zsh"

# Aliases and shortcuts
[ -f "${DOTFILES_ZSH}/alias.zsh" ] && source "${DOTFILES_ZSH}/alias.zsh"

# Local overrides (machine-specific settings, not tracked in git)
[ -f "${DOTFILES_ZSH}/local.zsh" ] && source "${DOTFILES_ZSH}/local.zsh"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
