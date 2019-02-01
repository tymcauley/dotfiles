# dotfiles

My collection of configuration files.

## Installation

1. Clone the repository:

   ```console
   git clone https://github.com/tymcauley/dotfiles.git $HOME/.dotfiles
   ```

2. Run the installation script:

   ```console
   cd $HOME/.dotfiles
   ./install_dotfiles
   ```

## Troubleshooting

### tmuxline permissions

After a new `dotfiles` install, the `~/.tmux-statusline-colors.conf` file is
sometimes owned by `root`.
This causes a number of errors when `vim` starts up.
You can fix this problem by setting the proper owner for this file.

### vim colors

After a new `dotfiles` install, the colors in `vim` sessions look strange.
You must set the proper `Base16` color settings before `vim` colors will look
right.
To do this, run the appropriate `Base16` script, such as this one:

```console
base16_harmonic-dark
```

To see what colorscheme options you have, open a new shell after completing a
new `dotfiles` installation, and type `base16` followed by a tab.
