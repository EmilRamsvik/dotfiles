# ============================================================================
# Plugins Configuration
# ============================================================================
# Oh-My-Zsh plugin list and plugin configuration.
# IMPORTANT: this file is sourced BEFORE oh-my-zsh.sh (see .zshrc) — OMZ reads
# the $plugins array at load time, so defining it later silently disables
# every plugin.
# Location: ~/dotfiles/zsh/plugins.zsh
# ============================================================================

# ------------------------------------------------------------------------------
# Plugin settings that must exist before the plugins load
# ------------------------------------------------------------------------------

# Lazy-load nvm: defers sourcing nvm.sh (~500ms+) until nvm/node/npm/npx is
# first used. NOTE: requires that no manual `source nvm.sh` block exists
# elsewhere, or the lazy loading silently does nothing.
zstyle ':omz:plugins:nvm' lazy yes

# Extra completion definitions (zsh-users/zsh-completions) must be on fpath
# before OMZ runs compinit.
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions/src" ]; then
  fpath+="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions/src"
fi

# ------------------------------------------------------------------------------
# Oh-My-Zsh Plugins
# ------------------------------------------------------------------------------
# Custom plugins (zsh-autosuggestions, zsh-syntax-highlighting, fzf-tab) are
# cloned into $ZSH_CUSTOM/plugins by setup.sh.
# Ordering: fzf-tab after compinit (OMZ guarantees this), syntax highlighting
# and autosuggestions last.

plugins=(
  # Git aliases and completion
  git

  # Docker command completion and aliases
  docker
  docker-compose

  # macOS specific commands and utilities
  macos

  # Python development
  python
  pip

  # Node.js — lazy-loaded via the zstyle above
  nvm
  node
  npm

  # Terraform completion
  terraform
)

_omz_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

# fzf keybindings: Ctrl+R fuzzy history, Ctrl+T file picker, Alt+C cd
command -v fzf &> /dev/null && plugins+=(fzf)

# Smarter cd with frecency ranking (z <dir>), replaces autojump
command -v zoxide &> /dev/null && plugins+=(zoxide)

# Tab completion through an fzf picker (custom plugin, needs fzf)
[ -d "${_omz_custom}/fzf-tab" ] && command -v fzf &> /dev/null && plugins+=(fzf-tab)

# Ghost-text suggestions from history as you type (custom plugin)
[ -d "${_omz_custom}/zsh-autosuggestions" ] && plugins+=(zsh-autosuggestions)

# Syntax highlighting (custom plugin, must be last)
[ -d "${_omz_custom}/zsh-syntax-highlighting" ] && plugins+=(zsh-syntax-highlighting)

unset _omz_custom

# ------------------------------------------------------------------------------
# Plugin Configurations
# ------------------------------------------------------------------------------

# fzf — use fd for file listing and brand-palette colors
if command -v fd &> /dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
export FZF_DEFAULT_OPTS="
  --height=50% --layout=reverse --border=rounded
  --color=bg+:#262626,fg:#FCF6EE,fg+:#FCF6EE,hl:#FF8C45,hl+:#FF8C45
  --color=pointer:#FF8C45,marker:#FFD24C,prompt:#97D2EC,border:#5C574F
  --color=info:#5C574F,spinner:#FFD24C,header:#97D2EC"

# fzf-tab — preview directory contents when completing cd/z
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -1 --color=always $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'ls -1 --color=always $realpath 2>/dev/null'

# zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#6E675E"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# zsh-syntax-highlighting
# Enable highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# Main highlighter styles — brand palette
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=#FFD24C,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#FFD24C,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#FFD24C,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#FFD24C,bold'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#E5604C'
ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=#FF8C45'
ZSH_HIGHLIGHT_STYLES[path]='fg=#97D2EC'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#97D2EC,bold'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#A9C47F'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#A9C47F'
