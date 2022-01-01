require("telescope").setup({
    defaults = {
        mappings = {
            i = { ["<C-t>"] = require("trouble.providers.telescope").open_with_trouble },
            n = { ["<C-t>"] = require("trouble.providers.telescope").open_with_trouble },
        },
        layout_strategy = "vertical",
        layout_config = {
            width = 0.8,
        },
        winblend = 10,
    },
})

-- Use 'nvim-telescope/telescope-fzf-native.nvim' as telescope's sorter
require("telescope").load_extension("fzf")

-- Use telescope as the viewer for more nvim core operations
require("telescope").load_extension("ui-select")
