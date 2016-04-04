#!/bin/bash -e

# If a local git repo exists, update it. If it doesn't exist, clone a new repo
# in the expected location.
#
# Inputs:
#   $1 : path to remote git repository to clone/pull.
#   $2 : path to local git repository
git_clone_or_update(){
    if [ -d "$2" ]; then
        echo "Updating $2 from $1"
        cd $2
        git pull
        cd ~
    else
        echo "Cloning $1 into $2"
        git clone $1 $2
    fi
}

# Install vimrc.
VIMRC="$HOME/.vimrc"
if [ ! -e "$VIMRC" ]; then
    ln -s ~/dotfiles/vim/vimrc $VIMRC
fi

# Install flake8 configuration for vim-flake8.
FLAKE8_CONFIG="$HOME/.config/flake8"
if [ ! -e "$FLAKE8_CONFIG" ]; then
    ln -s ~/dotfiles/vim/flake8 $FLAKE8_CONFIG
fi

# Create necessary directories.
VIM_AUTOLOAD="$HOME/.vim/autoload"
VIM_BUNDLE="$HOME/.vim/bundle"
mkdir -p $VIM_AUTOLOAD $VIM_BUNDLE

# Install pathogen. Taken from:
#   https://github.com/tpope/vim-pathogen
curl -LSso "$VIM_AUTOLOAD/pathogen.vim" https://tpo.pe/pathogen.vim

# Lots of customizations taken from:
#   https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/

# Smart code folding in Python files.
git_clone_or_update https://github.com/tmhedberg/SimpylFold.git \
    "$VIM_BUNDLE/SimpylFold"

# Syntax checking.
git_clone_or_update https://github.com/scrooloose/syntastic.git \
    "$VIM_BUNDLE/syntastic"

# PEP8 checking in Python files.
git_clone_or_update https://github.com/nvie/vim-flake8.git \
    "$VIM_BUNDLE/vim-flake8"

# Make sure Python indenting conforms to PEP8.
git_clone_or_update https://github.com/vim-scripts/indentpython.vim.git \
    "$VIM_BUNDLE/indentpython.vim"

# Powerful searching from within vim.
git_clone_or_update https://github.com/ctrlpvim/ctrlp.vim.git \
    "$VIM_BUNDLE/ctrlp.vim"

# Awesome status bar.
git_clone_or_update https://github.com/vim-airline/vim-airline.git \
    "$VIM_BUNDLE/vim-airline"

# Column-align multiple lines.
git_clone_or_update https://github.com/vim-scripts/Align.git \
    "$VIM_BUNDLE/Align"

# Base16 colors in vim.
git_clone_or_update https://github.com/chriskempson/base16-vim.git \
    "$VIM_BUNDLE/base16-vim"
