
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

ZSH_THEME="robbyrussell"

# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Source the external configuration files
source ~/dotfiles/zsh/alias.zsh
source ~/dotfiles/zsh/environment.zsh
source ~/dotfiles/zsh/plugins.zsh
source ~/dotfiles/zsh/functions.zsh
source ~/dotfiles/zsh/settings.zsh
source ~/dotfiles/zsh/paths.zsh



