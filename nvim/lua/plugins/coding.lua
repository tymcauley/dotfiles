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
                ["<C-e>"] = { "show", "hide" },
                ["<C-y>"] = { "select_and_accept" },

                ["<C-d>"] = { "show_documentation", "hide_documentation" },

                ["<C-n>"] = { "select_next", "snippet_forward" },
                ["<C-p>"] = { "select_prev", "snippet_backward" },
            },

            -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- adjusts spacing to ensure icons are aligned
            nerd_font_variant = "mono",
        },
    },

    -- Smart selection of closest text object
    {
        "sustech-data/wildfire.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {},
    },
}
