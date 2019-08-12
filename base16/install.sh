#!/bin/bash -e

# Install Base16 Shell.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# Install base16-shell.
git_clone_or_update https://github.com/chriskempson/base16-shell.git "$HOME/.config/base16-shell"

cd - > /dev/null
