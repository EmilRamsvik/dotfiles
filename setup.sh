#!/bin/zsh

# Exit on error, undefined variables, and pipe failures
set -e
set -u
set -o pipefail

if test ! $(which brew); then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> "${HOME}/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# Install packages from Brewfile
echo "Installing packages homebrew from brewfile..."
brew bundle

# Install Oh-My-Zsh if not already installed
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
  echo "Installing Oh-My-Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh-My-Zsh already installed"
fi

# link to files in the github repo to make the symbolic links
DOTFILES_DIR="${HOME}/dotfiles"
ZSHRC_SOURCE="${DOTFILES_DIR}/.zshrc"
KARABINER_SOURCE="${DOTFILES_DIR}/Karabiner/karabiner.edn"

GITCONFIG_SOURCE="${DOTFILES_DIR}/gitconfig"
GITCONFIG_TARGET="${HOME}/.gitconfig"

# Define the target files
ZSHRC_TARGET="${HOME}/.zshrc"
KARABINER_TARGET="${HOME}/.config/karabiner.edn"

# Function to create symbolic links
create_symlink() {
    local source=$1
    local target=$2
    local replace=$3

    # Create parent directory if it doesn't exist
    local target_dir=$(dirname "$target")
    if [ ! -d "$target_dir" ]; then
        echo "Creating directory: $target_dir"
        mkdir -p "$target_dir"
    fi

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
        rm -f $target
        ln -s $source $target
        echo "Linked $target to $source"
    fi

}

# Create the symbolic links
echo "💻 Zsh"
create_symlink $ZSHRC_SOURCE $ZSHRC_TARGET "true"
echo "🖱️ Karabiner"
create_symlink $KARABINER_SOURCE $KARABINER_TARGET "true"
echo "📝 Git config"
create_symlink $GITCONFIG_SOURCE $GITCONFIG_TARGET "false"
echo "🚀 Zed configuration"
create_symlink "${DOTFILES_DIR}/zed/settings.json" "${HOME}/.config/zed/settings.json" "true"
create_symlink "${DOTFILES_DIR}/zed/keymap.json" "${HOME}/.config/zed/keymap.json" "true"
echo "🔨 Hammerspoon"
create_symlink "${DOTFILES_DIR}/hammerspoon" "${HOME}/.hammerspoon" "true"
echo "👻 Ghostty"
create_symlink "${DOTFILES_DIR}/ghostty/config" "${HOME}/.config/ghostty/config" "true"
create_symlink "${DOTFILES_DIR}/ghostty/themes" "${HOME}/.config/ghostty/themes" "true"
echo "🚀 Starship prompt"
create_symlink "${DOTFILES_DIR}/starship.toml" "${HOME}/.config/starship.toml" "true"

# Install Oh-My-Zsh custom plugins (referenced in zsh/plugins.zsh)
ZSH_CUSTOM="${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"
clone_omz_plugin() {
    local repo=$1
    local name=$(basename "$repo")
    if [ ! -d "${ZSH_CUSTOM}/plugins/${name}" ]; then
        echo "Installing zsh plugin: ${name}"
        git clone --depth=1 "https://github.com/${repo}" "${ZSH_CUSTOM}/plugins/${name}"
    else
        echo "zsh plugin already installed: ${name}"
    fi
}
clone_omz_plugin "zsh-users/zsh-autosuggestions"
clone_omz_plugin "zsh-users/zsh-syntax-highlighting"
clone_omz_plugin "zsh-users/zsh-completions"
clone_omz_plugin "Aloxaf/fzf-tab"

echo "Creating a folder structure"
"${DOTFILES_DIR}/create_folders.sh"

echo "Running Goku..."
goku

# Keep goku watching karabiner.edn so edits apply on save
echo "Starting Goku watch service..."
brew services start goku
