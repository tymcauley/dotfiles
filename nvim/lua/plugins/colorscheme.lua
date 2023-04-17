return {
    {
        "folke/tokyonight.nvim",
        lazy = false, -- make sure we load this during startup since it is the main color scheme
        priority = 1000, -- make sure to load this before all the other start plugins
        opts = {
            -- Set a darker background on sidebar-like windows
            sidebars = { "qf", "help", "terminal" },
            -- Section headers in the lualine theme will be bold
            lualine_bold = true,
            on_colors = function(colors)
                colors.border = colors.blue -- Window separator color
            end,
            on_highlights = function(hl, colors)
                hl.CursorLineNr = { fg = colors.orange, bold = true } -- Cursor line number highlight
            end,
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            -- Load the color scheme
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
}
