local plugins_fn = function()
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

    -- Improved match motions
    use({
        "haya14busa/vim-asterisk",
        config = function()
            require("config.vim-asterisk")
        end,
    })

    -- File type icons for various plugins
    use({
        "kyazdani42/nvim-web-devicons",
        config = function()
            require("config.nvim-web-devicons")
        end,
    })

    -- Languages
    use({ "azidar/firrtl-syntax" })
    use({ "fladson/vim-kitty" })
    use({ "rust-lang/rust.vim" })

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
    use({
        "SmiteshP/nvim-gps",
        after = "nvim-treesitter",
        config = function()
            require("nvim-gps").setup()
        end,
    })

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
    use({
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({})
        end,
    })

    -- Collection of common configurations for the nvim LSP client
    use({
        "neovim/nvim-lspconfig",
        after = {
            "cmp-nvim-lsp",
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
        },
    })

    -- Improve the default vim.ui interfaces
    use({ "stevearc/dressing.nvim" })

    -- Pretty list for showing all sorts of diagnostics and search results
    use({
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({})
        end,
    })

    -- Statusline
    use({
        "nvim-lualine/lualine.nvim",
        after = {
            "gitsigns.nvim",
            "nvim-gps",
        },
        config = function()
            require("config.lualine").setup()
        end,
    })

    -- Buffer line
    use({ "romgrk/barbar.nvim" })

    -- Smart window-split resizing and navigation
    use({
        "mrjones2014/smart-splits.nvim",
        config = function()
            require("config.smart-splits")
        end,
    })

    -- Indent guides
    use({
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup({
                show_current_context = true,
            })
        end,
    })

    -- Automatic table creator
    use({ "dhruvasagar/vim-table-mode" })

    -- Fancy notification manager
    use({
        "rcarriga/nvim-notify",
        config = function()
            local notify = require("notify")
            notify.setup({
                timeout = 3000,
                stages = "fade",
                on_open = function(win)
                    -- Don't let user move cursor to notification windows
                    vim.api.nvim_win_set_config(win, { focusable = false })
                end,
            })
            vim.notify = notify
        end,
    })
end

return require("packer").startup({
    plugins_fn,
    config = {
        display = {
            open_cmd = "vnew",
        },
    },
})
