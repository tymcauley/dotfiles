#!/bin/bash -e

# Customize terminal configuration.
#   Alacritty: https://github.com/jwilm/alacritty

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# Install alacritty config file.
install_file "$HOME/.config/alacritty/alacritty.yml" "$(pwd)/alacritty.yml"

cd - > /dev/null
