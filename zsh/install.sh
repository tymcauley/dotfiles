#!/bin/bash -e

# Customize zsh installation

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions
source $DOTFILES_LIB

# Install oh-my-zsh
OMZ="$HOME/.oh-my-zsh"
if [[ ! -d "$OMZ" ]] ; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Make sure the custom fpath directory exists
FPATH_DIR="$OMZ/completions"
if [[ ! -e "$FPATH_DIR" ]] ; then
    mkdir "$FPATH_DIR"
fi

# Install powerline10k config file
install_file "$HOME/.p10k.zsh" "$(pwd)/p10k.zsh"

# Install zshrc
install_file "$HOME/.zshrc" "$(pwd)/zshrc"
install_file "$HOME/.config/git.zsh" "$(pwd)/git.zsh"

# Install/update oh-my-zsh add-ons
git_clone_or_update https://github.com/romkatv/powerlevel10k.git "$OMZ/custom/themes/powerlevel10k"
git_clone_or_update https://github.com/jeffreytse/zsh-vi-mode "$OMZ/custom/plugins/zsh-vi-mode"

cd - > /dev/null
