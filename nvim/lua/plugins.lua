return {
    -- Color scheme
    {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup since it is the main color scheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("tokyonight").setup({
                -- Set a darker background on sidebar-like windows
                sidebars = { "qf", "help", "terminal" },
                -- Section headers in the lualine theme will be bold
                lualine_bold = true,
                -- Change the window separator color to 'colors.blue'
                on_colors = function(colors)
                    colors.border = colors.blue
                end,
            })

            -- load the color scheme
            vim.cmd([[colorscheme tokyonight]])
        end,
    },

    -- Useful lua functions for nvim, used by other plugins
    { "nvim-lua/plenary.nvim", lazy = true },

    -- Column-align multiple lines
    {
        "junegunn/vim-easy-align",
        config = function()
            -- Start interactive EasyAlign in visual mode (e.g. vipgs)
            vim.keymap.set("x", "gs", "<Plug>(EasyAlign)")
            -- Start interactive EasyAlign for a motion/text object (e.g. gsip)
            vim.keymap.set("n", "gs", "<Plug>(EasyAlign)")
        end,
    },

    -- Make a new text object for lines at the same indent level
    { "michaeljsmith/vim-indent-object" },

    -- Operators for surrounding/sandwiching text objects
    { "machakann/vim-sandwich" },

    -- Automatic closing of quotes, parens, brackets, etc
    {
        "windwp/nvim-autopairs",
        config = function()
            local npairs = require("nvim-autopairs")
            npairs.setup({})

            -- In Verilog/SystemVerilog, backtick is used for text macros, so disable autopairs for those files
            npairs.get_rule("`").not_filetypes = { "verilog", "systemverilog" }
        end,
    },

    -- Easy comment insertion
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },

    -- Commands for smart text substitution
    { "tpope/vim-abolish" },

    -- Use dot operator (.) to repeat plugin map operations
    { "tpope/vim-repeat" },

    -- Add nice integration with git
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("config.gitsigns")
        end,
    },

    -- Git diff viewer
    { "sindrets/diffview.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

    -- Improved match motions
    {
        "haya14busa/vim-asterisk",
        config = function()
            require("config.vim-asterisk")
        end,
    },

    -- File type icons for various plugins
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
        config = function()
            require("config.nvim-web-devicons")
        end,
    },

    -- Languages
    { "azidar/firrtl-syntax" },
    { "fladson/vim-kitty" },
    { "rust-lang/rust.vim" },
    { "tymcauley/llvm-vim-syntax" },

    -- Treesitter integration into neovim
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("config.treesitter")
        end,
    },
    { "p00f/nvim-ts-rainbow" },
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({
                max_lines = 3,
            })
        end,
    },

    -- Autocompletion plugin
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter", -- load cmp on InsertEnter
        dependencies = {
            "hrsh7th/cmp-vsnip",
            "hrsh7th/vim-vsnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lsp-signature-help",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-calc",
        },
        config = function()
            require("config.nvim-cmp")
        end,
    },

    -- LSP statusline components
    {
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup({})
        end,
    },

    -- Collection of common configurations for the nvim LSP client
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            require("config.lsp")
        end,
    },

    -- Display code context from LSP
    {
        "SmiteshP/nvim-navic",
        lazy = true,
    },

    -- Connect non-LSP sources into nvim's LSP client
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "neovim/nvim-lspconfig",
        },
    },

    -- Display LSP inlay hints
    {
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
    },

    -- Extra tools for using rust-analyzer with nvim LSP client.
    { "simrat39/rust-tools.nvim" },

    -- Metals (Scala language server) integration for nvim LSP
    { "scalameta/nvim-metals", dependencies = { "nvim-lua/plenary.nvim" } },

    -- Render LSP diagnostics inline with code
    {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            require("lsp_lines").setup()
        end,
    },

    -- Fuzzy finder
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local fzf = require("fzf-lua")
            fzf.setup({
                file_icon_padding = " ",
                files = {
                    prompt = "fd> ",
                },
                grep = {
                    prompt = "rg> ",
                },
            })
            fzf.register_ui_select()

            vim.keymap.set("n", "<leader>ff", fzf.files)
            vim.keymap.set("n", "<leader>fg", fzf.grep_project)
            vim.keymap.set("n", "<leader>fb", fzf.buffers)
            vim.keymap.set("n", "<leader>fh", fzf.help_tags)
        end,
    },

    -- Improve the default vim.ui interfaces
    { "stevearc/dressing.nvim", event = "VeryLazy" },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            require("config.lualine").setup()
        end,
    },

    -- Buffer line
    {
        "romgrk/barbar.nvim",
        event = "VeryLazy",
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
    },

    -- Smart window-split resizing and navigation
    {
        "mrjones2014/smart-splits.nvim",
        config = function()
            require("config.smart-splits")
        end,
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("indent_blankline").setup({
                filetype_exclude = { "help", "lazy" },
                show_current_context = true,
                show_trailing_blankline_indent = false,
                disable_with_nolist = true,
            })
        end,
    },

    -- Scrollbar
    {
        "lewis6991/satellite.nvim",
        config = function()
            require("satellite").setup()
            -- Ensure the scrollbar isn't included in diff mode.
            if vim.opt.diff:get() then
                vim.api.nvim_command("SatelliteDisable")
            end
        end,
    },

    -- Automatic table creator
    { "dhruvasagar/vim-table-mode" },

    -- Fancy notification manager
    {
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
                max_height = function()
                    return math.floor(vim.o.lines * 0.75)
                end,
                max_width = function()
                    return math.floor(vim.o.columns * 0.75)
                end,
            })
            vim.notify = notify
        end,
    },

    -- Improved code folding
    {
        "kevinhwang91/nvim-ufo",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            require("config.nvim-ufo")
        end,
    },
}
