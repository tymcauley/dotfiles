#!/bin/bash -e

# Customize scala configuration.

cd $(dirname $0)

if [[ -z "$DOTFILES_DIR" ]] ; then
    echo "DOTFILES_DIR is undefined."
    exit 2
fi

# Import custom functions.
source $DOTFILES_LIB

# Install scala/sbt through sdkman
if [ -z ${SDKMAN_DIR+x} ] || [[ ! -d "$SDKMAN_DIR" ]] ; then
    iecho "sdkman not detected, installing it"
    curl -s "https://get.sdkman.io?rcupdate=false" | bash
    iecho "Please install the following sdkman components:"
    iecho "  java 11.0.11.j9-adpt"
    iecho "  scala"
    iecho "  sbt"
fi

# Install coursier: https://get-coursier.io/docs/cli-installation.html
if ! command -v cs > /dev/null 2>&1 ; then
    iecho "Coursier not detected, installing it"
    curl -fLo cs https://git.io/coursier-cli-"$(uname | tr LD ld)"
    chmod +x cs
    ./cs install cs
    rm cs
fi

# Install zsh completions
if [[ ! -z "$ZSH" ]] ; then
    cs --completions zsh > "$ZSH/completions/cs"
fi

# Install cousier tools
COURSIER_TOOLS="\
scalafix \
scalafmt \
"

for program_name in $COURSIER_TOOLS ; do
    if ! command -v $program_name > /dev/null 2>&1 ; then
        cs install $program_name
    fi
done

# Update all installed coursier tools
cs update

# Install config files
install_file "$HOME/.scalafix.conf" "$(pwd)/scalafix.conf"
install_file "$HOME/.scalafmt.conf" "$(pwd)/scalafmt.conf"

cd - > /dev/null
