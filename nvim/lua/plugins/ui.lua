return {
    -- File type icons for various plugins
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- Improve the default vim.ui interfaces
    { "stevearc/dressing.nvim", event = "VeryLazy" },

    -- Buffer line
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = {
            -- Move between buffers
            { "gn", "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
            { "gp", "<Cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
            -- Re-order buffers
            { "gN", "<Cmd>BufferLineMoveNext<CR>", desc = "Move buffer right" },
            { "gP", "<Cmd>BufferLineMovePrev<CR>", desc = "Move buffer left" },
        },
        opts = {
            options = {
                truncate_names = false,
                diagnostics = "nvim_lsp",
                diagnostics_indicator = function(count, level)
                    local icon = level:match("error") and "󰅚 " or " "
                    return " " .. icon .. count
                end,
                show_buffer_close_icons = false,
                separator_style = "slant",
                enforce_regular_tabs = false,
            },
        },
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
        main = "ibl",
        opts = {},
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
                desc = "Toggle block highlight",
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
            spec = {
                {
                    mode = { "n", "v" },
                    { "<leader>c", group = "code" },
                    { "<leader>ct", group = "toggle" },
                    { "<leader>f", group = "file/find" },
                    { "<leader>g", group = "git" },
                    { "<leader>gh", group = "hunks" },
                    { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
                    { "[", group = "prev" },
                    { "]", group = "next" },
                    { "g", group = "goto" },
                    { "ga", group = "align" },
                    { "gA", group = "align with preview" },
                    { "gs", group = "surround" },
                    { "z", group = "fold" },
                },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
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
                        color = { gui = "bold" },
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
                        color = { gui = "bold" },
                    },
                    {
                        "progress",
                        color = { gui = "bold" },
                    },
                    {
                        "location",
                        color = { gui = "bold" },
                    },
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

    -- Markdown previewer
    {
        "OXY2DEV/markview.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
    },
}
