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

# Install Rust components
rustup component add \
    clippy \
    rust-src \
    rustfmt

# Update existing Rust installation
iecho "Updating Rust"

# Update installed Rust components/toolchains
rustup update

# Install completion scripts for zsh
rustup completions zsh > "$HOME/.zfunc/_rustup"

# Install/update rust-analyzer
if [[ "$OSTYPE" == darwin* ]] ; then
    RUST_ANALYZER_NAME=rust-analyzer-x86_64-apple-darwin
else
    RUST_ANALYZER_NAME=rust-analyzer-x86_64-unknown-linux-gnu
fi

RUST_ANALYZER_URL=https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/$RUST_ANALYZER_NAME.gz
curl -L $RUST_ANALYZER_URL | gunzip -c - > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer

cd - > /dev/null
