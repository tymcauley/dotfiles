#!/bin/bash -e

# Customize neovim installation.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# Install neovim package manager if it isn't present.
if [[ ! -d "$HOME/.local/share/nvim/site/pack/packer/opt/packer.nvim" ]]; then
    git clone https://github.com/wbthomason/packer.nvim "$HOME/.local/share/nvim/site/pack/packer/opt/packer.nvim"
fi

# Install neovim config file.
install_file "$HOME/.config/nvim/init.lua" "$(pwd)/init.lua"

# Install lua config files.
install_dir "$HOME/.config/nvim/lua" "$(pwd)/lua"

# Install syntax override files.
install_dir "$HOME/.config/nvim/after/ftplugin" "$(pwd)/after/ftplugin"

cd - > /dev/null
