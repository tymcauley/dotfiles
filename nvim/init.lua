-- Prelude

local utils = require("utils")

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

-- clear search
vim.keymap.set("n", "<leader>/", ":nohlsearch<CR>", { silent = true })

-- spelling
vim.keymap.set("n", "<leader>s", "<Cmd>set spell!<CR>", { silent = true })

-- Delete trailing whitespace
vim.keymap.set("n", "<leader>w", function()
    if not vim.o.binary and vim.o.filetype ~= "diff" then
        local current_view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(current_view)
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

-- Re-sync treesitter highlighting
vim.keymap.set("n", "<leader>tss", "<Cmd>write | edit | TSBufEnable highlight<CR>")

-- Enable code folding with the spacebar
vim.keymap.set("n", "<space>", "za")

--
-- Settings
--

-- Set the command window height to 2 lines, to avoid many cases of having to 'press <Enter> to continue'
vim.opt.cmdheight = 2

-- Don't show what mode we're in on the last line, the status line takes care of that
vim.opt.showmode = false

-- Enable global statusline
vim.opt.laststatus = 3

-- This allows you to switch from an unsaved buffer without saving it first. Also allows you to keep an undo history
-- for multiple files. Vim will complain if you try to quit without saving, and swap files will keep you safe if your
-- computer crashes.
vim.opt.hidden = true

-- Search settings
vim.opt.hlsearch = true -- highlight search
vim.opt.incsearch = true -- reveal search incrementally as typed
vim.opt.ignorecase = true -- case-insensitive match...
vim.opt.smartcase = true -- ...except when uppercase letters are given

-- Instead of failing a command because of unsaved changes, raise a prompt asking if you wish to save changed files
vim.opt.confirm = true

-- Use visual bell instead of beeping when doing something wrong
vim.opt.visualbell = true
vim.opt.errorbells = false

-- Show special characters
vim.opt.list = true
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

-- When scrolling to the top or bottom of the screen, keep 2 lines between the cursor and the edge of the screen
vim.opt.scrolloff = 2

-- Configure and enable spell checking (without capitalization check)
vim.opt.spelllang = "en_us"
vim.opt.spellfile = vim.fn.stdpath("data") .. "/en.utf-8.add"
vim.opt.spellcapcheck = ""
vim.opt.spell = true

-- Display line numbers with relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Use new second stage diff option to improve nvim diff view
vim.opt.diffopt:append("linematch:60")

-- Auto-toggling of relative numbers. This will disable relative numbers for panes that do not have focus, and will
-- also disable relative numbers in insert mode. Don't mess with relative numbers if the buffer doesn't have numbers
-- enabled.
local numbertoggle = vim.api.nvim_create_augroup("numbertoggle", {})
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave" }, {
    callback = function()
        if vim.wo.number then
            vim.wo.relativenumber = true
        end
    end,
    group = numbertoggle,
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter" }, {
    callback = function()
        if vim.wo.number then
            vim.wo.relativenumber = false
        end
    end,
    group = numbertoggle,
})

-- When opening a new line and no filetype-specific indenting is enabled, keep the same indent as the line you're
-- currently on. Useful for READMEs, etc
vim.opt.autoindent = true

-- Default indentation settings. Display tabs as four characters wide, insert tabs as 4 spaces
local indent = 4
vim.opt.tabstop = indent
vim.opt.softtabstop = indent
vim.opt.shiftwidth = indent
vim.opt.expandtab = true

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

-- By default, don't wrap text
vim.opt.wrap = false

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

-- Add a ruler to visually indicate the file's textwidth setting
vim.opt.colorcolumn = "+1"

-- Set the default location of window splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Set up code folding for 'nvim-ufo'
vim.opt.foldcolumn = "auto:9"
vim.opt.foldlevel = 99
vim.opt.foldenable = true

vim.opt.fillchars = {
    -- Customize how folds are displayed
    fold = " ",
    foldopen = "",
    foldsep = "│",
    foldclose = "",
}

-- Speed up CursorHold autocommand events
vim.opt.updatetime = 300

-- Set pop-up-menu transparency
vim.opt.pumblend = 30

-- Avoid showing extra messages when using completion: append 'c'
-- Remove 'F' (required by 'scalameta/nvim-metals')
vim.o.shortmess = string.gsub(vim.o.shortmess, "F", "") .. "c"

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
