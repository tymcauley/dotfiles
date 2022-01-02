require("nvim-web-devicons").setup({
    override = {
        -- The built-in extension for Makefile doesn't agree with the output of `vim.bo.filetype`, which is 'make'
        make = {
            icon = "",
            color = "#6d8086",
            cterm_color = "66",
            name = "Makefile",
        },
        -- This should also work for files with the '.mk' extension
        mk = {
            icon = "",
            color = "#6d8086",
            cterm_color = "66",
            name = "Makefile",
        },
    },
})
