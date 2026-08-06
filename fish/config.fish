# XDG
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME   "$HOME/.local/share"
set -gx XDG_CACHE_HOME  "$HOME/.cache"

# pager
set -gx PAGER "less"
set -gx LESS "-i -M -R -S -w -X -z-4"

# Other software
set -gx COURSIER_BIN_DIR "$XDG_DATA_HOME/coursier/bin"

# Disable telemetry
set -gx DO_NOT_TRACK "true"     # gh
set -gx HOMEBREW_NO_ANALYTICS 1 # Homebrew

if status is-interactive
    # Prepend a directory to the PATH if it exists.
    function __path_prepend
        if test -d $argv
            fish_add_path -gP $argv
        end
    end

    # Append a directory to the PATH if it exists.
    function __path_append
        if test -d $argv
            fish_add_path -agP $argv
        end
    end

    # Use vi key bindings
    fish_vi_key_bindings

    #
    # Path additions
    #

    # Load system-specific modifications
    if test -r $__fish_config_dir/config.local.fish
        source $__fish_config_dir/config.local.fish
    end

    # Set up Homebrew if it exists
    for brew_path in /opt/homebrew/bin/brew ~/.linuxbrew/bin/brew
        if test -x $brew_path
            eval ($brew_path shellenv fish)
            break
        end
    end

    __path_prepend $COURSIER_BIN_DIR # Scala
    __path_prepend ~/.cargo/bin      # Rust
    __path_prepend ~/.ghcup/bin      # Haskell
    __path_prepend ~/.cabal/bin      # Haskell
    __path_prepend ~/.elan/bin       # Lean

    if set -q HOMEBREW_PREFIX
        __path_prepend "$HOMEBREW_PREFIX/opt/llvm/bin"            # LLVM utilities
        __path_prepend "$HOMEBREW_PREFIX/opt/ruby/bin"            # Ruby
        __path_prepend "$HOMEBREW_PREFIX/lib/ruby/gems/3.3.0/bin" # Ruby gems
        __path_prepend "$HOMEBREW_PREFIX/opt/make/libexec/gnubin" # make

        if test -d "$HOMEBREW_PREFIX/Cellar/riscv-gnu-toolchain/main"
            set -gx RISCV "$HOMEBREW_PREFIX/Cellar/riscv-gnu-toolchain/main"
        end
    end

    __path_prepend ~/.local/nvim-macos-(uname -m)/bin # macOS installation of neovim
    __path_append  ~/.local/oss-cad-suite/bin         # OSS CAD Suite
    __path_prepend ~/.local/bin                       # Local tools

    #
    # Aliases
    #

    source $__fish_config_dir/aliases.fish

    #
    # SSH
    #

    source $__fish_config_dir/ssh.fish

    #
    # Tool setup
    #

    # fzf
    if type -q fzf
        if type -q fd
            set -gx FZF_DEFAULT_COMMAND "fd --type file --follow --hidden --exclude .git --color=always"
            set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
        end
        set -gx FZF_DEFAULT_OPTS "\
        --ansi \
        --reverse \
        "

        fzf --fish | source
    end

    # direnv
    if type -q direnv
        direnv hook fish | source
    end

    # bat
    if type -q bat
        set -gx BAT_THEME "tokyonight_storm"
        # Use bat for man pager. On macOS, strip overstrike sequences (macOS
        # uses `mandoc`, Linux uses `groff`).
        if test (uname) = Darwin
            set -gx MANPAGER "sh -c 'col -bx | bat -pl man'"
        else
            set -gx MANPAGER "bat -pl man"
        end
    end

    # nvim
    if type -q nvim
        # Set default text editor
        set -gx EDITOR "nvim"
        set -gx VISUAL "nvim"
    end

    #
    # History filtering
    #

    # Drop "command not found" typos (exit 127) from history
    function __drop_not_found --on-event fish_postexec
        set -l exit_code $status
        if test $exit_code -eq 127
            history delete --exact --case-sensitive -- "$argv"
        end
    end

    #
    # Cleanup
    #

    functions -e __path_prepend
end
