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
    npm install -g $program_name
done

# Update node packages
npm update -g

cd - > /dev/null
