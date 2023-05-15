
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

ZSH_THEME="robbyrussell"
# zinit (formerly zplugin) initialization
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Source the external configuration files
source ~/dotfiles/zsh/alias.zsh
source ~/dotfiles/zsh/environment.zsh
source ~/dotfiles/zsh/plugins.zsh
source ~/dotfiles/zsh/functions.zsh
source ~/dotfiles/zsh/settings.zsh




# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
