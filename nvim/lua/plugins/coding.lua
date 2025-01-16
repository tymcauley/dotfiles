return {
    -- Languages
    { "azidar/firrtl-syntax", event = "VeryLazy" },
    { "rust-lang/rust.vim", event = "VeryLazy" },
    { "tymcauley/llvm-vim-syntax", event = "VeryLazy" },

    -- Column-align multiple lines
    {
        "echasnovski/mini.align",
        event = "VeryLazy",
        opts = {
            mappings = {
                start = "ga",
                start_with_preview = "gA",
            },
        },
    },

    -- Automatic closing of quotes, parens, brackets, etc
    {
        "windwp/nvim-autopairs",
        event = "VeryLazy",
        config = function()
            local npairs = require("nvim-autopairs")
            npairs.setup({})

            -- In Verilog/SystemVerilog, backtick is used for text macros, so disable autopairs for those files
            npairs.get_rule("`").not_filetypes = { "verilog", "systemverilog" }

            -- TODO this isn't working right, it's inserting an extra backtick at the end
            -- -- In rST, match double backticks
            -- npairs.add_rule(Rule("``", "``", "rst"))
        end,
    },

    -- Easy comment insertion
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        opts = {}, -- `opts = {}` is the same as calling `require("Comment").setup({})`
    },

    -- Make a new text object for lines at the same indent level
    { "michaeljsmith/vim-indent-object", event = "VeryLazy" },

    -- Surround actions
    {
        "echasnovski/mini.surround",
        event = "VeryLazy",
        opts = {
            mappings = {
                add = "gsa", -- Add surrounding in Normal and Visual modes
                delete = "gsd", -- Delete surrounding
                find = "gsf", -- Find surrounding (to the right)
                find_left = "gsF", -- Find surrounding (to the left)
                highlight = "gsh", -- Highlight surrounding
                replace = "gsr", -- Replace surrounding
                update_n_lines = "gsn", -- Update `n_lines`
            },
        },
    },

    -- Commands for smart text substitution
    { "tpope/vim-abolish", event = "VeryLazy" },

    -- Improved match motions
    {
        "haya14busa/vim-asterisk",
        event = "VeryLazy",
        config = function()
            -- Don't move to the next match immediately
            vim.keymap.set("", "*", "<Plug>(asterisk-z*)")
            vim.keymap.set("", "#", "<Plug>(asterisk-z#)")
            vim.keymap.set("", "g*", "<Plug>(asterisk-gz*)")
            vim.keymap.set("", "g#", "<Plug>(asterisk-gz#)")

            -- Keep cursor position across matches
            vim.g["asterisk#keeppos"] = 1
        end,
    },

    -- Automatic table creator
    {
        "dhruvasagar/vim-table-mode",
        event = "VeryLazy",
        config = function()
            -- Fix table formatting for ReST and Markdown files
            local ft = vim.bo.filetype
            if ft == "rst" then
                vim.cmd("let b:table_mode_corner_corner = '+'")
                vim.cmd("let b:table_mode_header_fillchar = '='")
            elseif ft == "markdown" then
                vim.cmd("let b:table_mode_corner = '|'")
            end
        end,
    },

    -- Autocompletion plugin
    {
        "saghen/blink.cmp",
        lazy = false, -- lazy loading handled internally
        dependencies = "rafamadriz/friendly-snippets", -- snippet source
        version = "v0.*", -- use a release tag to download pre-built binaries

        opts = {
            keymap = {
                preset = "default",
                -- Preset:
                -- ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                -- ['<C-e>'] = { 'hide' },
                -- ['<C-y>'] = { 'select_and_accept' },
                -- ['<C-p>'] = { 'select_prev', 'fallback' },
                -- ['<C-n>'] = { 'select_next', 'fallback' },
                -- ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
                -- ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
                -- ['<Tab>'] = { 'snippet_forward', 'fallback' },
                -- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
                ["<C-e>"] = { "show", "hide" }, -- Toggle completion menu
                ["<C-d>"] = { "show_documentation", "hide_documentation" }, -- Toggle documentation

                cmdline = {
                    preset = "enter",
                    -- Preset:
                    -- ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                    -- ['<C-e>'] = { 'hide', 'fallback' },
                    -- ['<CR>'] = { 'accept', 'fallback' },
                    -- ['<Tab>'] = { 'snippet_forward', 'fallback' },
                    -- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
                    -- ['<Up>'] = { 'select_prev', 'fallback' },
                    -- ['<Down>'] = { 'select_next', 'fallback' },
                    -- ['<C-p>'] = { 'select_prev', 'fallback' },
                    -- ['<C-n>'] = { 'select_next', 'fallback' },
                    -- ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
                    -- ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
                    ["<CR>"] = { "fallback" }, -- Immediately run the selected command
                    ["<C-e>"] = { "show", "hide" }, -- Toggle completion menu
                    -- Accept the selection with either of these
                    ["<Tab>"] = { "accept", "fallback" },
                    ["<C-y>"] = { "accept", "fallback" },
                },
            },
        },
    },

    -- Smart selection of closest text object
    {
        "sustech-data/wildfire.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {},
    },

    -- Tools for working with the Lean language
    {
        "Julian/lean.nvim",
        event = { "BufReadPre *.lean", "BufNewFile *.lean" },
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
        },
        opts = {},
    },
}
