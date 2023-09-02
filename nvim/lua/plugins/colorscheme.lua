return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false, -- make sure we load this during startup since it is the main color scheme
        priority = 1000, -- make sure to load this before all the other start plugins
        opts = {
            compile = true,
            background = {
                dark = "wave",
            },
            overrides = function(colors)
                return {
                    WinSeparator = { fg = colors.palette.waveBlue2 }, -- Color for separators between window splits
                }
            end,
        },
        config = function(_, opts)
            require("kanagawa").setup(opts)
            -- Load the color scheme
            vim.cmd("colorscheme kanagawa")
        end,
    },
}
