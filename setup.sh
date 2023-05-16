#!/bin/zsh
if test ! $(which brew); then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Install packages from Brewfile
echo "Installing packages homebrew from brewfile..."
brew bundle


# link to files in the github repo to make the symbolic links
ZSHRC_SOURCE=~/dotfiles/.zshrc
KARABINER_SOURCE=~/dotfiles/.config/karabiner.edn
LUA_SOURCE=~/dotfiles/nvim


# Define the target files
ZSHRC_TARGET=~/.zshrc
KARABINER_TARGET=~/.config/karabiner.edn
LUA_TARGET=~/.config/nvim

# Function to create symbolic links
create_symlink() {
    local source=$1
    local target=$2
    local replace=$3

    if [[ -e $target && $replace == "false" ]]; then
        echo "Warning: $target already exists."
        read -q "response?Do you want to replace it (y/n)? "
        echo
        if [[ $response =~ ^[Yy]$ ]]; then
            ln -sf $source $target
            echo "Replaced $target with $source"
        else
            echo "Aborted!"
        fi
    else
        ln -s $source $target
        echo "Linked $target to $source"
    fi
    
}

# Create the symbolic links
create_symlink $ZSHRC_SOURCE $ZSHRC_TARGET "false"
create_symlink $KARABINER_SOURCE $KARABINER_TARGET "false"
create_symlink $LUA_SOURCE $LUA_TARGET "false"

# Install the plugins
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
echo "Installing plugins..."
zsh -c "source ~/.zshrc && zinit self-update && zinit update --all"


echo "Running Goku..."
goku


# neovim configs
git clone https://github.com/wbthomason/packer.nvim ~/dotfiles/nvim/pack/packer/start/packer.nvim
echo "Installing neovim plugins..."
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
