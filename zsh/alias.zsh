# ============================================================================
# Aliases Configuration
# ============================================================================
# Shell aliases for common commands and shortcuts
# Location: ~/dotfiles/zsh/alias.zsh
# ============================================================================

# ------------------------------------------------------------------------------
# Navigation Shortcuts
# ------------------------------------------------------------------------------

# Quick directory navigation (up levels)
alias u="cd .."
alias uu="cd ../.."
alias uuu="cd ../../.."
alias uuuu="cd ../../../.."

# Common directories
alias dev="cd ~/Documents/dev"
alias nb="cd ~/Documents/notebooks"
alias admin="cd ~/Documents/admin"
alias p="cd ~/Documents/projects"
alias emil="cd ~/Dropbox/Emil"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias dot="cd ~/dotfiles"
alias h="cd ~/"

# ------------------------------------------------------------------------------
# Git Shortcuts
# ------------------------------------------------------------------------------

alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gpl="git pull"
alias gd="git diff"
alias gb="git branch"
alias gco="git checkout"
alias gl="git status -v -v && git diff --name-status main..."
alias gha="cd ./.github/workflows && ls"
alias lg="lazygit"

# ------------------------------------------------------------------------------
# File Operations
# ------------------------------------------------------------------------------

# Listing — eza (modern ls with colors, icons, git status) when available
if command -v eza &> /dev/null; then
  alias l="eza -l --icons --git --group-directories-first"
  alias ll="eza -l --icons --git --group-directories-first"
  alias la="eza -la --icons --git --group-directories-first"
  alias lt="eza --tree --level=2 --icons"
  alias lsd="eza -lD --icons"
else
  alias l="ls -lF -G"
  alias ll="ls -l"
  alias la="ls -laF -G"
  alias lsd="ls -lF -G | grep --color=never '^d'"
fi

# bat — cat with syntax highlighting and git integration
if command -v bat &> /dev/null; then
  alias cat="bat --paging=never"
  alias catp="command cat"  # plain cat when you need it
fi

# File manipulation
alias t="touch"
alias path='echo $PWD | pbcopy'
alias f='open -a Finder ./'

# ------------------------------------------------------------------------------
# Grep with Color
# ------------------------------------------------------------------------------

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ------------------------------------------------------------------------------
# Development Tools
# ------------------------------------------------------------------------------

# Python
alias python="python3"
alias py="python3"
alias ipy="ipython"

# Clipboard
alias clip="pbcopy <"

# AI/ML Tools
alias ol="ollama"
alias olrun="ollama run"
alias ollist="ollama list"
alias olps="ollama ps"
alias cc="claude"

# ------------------------------------------------------------------------------
# System Shortcuts
# ------------------------------------------------------------------------------

# Quick reload of shell configuration
alias reload="source ~/.zshrc"
alias zshrc="$EDITOR ~/.zshrc"

# Disk usage
alias du="du -h"
alias df="df -h"

# Process management
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"

# Network
alias myip="curl ifconfig.me"
alias localip="ipconfig getifaddr en0"

# ------------------------------------------------------------------------------
# Docker Shortcuts
# ------------------------------------------------------------------------------

alias d="docker"
alias dc="docker-compose"
alias dps="docker ps"
alias dpsa="docker ps -a"
alias di="docker images"
alias dex="docker exec -it"
alias dlog="docker logs -f"
