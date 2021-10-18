return require('packer').startup(function()
    -- Plugin manager
    use {'wbthomason/packer.nvim'}

    -- Column-align multiple lines
    use {'junegunn/vim-easy-align'}

    -- Tempus colors in vim
    use {'https://gitlab.com/protesilaos/tempus-themes-vim.git'}

    -- Allow user-defined text objects (needed for vim-textobj-line)
    use {'kana/vim-textobj-user'}

    -- Make a new text object for the current line
    use {'kana/vim-textobj-line'}

    -- Make a new text object for lines at the same indent level
    use {'michaeljsmith/vim-indent-object'}

    -- Add new vim verb for surrounding text objects
    use {'tpope/vim-surround'}

    -- Add new vim verb for commenting out lines
    use {'tpope/vim-commentary'}

    -- Add commands smart text substitution
    use {'tpope/vim-abolish'}

    -- Add ability to easily open new files up to a specific line/column
    use {'kopischke/vim-fetch'}

    -- Add ability to use dot operator (.) to repeat plugin map operations
    use {'tpope/vim-repeat'}

    -- Add nice integration with git
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'}
    }

    -- Languages
    use {'rust-lang/rust.vim'}

    -- Treesitter integration into neovim
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {'nvim-treesitter/completion-treesitter'}
    use {'p00f/nvim-ts-rainbow'}
    use {'romgrk/nvim-treesitter-context'}

    -- Collection of common configurations for the nvim LSP client
    use {'neovim/nvim-lspconfig'}

    -- LSP statusline components
    use {'nvim-lua/lsp-status.nvim'}

    -- Connect non-LSP sources into nvim's LSP client
    use {
        'jose-elias-alvarez/null-ls.nvim',
        requires = {
            {'nvim-lua/plenary.nvim'},
            {'neovim/nvim-lspconfig'},
        }
    }

    -- Extra tools for using rust-analyzer with nvim LSP client.
    use {'simrat39/rust-tools.nvim'}

    -- Autocompletion plugin
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-calc'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},
            {'hrsh7th/cmp-path'},
            {'hrsh7th/cmp-vsnip'},
            {'hrsh7th/vim-vsnip'},
            {'f3fora/cmp-spell'},
        }
    }

    -- Metals (Scala language server) integration for nvim LSP
    use {'scalameta/nvim-metals'}

    -- Fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
        }
    }

    -- Pretty list for showing all sorts of diagnostics and search results
    use {
        'folke/trouble.nvim',
        requires = {'kyazdani42/nvim-web-devicons'},
    }

    -- Statusline
    use {
        'shadmansaleh/lualine.nvim',
        requires = {
            'kyazdani42/nvim-web-devicons',
            'lewis6991/gitsigns.nvim',
        }
    }

    -- Buffer line
    use {
        'romgrk/barbar.nvim',
        requires = {'kyazdani42/nvim-web-devicons'}
    }
end)
