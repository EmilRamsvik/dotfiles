# ============================================================================
# ZSH Settings Configuration
# ============================================================================
# Shell behavior and completion settings
# Location: ~/dotfiles/zsh/settings.zsh
# ============================================================================

# ------------------------------------------------------------------------------
# Case Sensitivity
# ------------------------------------------------------------------------------

# Case-insensitive completion
CASE_SENSITIVE="false"

# Case-insensitive matching for completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# ------------------------------------------------------------------------------
# Completion System
# ------------------------------------------------------------------------------

# Enable completion system
autoload -Uz compinit
compinit

# Use menu selection for completion
zstyle ':completion:*' menu select

# Enable approximate completion
zstyle ':completion:*' completer _expand _complete _correct _approximate

# Group matches and describe
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'

# Colors in completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Case-insensitive (all), partial-word, and substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Cache completions for faster loading
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zsh_cache"

# ------------------------------------------------------------------------------
# History Configuration
# ------------------------------------------------------------------------------

# History options
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits
setopt SHARE_HISTORY             # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file
setopt HIST_VERIFY               # Do not execute immediately upon history expansion

# ------------------------------------------------------------------------------
# Directory Navigation
# ------------------------------------------------------------------------------

# Change directory without typing 'cd'
setopt AUTO_CD

# Push the old directory onto the directory stack
setopt AUTO_PUSHD

# Do not push multiple copies of the same directory onto the directory stack
setopt PUSHD_IGNORE_DUPS

# Do not print the directory stack after pushd or popd
setopt PUSHD_SILENT

# ------------------------------------------------------------------------------
# Globbing and Expansion
# ------------------------------------------------------------------------------

# Extended globbing (advanced pattern matching)
setopt EXTENDED_GLOB

# Do not error if a glob pattern doesn't match anything
setopt NULL_GLOB

# Sort numeric filenames numerically
setopt NUMERIC_GLOB_SORT

# ------------------------------------------------------------------------------
# Correction and Suggestions
# ------------------------------------------------------------------------------

# Enable command correction
setopt CORRECT

# Disable correction for arguments
unsetopt CORRECT_ALL

# ------------------------------------------------------------------------------
# Job Control
# ------------------------------------------------------------------------------

# Report status of background jobs immediately
setopt NOTIFY

# Don't hang up background jobs when shell exits
setopt NO_HUP

# Report the status of background jobs immediately, rather than waiting until just before printing a prompt
setopt NOTIFY

# ------------------------------------------------------------------------------
# Input/Output
# ------------------------------------------------------------------------------

# Allow comments in interactive shell
setopt INTERACTIVE_COMMENTS

# Do not beep on errors
setopt NO_BEEP

# Enable vi mode (optional - comment out if you prefer emacs mode)
# bindkey -v

# Keep emacs keybindings (default)
bindkey -e

# Use Ctrl+Z to toggle between suspend and resume
function ctrlz() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
    zle redisplay
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N ctrlz
bindkey '^Z' ctrlz

# ------------------------------------------------------------------------------
# Key Bindings
# ------------------------------------------------------------------------------

# Better history searching with arrow keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search    # Up arrow
bindkey "^[[B" down-line-or-beginning-search  # Down arrow

# Use Ctrl+Left/Right to move between words
bindkey "^[[1;5C" forward-word   # Ctrl+Right
bindkey "^[[1;5D" backward-word  # Ctrl+Left

# Use Ctrl+Backspace to delete word
bindkey '^H' backward-kill-word

echo "✓ Settings loaded"
