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
cmd([[autocmd BufWritePost plugins.lua PackerCompile]])

--
-- Plugin settings
--

-- gitsigns.nvim

require("gitsigns").setup({
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
})

-- Treesitter

-- Haskell treesitter plugin uses C++11 features, but macOS clang doesn't enable those by default.
if fn.has("mac") == 1 then
    require("nvim-treesitter.install").compilers = { "gcc-11" }
end

require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    highlight = { enable = true },
    rainbow = { enable = true },
})

-- spellsitter.nvim
require("spellsitter").setup()

-- nvim-cmp

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },

    mapping = {
        ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<C-p>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            end
        end, { "i", "s" }),

        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
    },

    sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "vsnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "calc" },
    },

    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = "",
                buffer = "",
            })[entry.source.name]
            vim_item.kind = ({
                Text = "",
                Method = "",
                Function = "",
                Constructor = "",
                Field = "",
                Variable = "",
                Class = "",
                Interface = "ﰮ",
                Module = "",
                Property = "",
                Unit = "",
                Value = "",
                Enum = "",
                Keyword = "",
                Snippet = "﬌",
                Color = "",
                File = "",
                Reference = "",
                Folder = "",
                EnumMember = "",
                Constant = "",
                Struct = "",
                Event = "",
                Operator = "ﬦ",
                TypeParameter = "",
            })[vim_item.kind] .. " " .. vim_item.kind
            return vim_item
        end,
    },
})

-- Setup status line (lualine)
require("statusline").setup()

-- telescope.nvim
require("telescope").setup({
    defaults = {
        mappings = {
            i = { ["<c-t>"] = require("trouble.providers.telescope").open_with_trouble },
            n = { ["<c-t>"] = require("trouble.providers.telescope").open_with_trouble },
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

-- trouble.nvim
require("trouble").setup({})

--
-- Mappings
--

g.mapleader = [[,]] -- map by , instead of /
g.maplocalleader = [[\]] -- map local by \

-- clear search
utils.map("n", "<leader>/", "<Cmd>nohlsearch<CR>", { silent = true })

-- spelling
utils.map("n", "<leader>s", "<Cmd>set spell!<CR>", { silent = true })

-- Delete trailing whitespace
utils.map("n", "<leader>w", "<Cmd>call v:lua.trim_whitespace()<CR>", { silent = true })

-- Split window navigation
utils.map("n", "<C-h>", "<C-w>h")
utils.map("n", "<C-j>", "<C-w>j")
utils.map("n", "<C-k>", "<C-w>k")
utils.map("n", "<C-l>", "<C-w>l")

-- Buffer navigation (barbar.nvim commands)
utils.map("n", "gn", "<Cmd>BufferNext<CR>")
utils.map("n", "gp", "<Cmd>BufferPrevious<CR>")
utils.map("n", "gk", "<Cmd>BufferClose<CR>")

-- EasyAlign
-- Note that '<Plug>' mappings depend on the 'noremap' option being unset, so we can't use the 'map' function

-- Start interactive EasyAlign in visual mode (e.g. vipgs)
vim.api.nvim_set_keymap("x", "gs", "<Plug>(EasyAlign)", {})
-- Start interactive EasyAlign for a motion/text object (e.g. gsip)
vim.api.nvim_set_keymap("n", "gs", "<Plug>(EasyAlign)", {})

-- Enable code folding with the spacebar
utils.map("n", "<space>", "za")

-- telescope.nvim
utils.map("n", "<leader>ff", '<Cmd>lua require("telescope.builtin").find_files()<CR>')
utils.map("n", "<leader>fg", '<Cmd>lua require("telescope.builtin").live_grep()<CR>')
utils.map("n", "<leader>fb", '<Cmd>lua require("telescope.builtin").buffers()<CR>')
utils.map("n", "<leader>fh", '<Cmd>lua require("telescope.builtin").help_tags()<CR>')

-- Remove trailing whitespace without affecting the cursor location/search history
function _G.trim_whitespace()
    if not vim.o.binary and vim.o.filetype ~= "diff" then
        local current_view = fn.winsaveview()
        cmd([[keeppatterns %s/\s\+$//e]])
        fn.winrestview(current_view)
    end
end

--
-- Settings
--

-- Set the command window height to 2 lines, to avoid many cases of having to 'press <Enter> to continue'
opt("o", "cmdheight", 2)

-- Don't show what mode we're in on the last line, the status line takes care of that
opt("o", "showmode", false)

-- Make sure all windows that aren't in focus always have a status line
opt("o", "laststatus", 2)

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
-- also disable relative numbers in insert mode
utils.create_augroup("numbertoggle", {
    { "BufEnter,FocusGained,InsertLeave", "*", "set relativenumber" },
    { "BufLeave,FocusLost,InsertEnter", "*", "set norelativenumber" },
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

-- By default, don't wrap text
opt("w", "wrap", false)

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

-- LSP settings

require("lsp")

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
