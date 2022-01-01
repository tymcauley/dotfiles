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
        after = "plenary.nvim",
        config = function()
            require("config.gitsigns")
        end,
    })

    -- Languages
    use({ "rust-lang/rust.vim" })
    use({ "azidar/firrtl-syntax" })

    -- Treesitter integration into neovim
    use({
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("config.treesitter")
        end,
        run = ":TSUpdate",
    })
    use({ "p00f/nvim-ts-rainbow", after = "nvim-treesitter" })
    use({ "romgrk/nvim-treesitter-context", after = "nvim-treesitter" })

    -- Better spell-checking for buffers with Treesitter highlighting
    use({
        "lewis6991/spellsitter.nvim",
        config = function()
            require("spellsitter").setup()
        end,
    })

    -- Autocompletion plugin
    use({
        "hrsh7th/nvim-cmp",
        config = function()
            require("config.nvim-cmp")
        end,
    })
    use({ "hrsh7th/cmp-buffer", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-calc", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-path", after = "nvim-cmp" })
    use({ "hrsh7th/cmp-vsnip", after = "nvim-cmp" })
    use({ "hrsh7th/vim-vsnip", after = "nvim-cmp" })

    -- LSP statusline components
    use({ "nvim-lua/lsp-status.nvim" })

    -- Collection of common configurations for the nvim LSP client
    use({
        "neovim/nvim-lspconfig",
        after = {
            "cmp-nvim-lsp",
            "lsp-status.nvim",
        },
        config = function()
            require("config.lsp")
        end,
    })

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

    -- Metals (Scala language server) integration for nvim LSP
    use({ "scalameta/nvim-metals", requires = { "nvim-lua/plenary.nvim" } })

    -- Fuzzy finder
    use({
        "nvim-telescope/telescope.nvim",
        config = function()
            require("config.telescope")
        end,
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
        config = function()
            require("trouble").setup({})
        end,
        requires = { "kyazdani42/nvim-web-devicons" },
    })

    -- Statusline
    use({
        "nvim-lualine/lualine.nvim",
        after = {
            "gitsigns.nvim",
            "lsp-status.nvim",
        },
        config = function()
            require("config.lualine").setup()
        end,
        requires = {
            "kyazdani42/nvim-web-devicons",
        },
    })

    -- Buffer line
    use({
        "romgrk/barbar.nvim",
        requires = { "kyazdani42/nvim-web-devicons" },
    })
end)
