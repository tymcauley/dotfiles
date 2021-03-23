return require('packer').startup(function(use)
    -- Plugin manager
    use {'wbthomason/packer.nvim', opt = true}

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
    use {'tpope/vim-fugitive'}
    use {'airblade/vim-gitgutter'}

    -- Languages
    use {'rust-lang/rust.vim'}

    -- Treesitter integration into neovim
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use {'nvim-treesitter/completion-treesitter'}
    use {'p00f/nvim-ts-rainbow'}
    use {'romgrk/nvim-treesitter-context'}

    -- Collection of common configurations for the nvim LSP client
    use {'neovim/nvim-lspconfig'}

    -- Extensions to built-in LSP, for example, providing type inlay hints
    use {'nvim-lua/lsp_extensions.nvim'}

    -- Autocompletion framework for built-in LSP
    use {'nvim-lua/completion-nvim'}

    -- Metals (Scala language server) integration for nvim LSP
    use {'scalameta/nvim-metals'}

    -- Fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }

    -- Statusline
    use {
        'glepnir/galaxyline.nvim',
        requires = {'kyazdani42/nvim-web-devicons'}
    }
end)
