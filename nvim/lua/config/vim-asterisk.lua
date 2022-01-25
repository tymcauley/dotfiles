local utils = require("utils")

-- Don't move to the next match immediately
vim.keymap.set("", "*", "<Plug>(asterisk-z*)")
vim.keymap.set("", "#", "<Plug>(asterisk-z#)")
vim.keymap.set("", "g*", "<Plug>(asterisk-gz*)")
vim.keymap.set("", "g#", "<Plug>(asterisk-gz#)")

-- Keep cursor position across matches
vim.g["asterisk#keeppos"] = 1
