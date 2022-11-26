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

    -- Git diff viewer
    use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

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
    use({ "tymcauley/llvm-vim-syntax" })

    -- Treesitter integration into neovim
    use({
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("config.treesitter")
        end,
        run = ":TSUpdate",
    })
    use({ "p00f/nvim-ts-rainbow", after = "nvim-treesitter" })
    use({
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
        config = function()
            require("treesitter-context").setup({
                max_lines = 3,
            })
        end,
    })

    -- Autocompletion plugin
    use({
        "ms-jpq/coq_nvim",
        branch = "coq",
        config = function()
            require("config.coq")
        end,
    })
    use({
        "ms-jpq/coq.artifacts",
        branch = "artifacts",
        after = {
            "coq_nvim",
        },
    })
    use({
        "ms-jpq/coq.thirdparty",
        branch = "3p",
        after = {
            "coq_nvim",
        },
        config = function()
            require("coq_3p")({
                { src = "nvimlua", short_name = "nLUA" },
                { src = "bc", short_name = "MATH", precision = 6 },
            })
        end,
    })

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
            "coq_nvim",
        },
        config = function()
            require("config.lsp")
        end,
    })

    -- Display code context from LSP
    use({
        "SmiteshP/nvim-navic",
        requires = "neovim/nvim-lspconfig",
    })

    -- Connect non-LSP sources into nvim's LSP client
    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = {
            { "nvim-lua/plenary.nvim" },
            { "neovim/nvim-lspconfig" },
        },
    })

    -- Display LSP inlay hints
    use({
        "lvimuser/lsp-inlayhints.nvim",
        config = function()
            local inlayhints = require("lsp-inlayhints")
            inlayhints.setup()
            vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
            vim.api.nvim_create_autocmd("LspAttach", {
                group = "LspAttach_inlayhints",
                callback = function(args)
                    if not (args.data and args.data.client_id) then
                        return
                    end

                    local bufnr = args.buf
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    inlayhints.on_attach(client, bufnr)
                end,
            })
        end,
    })

    -- Extra tools for using rust-analyzer with nvim LSP client.
    use({ "simrat39/rust-tools.nvim" })

    -- Metals (Scala language server) integration for nvim LSP
    use({ "scalameta/nvim-metals", requires = { "nvim-lua/plenary.nvim" } })

    -- Render LSP diagnostics inline with code
    use({
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
        end,
    })

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
            "nvim-navic",
            "tokyonight.nvim",
        },
        config = function()
            require("config.lualine").setup()
        end,
    })

    -- Buffer line
    use({
        "romgrk/barbar.nvim",
        config = function()
            local utils = require("utils")

            -- Move between buffers
            vim.keymap.set("n", "gn", "<Cmd>BufferNext<CR>")
            vim.keymap.set("n", "gp", "<Cmd>BufferPrevious<CR>")

            -- Re-order buffers
            vim.keymap.set("n", "gN", "<Cmd>BufferMoveNext<CR>")
            vim.keymap.set("n", "gP", "<Cmd>BufferMovePrevious<CR>")

            vim.keymap.set("n", "gk", "<Cmd>BufferClose<CR>")

            -- Make all modified buffers bold
            utils.hi("BufferCurrentMod", { gui = "bold" })
            utils.hi("BufferInactiveMod", { gui = "bold" })
            utils.hi("BufferVisibleMod", { gui = "bold" })
        end,
    })

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
                show_trailing_blankline_indent = false,
                disable_with_nolist = true,
            })
        end,
    })

    -- Scrollbar
    use({
        "lewis6991/satellite.nvim",
        config = function()
            require("satellite").setup()
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

    -- Improved code folding
    use({
        "kevinhwang91/nvim-ufo",
        requires = "kevinhwang91/promise-async",
        config = function()
            require("config.nvim-ufo")
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
