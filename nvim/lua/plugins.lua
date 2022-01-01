return require("packer").startup(function()
    -- Plugin manager
    use({ "wbthomason/packer.nvim" })

    -- Useful lua functions for nvim
    use({ "nvim-lua/plenary.nvim" })

    -- Column-align multiple lines
    use({ "junegunn/vim-easy-align" })

    -- Color scheme
    use({ "folke/tokyonight.nvim" })

    -- Make a new text object for lines at the same indent level
    use({ "michaeljsmith/vim-indent-object" })

    -- Operators for surrounding/sandwiching text objects
    use({ "machakann/vim-sandwich" })

    -- Automatic closing of quotes, parens, brackets, etc
    use({ "Raimondi/delimitMate" })

    -- Commenting plugin
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })

    -- Add commands for smart text substitution
    use({ "tpope/vim-abolish" })

    -- Add ability to use dot operator (.) to repeat plugin map operations
    use({ "tpope/vim-repeat" })

    -- Add nice integration with git
    use({
        "lewis6991/gitsigns.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    })

    -- Languages
    use({ "rust-lang/rust.vim" })
    use({ "azidar/firrtl-syntax" })

    -- Treesitter integration into neovim
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
    use({ "p00f/nvim-ts-rainbow" })
    use({ "romgrk/nvim-treesitter-context" })

    -- Better spell-checking for buffers with Treesitter highlighting
    use({ "lewis6991/spellsitter.nvim" })

    -- Collection of common configurations for the nvim LSP client
    use({ "neovim/nvim-lspconfig" })

    -- LSP statusline components
    use({ "nvim-lua/lsp-status.nvim" })

    -- Connect non-LSP sources into nvim's LSP client
    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "neovim/nvim-lspconfig" },
        },
    })

    -- Extra tools for using rust-analyzer with nvim LSP client.
    use({ "simrat39/rust-tools.nvim" })

    -- Autocompletion plugin
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-calc" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-vsnip" },
            { "hrsh7th/vim-vsnip" },
        },
    })

    -- Metals (Scala language server) integration for nvim LSP
    use({ "scalameta/nvim-metals", requires = { "nvim-lua/plenary.nvim" } })

    -- Fuzzy finder
    use({
        "nvim-telescope/telescope.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
            -- Use telescope as the viewer for more nvim core operations
            { "nvim-telescope/telescope-ui-select.nvim" },
        },
    })

    -- Pretty list for showing all sorts of diagnostics and search results
    use({
        "folke/trouble.nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
    })

    -- Statusline
    use({
        "nvim-lualine/lualine.nvim",
        requires = {
            "kyazdani42/nvim-web-devicons",
            "lewis6991/gitsigns.nvim",
        },
    })

    -- Buffer line
    use({
        "romgrk/barbar.nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
    })
end)
