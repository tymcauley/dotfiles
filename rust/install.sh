#!/bin/bash -e

# Install Rust.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# If Rust isn't installed, install it.
if ! command -v rustup > /dev/null 2>&1 ; then
    iecho "Rust not detected, installing it"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path -y
    eecho "Rust has been installed. Please add it to your PATH before continuing."
    exit 2
fi

# Install Rust components (clippy, rustfmt, and RLS).
rustup component add \
    clippy \
    rls \
    rust-analysis \
    rust-src \
    rustfmt

# Update existing Rust installation.
iecho "Updating Rust"

# Update installed Rust components/toolchains.
rustup update

# Install completion scripts for zsh.
RUST_ZSH_COMPLETION_FILE="$HOME/.zfunc/_rustup"
if [[ -e "$RUST_ZSH_COMPLETION_FILE" ]] ; then
    rm -f "$RUST_ZSH_COMPLETION_FILE"
fi
rustup completions zsh > "$RUST_ZSH_COMPLETION_FILE"

cd - > /dev/null
