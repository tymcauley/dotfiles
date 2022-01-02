local utils = require("utils")

require("hlslens").setup({
    calm_down = true,
    nearest_only = true,
})

local start_hlslens = "<Cmd>lua require('hlslens').start()<CR>"

-- The 'zzzv' sequence means the following:
--  zz -> center the screen on search result
--  zv -> open any code folds so we can see the search result
utils.map("n", "n", "<Cmd>execute('normal! ' . v:count1 . 'nzzzv')<CR>" .. start_hlslens, { silent = true })
utils.map("n", "N", "<Cmd>execute('normal! ' . v:count1 . 'Nzzzv')<CR>" .. start_hlslens, { silent = true })
utils.map("n", "*", "*" .. start_hlslens)
utils.map("n", "#", "#" .. start_hlslens)
utils.map("n", "g*", "g*" .. start_hlslens)
utils.map("n", "g#", "g#" .. start_hlslens)
