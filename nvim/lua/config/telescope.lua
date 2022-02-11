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

local tsb = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", tsb.find_files)
vim.keymap.set("n", "<leader>fg", tsb.live_grep)
vim.keymap.set("n", "<leader>fb", tsb.buffers)
vim.keymap.set("n", "<leader>fh", tsb.help_tags)

-- Use 'nvim-telescope/telescope-fzf-native.nvim' as telescope's sorter
require("telescope").load_extension("fzf")
