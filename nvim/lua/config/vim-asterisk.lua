local utils = require("utils")

-- Don't move to the next match immediately
vim.api.nvim_set_keymap("", "*", "<Plug>(asterisk-z*)", {})
vim.api.nvim_set_keymap("", "#", "<Plug>(asterisk-z#)", {})
vim.api.nvim_set_keymap("", "g*", "<Plug>(asterisk-gz*)", {})
vim.api.nvim_set_keymap("", "g#", "<Plug>(asterisk-gz#)", {})

-- Keep cursor position across matches
vim.g["asterisk#keeppos"] = 1
