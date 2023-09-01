return {
    -- File type icons for various plugins
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- Improve the default vim.ui interfaces
    { "stevearc/dressing.nvim", event = "VeryLazy" },

    -- Buffer line
    {
        "romgrk/barbar.nvim",
        event = "VeryLazy",
        dependencies = {
            "lewis6991/gitsigns.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            -- Move between buffers
            { "gn", "<Cmd>BufferNext<CR>", desc = "Next buffer" },
            { "gp", "<Cmd>BufferPrevious<CR>", desc = "Previous buffer" },

            -- Re-order buffers
            { "gN", "<Cmd>BufferMoveNext<CR>", desc = "Move buffer right" },
            { "gP", "<Cmd>BufferMovePrevious<CR>", desc = "Move buffer left" },

            { "gk", "<Cmd>BufferClose<CR>", desc = "Close buffer" },
        },
        init = function()
            vim.g.barbar_auto_setup = false
        end,
        opts = {
            icons = {
                -- Show some LSP diagnostics in the bar
                diagnostics = {
                    [vim.diagnostic.severity.ERROR] = { enabled = true },
                    [vim.diagnostic.severity.WARN] = { enabled = false },
                    [vim.diagnostic.severity.INFO] = { enabled = false },
                    [vim.diagnostic.severity.HINT] = { enabled = false },
                },
                -- TODO: This currently has strange background highlighting
                -- gitsigns = {
                --     added = { enabled = true },
                --     changed = { enabled = true },
                --     deleted = { enabled = true },
                -- },
            },
        },
        config = function(_, opts)
            require("barbar").setup(opts)

            -- Make all modified buffers bold
            vim.cmd("highlight BufferCurrentMod gui=bold")
            vim.cmd("highlight BufferInactiveMod gui=bold")
            vim.cmd("highlight BufferVisibleMod gui=bold")
        end,
    },

    -- winbar with nvim-navic integration
    {
        "utilyre/barbecue.nvim",
        event = "VeryLazy",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
    },

    -- Fancy notification manager
    {
        "rcarriga/nvim-notify",
        opts = {
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
        },
        config = function(_, opts)
            require("notify").setup(opts)
            vim.notify = require("notify")
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

    -- Add highlighting blocks around nested scope levels
    {
        "HampusHauffman/block.nvim",
        event = { "BufReadPost", "BufNewFile" },
        keys = {
            {
                "<leader>b",
                function()
                    vim.api.nvim_command("Block")
                end,
                desc = "Toggle block highlight"
            },
        },
        opts = {
            automatic = false, -- Don't automatically turn on for files with a treesitter parser
        },
    },

    -- Displays a pop-up with possible keybindings for commands
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            defaults = {
                mode = { "n", "v" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>ct"] = { name = "+toggle" },
                ["<leader>f"] = { name = "+file/find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>gh"] = { name = "+hunks" },
                ["<leader>ght"] = { name = "+toggle" },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
                theme = "tokyonight",
                globalstatus = true,
            },
            sections = {
                lualine_a = {
                    -- Return a single character representing the current Vim mode.
                    {
                        "mode",
                        fmt = function(str)
                            return str:sub(1, 1)
                        end,
                    },
                },
                lualine_b = {
                    -- Prefix file name with file icon
                    {
                        "filetype",
                        icon_only = true,
                        separator = "",
                        padding = { left = 1, right = 0 },
                    },
                    {
                        "filename",
                        path = 0,
                    },
                },
                lualine_c = {
                    {
                        "b:gitsigns_head",
                        icon = "",
                    },
                    {
                        "b:gitsigns_status",
                    },
                },
                lualine_x = {
                    -- LSP diagnostics
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                    },
                },
                lualine_y = {
                    {
                        "filetype",
                        icons_enabled = false,
                    },
                },
                lualine_z = {
                    -- Display file format for non-unix files
                    {
                        "fileformat",
                        cond = function()
                            return vim.bo.fileformat ~= "unix"
                        end,
                    },
                    "progress",
                    "location",
                },
            },
            inactive_sections = {
                lualine_c = { "filename" },
                lualine_x = { "location" },
            },
            extensions = {
                "lazy",
            },
        },
    },
}
