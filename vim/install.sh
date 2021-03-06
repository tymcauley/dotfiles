#!/bin/bash -e

# Customize vim installation.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# Install vimrc.
install_file "$HOME/.vimrc" "$(pwd)/vimrc"

# Install Base16 color scheme for vim.
install_file "$HOME/.vimrc_background" "$(pwd)/vimrc_background"

# Create necessary directories for vim packages.
VIM_PKG_ROOT="$HOME/.vim/pack/plugins"
VIM_PKG_AUTO_LOAD="$VIM_PKG_ROOT/start"  # Packages in this folder are automatically loaded on vim startup.
VIM_PKG_MANUAL_LOAD="$VIM_PKG_ROOT/opt"  # Packages in this folder must be explicitly loaded using ':packadd'.
mkdir -p "$VIM_PKG_AUTO_LOAD" "$VIM_PKG_MANUAL_LOAD"

# Awesome status bar.
git_clone_or_update https://github.com/vim-airline/vim-airline.git "$VIM_PKG_AUTO_LOAD/vim-airline"

# Themes for awesome status bar.
git_clone_or_update https://github.com/vim-airline/vim-airline-themes.git "$VIM_PKG_AUTO_LOAD/vim-airline-themes"

# Add airline integration with the tmux status line.
git_clone_or_update https://github.com/edkolev/tmuxline.vim.git "$VIM_PKG_AUTO_LOAD/tmuxline.vim"

# Column-align multiple lines.
git_clone_or_update https://github.com/junegunn/vim-easy-align.git "$VIM_PKG_AUTO_LOAD/vim-easy-align"

# Base16 colors in vim.
git_clone_or_update https://github.com/chriskempson/base16-vim.git "$VIM_PKG_AUTO_LOAD/base16-vim"

# Allow user-defined text objects (needed for vim-textobj-line).
git_clone_or_update https://github.com/kana/vim-textobj-user.git "$VIM_PKG_AUTO_LOAD/vim-textobj-user"

# Make a new text object for the current line.
git_clone_or_update https://github.com/kana/vim-textobj-line.git "$VIM_PKG_AUTO_LOAD/vim-textobj-line"

# Make a new text object for lines at the same indent level.
git_clone_or_update https://github.com/michaeljsmith/vim-indent-object.git "$VIM_PKG_AUTO_LOAD/vim-indent-object"

# Add new vim "verb" for surrounding text objects.
git_clone_or_update https://github.com/tpope/vim-surround.git "$VIM_PKG_AUTO_LOAD/vim-surround"

# Add new vim "verb" for commenting out lines.
git_clone_or_update https://github.com/tpope/vim-commentary.git "$VIM_PKG_AUTO_LOAD/vim-commentary"

# Integration for fzf in vim.
git_clone_or_update https://github.com/junegunn/fzf.vim.git "$VIM_PKG_AUTO_LOAD/fzf.vim"

# Add ability to easily open new files up to a specific line/column.
git_clone_or_update https://github.com/kopischke/vim-fetch.git "$VIM_PKG_AUTO_LOAD/vim-fetch"

# Add ability to use dot operator (.) to repeat plugin map operations.
git_clone_or_update https://github.com/tpope/vim-repeat.git "$VIM_PKG_AUTO_LOAD/vim-repeat"

# Add nice integration with git.
git_clone_or_update https://github.com/tpope/vim-fugitive.git "$VIM_PKG_AUTO_LOAD/vim-fugitive"

# Latex integration.
git_clone_or_update https://github.com/lervag/vimtex.git "$VIM_PKG_AUTO_LOAD/vimtex"

# Rust integration.
git_clone_or_update https://github.com/rust-lang/rust.vim.git "$VIM_PKG_AUTO_LOAD/rust.vim"

# Improved vimdiff git mergetool.
git_clone_or_update https://github.com/whiteinge/diffconflicts "$VIM_PKG_AUTO_LOAD/diffconflicts"

# Asynchronous linting/fixing for Vim and Language Server Protocol (LSP) integration.
git_clone_or_update https://github.com/dense-analysis/ale.git "$VIM_PKG_AUTO_LOAD/ale"

# Git status in the sign column
git_clone_or_update https://github.com/airblade/vim-gitgutter.git "$VIM_PKG_AUTO_LOAD/vim-gitgutter"

cd - > /dev/null
