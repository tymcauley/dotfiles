#!/bin/bash -e

# Install Haskell.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# If ghcup isn't installed, install it
if ! command -v ghcup > /dev/null 2>&1 ; then
    iecho "ghcup not detected, installing it"
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | BOOTSTRAP_HASKELL_NONINTERACTIVE=1 sh
    eecho "Haskell has been installed. Please add it to your PATH before continuing."
    exit 2
fi

# Update ghcup
ghcup upgrade

# Install ghcup components
GHCUP_COMPONENTS="\
ghc \
cabal \
hls \
"

for component_name in $GHCUP_COMPONENTS ; do
    if ! ghcup list --show-criteria installed --raw-format 2> /dev/null | grep -q -w "^ghc" > /dev/null 2>&1 ; then
        ghcup install $component_name
    fi
done

cd - > /dev/null
