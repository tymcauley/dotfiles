-- Bootstrap plugin manager installation
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

--
-- Mappings
--

vim.g.mapleader = [[,]] -- map by , instead of /
vim.g.maplocalleader = [[\]] -- map local by \

-- Navigate between splits with <Ctrl> hjkl
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Resize splits with <Alt> hjkl
vim.keymap.set("n", "<A-h>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<A-j>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<A-k>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<A-l>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Clear search highlighting
vim.keymap.set("n", "<leader>/", ":nohlsearch<CR>", { silent = true })

-- Toggle spell check
vim.keymap.set("n", "<leader>s", "<Cmd>set spell!<CR>", { silent = true })

-- Delete trailing whitespace
vim.keymap.set("n", "<leader>w", function()
    if not vim.o.binary and vim.o.filetype ~= "diff" then
        local current_view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(current_view)
    end
end, { silent = true })

-- Toggle enabling relative numbers
vim.g.enable_relativenumber = true
vim.keymap.set("n", "<leader>rn", function()
    vim.g.enable_relativenumber = not vim.g.enable_relativenumber
    if vim.g.enable_relativenumber then
        vim.opt.relativenumber = true
    else
        vim.opt.relativenumber = false
    end
end, { silent = true })

-- If you run "dd" on a blank line (or a line with only whitespace), don't copy the line into the unnamed register
vim.keymap.set("n", "dd", function()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
    else
        return "dd"
    end
end, { expr = true })

-- Toggle code folding
vim.keymap.set("n", "<space>", "za")

--
-- Settings
--

vim.opt.cmdheight = 2 -- Command window height; 2 lines avoids many cases of 'press <Enter> to continue'
vim.opt.showmode = false -- Don't show mode on the last line, the status line does that
vim.opt.laststatus = 3 -- Enable global statusline
vim.opt.ignorecase = true -- case-insensitive match...
vim.opt.smartcase = true -- ...except when uppercase letters are given
vim.opt.confirm = true -- Prompt to save changes before exiting a modified buffer
vim.opt.list = true -- Show some invisible characters
vim.opt.listchars = {
    -- Place a '#' in the last column when 'wrap' is off and the line continues beyond the right of the screen
    extends = "#",
    -- Place a '#' in the first column when 'wrap' is off and there is text preceding the character visible in the
    -- first column
    precedes = "#",
    -- Show non-breaking space characters
    nbsp = "¬",
    -- Show tabs
    tab = ".→",
    -- Show trailing spaces
    trail = "◊",
}
vim.opt.scrolloff = 2 -- Lines of context between top/bottom of window and cursor
vim.opt.spelllang = "en_us" -- Spell check language
vim.opt.spellfile = vim.fn.stdpath("data") .. "/en.utf-8.add" -- Custom spell check entries
vim.opt.spellcapcheck = "" -- Disable capitalization check
vim.opt.spell = true -- Enable spell check by default
vim.opt.number = true -- Enable line numbers
vim.opt.relativenumber = true -- Enable relative line numbers
vim.opt.diffopt:append("linematch:60") -- Use new second stage diff option to improve nvim diff view
vim.opt.tabstop = 4 -- Default <Tab> size in spaces
vim.opt.softtabstop = 4 -- Default <Tab> size when editing
vim.opt.shiftwidth = 4 -- Default indent size in spaces
vim.opt.expandtab = true -- Use tabs instead of spaces
vim.opt.wrap = false -- Disable text wrap
vim.opt.colorcolumn = "+1" -- Highlight column after 'textwidth'
vim.opt.splitbelow = true -- Put a new hsplit below the current one
vim.opt.splitright = true -- Put a new vsplit to the right of the current one
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99 -- Start with all folds open
vim.opt.updatetime = 300 -- Speed up CursorHold autocommand events (also writes swap file)
vim.opt.pumblend = 30 -- Pop-up-menu transparency
vim.opt_global.shortmess:remove("F") -- Allow nvim-metals to show setup messages
vim.opt.shortmess:append({
    I = true, -- Hide vim's intro message
    c = true, -- Hide messages when using completion
    C = true, -- Hide messages when scanning for completion sources
})
vim.opt.cursorline = true -- Enable cursor-line highlighting
vim.opt.cursorlineopt = "number" -- Only highlight the line number at the cursor

-- Auto-toggling of relative numbers
-- - Only enable relative numbers for the focused window
-- - Disable relative numbers in insert mode
-- - Don't change relative numbers if numbers are disabled
local numbertoggle = vim.api.nvim_create_augroup("numbertoggle", {})
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
    callback = function()
        if vim.g.enable_relativenumber and vim.wo.number then
            vim.wo.relativenumber = true
        end
    end,
    group = numbertoggle,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
    callback = function()
        if vim.g.enable_relativenumber and vim.wo.number then
            vim.wo.relativenumber = false
        end
    end,
    group = numbertoggle,
})

-- Filetype-specific overrides for indentation
local override_indents = vim.api.nvim_create_augroup("override_indents", {})
vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = "cpp", command = "setlocal softtabstop=2 shiftwidth=2", group = override_indents }
)
vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = "haskell", command = "setlocal softtabstop=2 shiftwidth=2", group = override_indents }
)

-- Filetype-specific overrides for 'textwidth'
local override_textwidth = vim.api.nvim_create_augroup("override_textwidth", {})
vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = "cpp", command = "setlocal textwidth=79", group = override_textwidth }
)
vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = "lua", command = "setlocal textwidth=119", group = override_textwidth }
)
vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = "scala", command = "setlocal textwidth=119", group = override_textwidth }
)

-- Highlight text after yanking it
vim.cmd("autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = false}")

--
-- Plugins
--

require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    install = { colorscheme = { "tokyonight" } },
    checker = {
        enabled = true,
        notify = false,
    },
    change_detection = {
        notify = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "matchit",
                "matchparen",
                "netrw",
                "netrwFileHandlers",
                "netrwPlugin",
                "netrwSettings",
                "rrhelper",
                "spellfile_plugin",
                "tar",
                "tarPlugin",
                "tohtml",
                "tutor",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            },
        },
    },
})
