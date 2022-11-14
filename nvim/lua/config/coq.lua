vim.g.coq_settings = {
    auto_start = "shut-up",
    display = {
        mark_highlight_group = "Search",
    },
    keymap = {
        jump_to_mark = "<C-Space>",
        manual_complete = "<C-m>",
        recommended = false,
    },
}

local opts = {
    expr = true,
    silent = true,
}
vim.keymap.set("i", "<Esc>", function()
    return vim.fn.pumvisible() == 1 and "<C-e><Esc>" or "<Esc>"
end, opts)
vim.keymap.set("i", "<C-c>", function()
    return vim.fn.pumvisible() == 1 and "<C-e><C-c>" or "<C-c>"
end, opts)
vim.keymap.set("i", "<BS>", function()
    return vim.fn.pumvisible() == 1 and "<C-e><BS>" or "<BS>"
end, opts)
vim.keymap.set("i", "<CR>", function()
    if vim.fn.pumvisible() == 1 then
        return vim.fn.complete_info().selected == -1 and "<C-e><CR>" or "<C-y>"
    else
        return "<CR>"
    end
end, opts)
