#!/bin/bash -e

# Install vimrc.
ln -s ~/dotfiles/vim/vimrc ~/.vimrc

# Create necessary directories.
# TODO: Turn these into variables, use them later in the file.
mkdir -p ~/.vim/autoload ~/.vim/bundle ~/.vim/indent

# Install pathogen. Taken from:
#   https://github.com/tpope/vim-pathogen
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# Lots of customizations taken from:
#   https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/

# TODO: Check if this exists, if it does, the update it.
git clone https://github.com/tmhedberg/SimpylFold.git ~/.vim/bundle/SimpylFold

# TODO: Check if this exists, if it does, the update it.
git clone https://github.com/scrooloose/syntastic.git ~/.vim/bundle/syntastic

# TODO: Check if this exists, if it does, the update it.
git clone https://github.com/nvie/vim-flake8.git ~/.vim/bundle/vim-flake8

# TODO: Check if this exists, if it does, the update it.
git clone https://github.com/vim-scripts/indentpython.vim.git \
    ~/.vim/bundle/indentpython.vim

# TODO: Check if this exists, if it does, the update it.
git clone https://github.com/ctrlpvim/ctrlp.vim.git ~/.vim/bundle/ctrlp.vim

# TODO: Check if this exists, if it does, the update it.
git clone https://github.com/vim-airline/vim-airline.git \
    ~/.vim/bundle/vim-airline

# TODO: Check if this exists, if it does, the update it.
git clone https://github.com/vim-scripts/Align.git ~/.vim/bundle/Align

# TODO: Check if this exists, if it does, the update it.
git clone https://github.com/chriskempson/base16-vim.git \
    ~/.vim/bundle/base16-vim

# Install flake8 configuration for vim-flake8.
ln -s ~/dotfiles/vim/flake8 ~/.config/flake8
