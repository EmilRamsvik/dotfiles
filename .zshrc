export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

ZSH_THEME="robbyrussell"


zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Source the external configuration files
source ~/dotfiles/zsh/alias.zsh
source ~/dotfiles/zsh/environment.zsh
source ~/dotfiles/zsh/plugins.zsh
source ~/dotfiles/zsh/functions.zsh
source ~/dotfiles/zsh/settings.zsh
source ~/dotfiles/zsh/local.zsh




export PATH="/usr/local/opt/python@3.12/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
