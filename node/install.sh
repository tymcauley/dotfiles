#!/bin/bash -e

# Customize NodeJS configuration.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# Install node packages
NODE_PACKAGES="\
neovim \
pyright \
"

for program_name in $NODE_PACKAGES ; do
    if ! command -v $program_name > /dev/null 2>&1 ; then
        npm install -g $program_name
    fi
done

cd - > /dev/null
