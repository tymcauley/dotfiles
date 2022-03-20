-- Prelude

local utils = require("utils")

local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables

local scopes = { o = vim.o, b = vim.bo, w = vim.wo }

local function opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= "o" then
        scopes["o"][key] = value
    end
end

--
-- Plugins
--

-- Bootstrap packer installation
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.api.nvim_command("packadd packer.nvim")
end

require("plugins")

-- Compile packer config whenever 'plugins.lua' changes
local packer_user_config = vim.api.nvim_create_augroup("packer_user_config", {})
vim.api.nvim_create_autocmd(
    "BufWritePost",
    { pattern = "plugins.lua", command = "source <afile> | PackerCompile", group = packer_user_config }
)

--
-- Mappings
--

g.mapleader = [[,]] -- map by , instead of /
g.maplocalleader = [[\]] -- map local by \

-- clear search
vim.keymap.set("n", "<leader>/", ":nohlsearch<CR>", { silent = true })

-- spelling
vim.keymap.set("n", "<leader>s", "<Cmd>set spell!<CR>", { silent = true })

-- Delete trailing whitespace
vim.keymap.set("n", "<leader>w", function()
    if not vim.o.binary and vim.o.filetype ~= "diff" then
        local current_view = fn.winsaveview()
        cmd([[keeppatterns %s/\s\+$//e]])
        fn.winrestview(current_view)
    end
end, { silent = true })

-- Split window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Buffer navigation (barbar.nvim commands)
vim.keymap.set("n", "gn", "<Cmd>BufferNext<CR>")
vim.keymap.set("n", "gp", "<Cmd>BufferPrevious<CR>")
vim.keymap.set("n", "gk", "<Cmd>BufferClose<CR>")

-- EasyAlign
-- Note that '<Plug>' mappings depend on the 'noremap' option being unset, so we can't use the 'map' function

-- Start interactive EasyAlign in visual mode (e.g. vipgs)
vim.keymap.set("x", "gs", "<Plug>(EasyAlign)")
-- Start interactive EasyAlign for a motion/text object (e.g. gsip)
vim.keymap.set("n", "gs", "<Plug>(EasyAlign)")

-- Enable code folding with the spacebar
vim.keymap.set("n", "<space>", "za")

--
-- Settings
--

-- Set the command window height to 2 lines, to avoid many cases of having to 'press <Enter> to continue'
opt("o", "cmdheight", 2)

-- Don't show what mode we're in on the last line, the status line takes care of that
opt("o", "showmode", false)

-- Enable global statusline
opt("o", "laststatus", 3)

-- This allows you to switch from an unsaved buffer without saving it first. Also allows you to keep an undo history
-- for multiple files. Vim will complain if you try to quit without saving, and swap files will keep you safe if your
-- computer crashes.
opt("o", "hidden", true)

-- Search settings
opt("o", "hlsearch", true) -- highlight search
opt("o", "incsearch", true) -- reveal search incrementally as typed
opt("o", "ignorecase", true) -- case-insensitive match...
opt("o", "smartcase", true) -- ...except when uppercase letters are given

-- Instead of failing a command because of unsaved changes, raise a prompt asking if you wish to save changed files
opt("o", "confirm", true)

-- Use visual bell instead of beeping when doing something wrong
opt("o", "visualbell", true)
opt("o", "errorbells", false)

-- Show special characters
opt("w", "list", true)
local listchars = ""
-- Place a '#' in the last column when 'wrap' is off and the line continues beyond the right of the screen
listchars = listchars .. "extends:#,"
-- Place a '#' in the first column when 'wrap' is off and there is text preceding the character visible in the first
-- column
listchars = listchars .. "precedes:#,"
-- Show non-breaking space characters as ¬
listchars = listchars .. "nbsp:¬,"
-- Show tabs as ▸ followed by spaces
listchars = listchars .. "tab:▸ ,"
-- Show trailing spaces as ◊
listchars = listchars .. "trail:◊,"
opt("w", "listchars", listchars)

-- When scrolling to the top or bottom of the screen, keep 2 lines between the cursor and the edge of the screen
opt("o", "scrolloff", 2)

-- Configure and enable spell checking (without capitalization check)
opt("b", "spelllang", "en_us")
opt("b", "spellfile", "~/.local/share/nvim/en.utf-8.add")
opt("b", "spellcapcheck", "")
opt("w", "spell", true)

-- Display line numbers with relative line numbers
opt("w", "number", true)
opt("w", "relativenumber", true)

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
opt("b", "autoindent", true)

-- Default indentation settings. Display tabs as four characters wide, insert tabs as 4 spaces
local indent = 4
opt("b", "tabstop", indent)
opt("b", "softtabstop", indent)
opt("b", "shiftwidth", indent)
opt("b", "expandtab", true)

-- Filetype-specific overrides for indentation
local override_indents = vim.api.nvim_create_augroup("override_indents", {})
vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = "haskell", command = "setlocal softtabstop=2 shiftwidth=2", group = override_indents }
)

-- By default, don't wrap text
opt("w", "wrap", false)

-- Filetype-specific overrides for 'textwidth'
local override_textwidth = vim.api.nvim_create_augroup("override_textwidth", {})
vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = "lua", command = "setlocal textwidth=119", group = override_textwidth }
)
vim.api.nvim_create_autocmd(
    "FileType",
    { pattern = "scala", command = "setlocal textwidth=119", group = override_textwidth }
)

-- Add a ruler to visually indicate the file's textwidth setting
opt("w", "colorcolumn", "+1")

-- Set the default location of window splits
opt("o", "splitbelow", true)
opt("o", "splitright", true)

-- Enable code folding using Treesitter, initialize with folds disabled
opt("w", "foldmethod", "expr")
opt("w", "foldexpr", "nvim_treesitter#foldexpr()")
opt("w", "foldlevel", 99)

-- Speed up CursorHold autocommand events
opt("o", "updatetime", 300)

-- Set pop-up-menu transparency
opt("o", "pumblend", 30)

-- Disable unnecessary built-in plugins
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit",
}
for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

-- Avoid showing extra messages when using completion: append 'c'
-- Remove 'F' (required by 'scalameta/nvim-metals')
vim.o.shortmess = string.gsub(vim.o.shortmess, "F", "") .. "c"

-- Highlight text after yanking it
cmd("autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = false}")

--
-- Colors
--

cmd("colorscheme tokyonight")

opt("o", "termguicolors", true)

-- barbar.nvim
-- Make all modified buffers bold
utils.hi("BufferCurrentMod", { gui = "bold" })
utils.hi("BufferInactiveMod", { gui = "bold" })
utils.hi("BufferVisibleMod", { gui = "bold" })
