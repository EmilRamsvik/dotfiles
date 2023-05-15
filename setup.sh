#!/bin/zsh


# link to files in the github repo to make the symbolic links
ZSHRC_SOURCE=~/dotfiles/.zshrc
KARABINER_SOURCE=~/dotfiles/.config/karabiner.edn


# Define the target files
ZSHRC_TARGET=~/.zshrc
KARABINER_TARGET=~/.config/karabiner.edn

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
#!/bin/zsh

# Check if Goku is installed
if ! command -v goku &> /dev/null
then
    echo "Goku is not installed. Installing now..."
    brew install yqrashawn/goku/goku
fi

# Run Goku
echo "Running Goku..."
goku


# Install the plugins
echo "Installing plugins..."
zsh -c "source ~/.zshrc && zinit self-update && zinit update --all"


