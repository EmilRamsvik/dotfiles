# movement
alias ll='ls -l'
alias grep='grep --color'
alias u="cd .."
alias uu="cd ../.."
alias uuu="cd ../../.."
alias uuuu="cd ../../../.."

#shortcusts
alias dev="cd ~/Documents/dev"
alias nb="cd ~/Documents/notebooks"
alias admin="cd ~/Documents/admin"
alias emil="cd ~/Dropbox/Emil"
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias p="cd ~/Documents/Projects"


# development specific
alias gha="cd ./.github/workflows && ls"
alias lib="cd ./lib && ls" # flutter shortcut
alias gl="git status -v -v && git diff --name-status main..."
alias gp="git push"
alias lg="lazygit"


alias config="cd ~/dotfiles"
alias h="cd ~/"

#commands
alias l="ls -lF -G"
# List files colorized in long format, including dot files
alias la="ls -laF -G"
# List only directories
alias lsd="ls -lF -G | grep --color=never '^d'"
# Always use color output for `ls`
alias ls="command ls -G"
alias path='echo $PWD | pbcopy'



# Always enable colored `grep` output
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# programs
alias g="git"
alias ipy="ipython"
alias vim="nvim"
alias vi="nvim"
alias python="python3"
alias py="python3"
alias f='open -a Finder ./'

alias t="touch"
alias pbp="pbpaste"
alias clip="pbcopy <"

