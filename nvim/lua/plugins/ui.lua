return {
    -- File type icons for various plugins
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- Improve the default vim.ui interfaces
    { "stevearc/dressing.nvim", event = "VeryLazy" },

    -- Buffer line
    {
        "romgrk/barbar.nvim",
        event = "VeryLazy",
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = {
            -- Move between buffers
            { "gn", "<Cmd>BufferNext<CR>" },
            { "gp", "<Cmd>BufferPrevious<CR>" },

            -- Re-order buffers
            { "gN", "<Cmd>BufferMoveNext<CR>" },
            { "gP", "<Cmd>BufferMovePrevious<CR>" },

            { "gk", "<Cmd>BufferClose<CR>" },
        },
        init = function()
            vim.g.barbar_auto_setup = false
        end,
        opts = {},
        config = function(_, opts)
            require("barbar").setup(opts)

            -- Make all modified buffers bold
            vim.cmd("highlight BufferCurrentMod gui=bold")
            vim.cmd("highlight BufferInactiveMod gui=bold")
            vim.cmd("highlight BufferVisibleMod gui=bold")
        end,
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

    -- Scrollbar
    {
        "lewis6991/satellite.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts)
            require("satellite").setup(opts)
            -- Ensure the scrollbar isn't included in diff mode.
            if vim.opt.diff:get() then
                vim.api.nvim_command("SatelliteDisable")
            end
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
                    -- Display code context
                    {
                        function()
                            return require("nvim-navic").get_location()
                        end,
                        cond = function()
                            return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
                        end,
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
