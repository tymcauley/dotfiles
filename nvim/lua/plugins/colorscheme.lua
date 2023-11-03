return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
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
            vim.cmd("colorscheme tokyonight")
        end,
    },
}
