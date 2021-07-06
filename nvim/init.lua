-- Prelude

local utils = require 'utils'

local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

-- Define key mappings with 'noremap' option enabled
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--
-- Plugins
--

-- Bootstrap packer installation
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.api.nvim_command 'packadd packer.nvim'
end

cmd [[packadd packer.nvim]]
require 'plugins'

-- Compile packer config whenever 'plugins.lua' changes
cmd [[autocmd BufWritePost plugins.lua PackerCompile]]

--
-- Plugin settings
--

-- gitgutter

g.gitgutter_grep = 'rg --color=never'

-- Treesitter

require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "bash",
        "c",
        "comment",
        "cpp",
        "devicetree",
        -- "haskell", -- Currently failing to build (2021-03-23)
        "html",
        "java",
        "javascript",
        "json",
        "latex",
        "lua",
        "nix",
        "python",
        "regex",
        "rst",
        "ruby",
        "rust",
        "scala",
        "toml",
        "verilog",
        "yaml",
    },
    highlight = {enable = true},
    rainbow = {enable = true},
}

-- nvim-compe
require'compe'.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 80;
    source_timeout = 200;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = true;

    source = {
        path = true;
        buffer = true;
        calc = true;
        nvim_lsp = true;
        nvim_lua = true;
        vsnip = true;
    };
}

-- galaxyline
require('statusline').setup()

-- telescope.nvim
require('telescope').setup({
    defaults = {
        winblend = 10,
    }
})

--
-- Mappings
--

g.mapleader = [[,]]       -- map by , instead of /
g.maplocalleader = [[\]]  -- map local by \

-- clear search
map('n', '<leader>/', '<Cmd>nohlsearch<CR>', {silent = true})

-- spelling
map('n', '<leader>s', '<Cmd>set spell!<CR>', {silent = true})

-- Delete trailing whitespace
map('n', '<leader>w', '<Cmd>call v:lua.trim_whitespace()<CR>', {silent = true})

-- Split window navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Buffer navigation (barbar.nvim commands)
map('n', 'gn', '<Cmd>BufferNext<CR>')
map('n', 'gp', '<Cmd>BufferPrevious<CR>')
map('n', 'gk', '<Cmd>BufferClose<CR>')

-- EasyAlign
-- Note that '<Plug>' mappings depend on the 'noremap' option being unset, so
-- we can't use the 'map' function

-- Start interactive EasyAlign in visual mode (e.g. vipgs)
vim.api.nvim_set_keymap('x', 'gs', '<Plug>(EasyAlign)', {})
-- Start interactive EasyAlign for a motion/text object (e.g. gsip)
vim.api.nvim_set_keymap('n', 'gs', '<Plug>(EasyAlign)', {})

-- Enable code folding with the spacebar
map('n', '<space>', 'za')

-- LSP
map('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>',        {silent = true})
map('n', 'gh', '<Cmd>lua vim.lsp.buf.hover()<CR>',             {silent = true})
map('n', 'gD', '<Cmd>lua vim.lsp.buf.implementation()<CR>',    {silent = true})
map('n', 'gH', '<Cmd>lua vim.lsp.buf.signature_help()<CR>',    {silent = true})
map('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>',        {silent = true})
map('n', 'gi', '<Cmd>lua vim.lsp.buf.formatting()<CR>',        {silent = true})
map('n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>',       {silent = true})
map('v', 'ga', '<Cmd>lua vim.lsp.buf.range_code_action()<CR>', {silent = true})
map('n', 'g[', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',  {silent = true})
map('n', 'g]', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>',  {silent = true})

-- telescope.nvim
map('n', '<leader>ff', '<Cmd>lua require("telescope.builtin").find_files()<CR>')
map('n', '<leader>fg', '<Cmd>lua require("telescope.builtin").live_grep()<CR>')
map('n', '<leader>fb', '<Cmd>lua require("telescope.builtin").buffers()<CR>')
map('n', '<leader>fh', '<Cmd>lua require("telescope.builtin").help_tags()<CR>')

-- nvim-compe
local compe_options = {silent = true, expr = true}
map('i', '<C-Space>', 'compe#complete()',              compe_options)
map('i', '<CR>',      'compe#confirm("<CR>")',         compe_options)
map('i', '<C-e>',     'compe#close("<C-e>")',          compe_options)
map('i', '<C-f>',     'compe#scroll({ "delta": +4 })', compe_options)
map('i', '<C-d>',     'compe#scroll({ "delta": -4 })', compe_options)

-- Remove trailing whitespace without affecting the cursor location/search
-- history
function _G.trim_whitespace()
    -- TODO: How can we restore the window view after executing this command?
    cmd [[%s/\s\+$//e]]
end

--
-- Settings
--

-- Set the command window height to 2 lines, to avoid many cases of having to
-- 'press <Enter> to continue'
opt('o', 'cmdheight', 2)

-- Don't show what mode we're in on the last line, the status line takes care
-- of that
opt('o', 'showmode', false)

-- Make sure all windows that aren't in focus always have a status line
opt('o', 'laststatus', 2)

-- This allows you to switch from an unsaved buffer without saving it first.
-- Also allows you to keep an undo history for multiple files. Vim will
-- complain if you try to quit without saving, and swap files will keep you
-- safe if your computer crashes.
opt('o', 'hidden', true)

-- Search settings
opt('o', 'hlsearch', true)    -- highlight search
opt('o', 'incsearch', true)   -- reveal search incrementally as typed
opt('o', 'ignorecase', true)  -- case-insensitive match...
opt('o', 'smartcase', true)   -- ...except when uppercase letters are given

-- Instead of failing a command because of unsaved changes, raise a prompt
-- asking if you wish to save changed files
opt('o', 'confirm', true)

-- Use visual bell instead of beeping when doing something wrong
opt('o', 'visualbell', true)
opt('o', 'errorbells', false)

-- Show special characters
opt('w', 'list', true)
local listchars = ''
-- Place a '#' in the last column when 'wrap' is off and the line continues
-- beyond the right of the screen
listchars = listchars..'extends:#,'
-- Place a '#' in the first column when 'wrap' is off and there is text
-- preceding the character visible in the first column
listchars = listchars..'precedes:#,'
-- Show non-breaking space characters as ¬
listchars = listchars..'nbsp:¬,'
-- Show tabs as ▸ followed by spaces
listchars = listchars..'tab:▸ ,'
-- Show trailing spaces as ◊
listchars = listchars..'trail:◊,'
opt('w', 'listchars', listchars)

-- When scrolling to the top or bottom of the screen, keep 2 lines between the
-- cursor and the edge of the screen
opt('o', 'scrolloff', 2)

-- Configure and enable spell checking (without capitalization check)
opt('b', 'spelllang', 'en_us')
opt('b', 'spellfile', '~/.local/share/nvim/en.utf-8.add')
opt('b', 'spellcapcheck', '')
opt('w', 'spell', true)

-- Display line numbers with relative line numbers
opt('w', 'number', true)
opt('w', 'relativenumber', true)

-- Auto-toggling of relative numbers. This will disable relative numbers for
-- panes that do not have focus, and will also disable relative numbers in
-- insert mode
utils.create_augroup("numbertoggle", {
    {"BufEnter,FocusGained,InsertLeave", "*", "set relativenumber"},
    {"BufLeave,FocusLost,InsertEnter",   "*", "set norelativenumber"},
})

-- When opening a new line and no filetype-specific indenting is enabled,
-- keep the same indent as the line you're currently on. Useful for
-- READMEs, etc
opt('b', 'autoindent', true)

-- Default indentation settings. Display tabs as four characters wide, insert
-- tabs as 4 spaces
local indent = 4
opt('b', 'tabstop', indent)
opt('b', 'softtabstop', indent)
opt('b', 'shiftwidth', indent)
opt('b', 'expandtab', true)

-- By default, don't wrap text
opt('w', 'wrap', false)

-- Add a ruler to visually indicate the file's textwidth setting
opt('w', 'colorcolumn', '+1')

-- Set the default location of window splits
opt('o', 'splitbelow', true)
opt('o', 'splitright', true)

-- Enable code folding, initialize with folds disabled
opt('w', 'foldmethod', 'indent')
opt('w', 'foldlevel', 99)

-- Indicate if folded lines have been changed
opt('w', 'foldtext', 'gitgutter#fold#foldtext()')

-- Rapidly write swap file to disk, which speeds up gitgutter updates
opt('o', 'updatetime', 100)

-- Set pop-up-menu transparency
opt('o', 'pumblend', 30)

-- Disable netrw (see ':help netrw-noload')
g.loaded_netrw       = 1
g.loaded_netrwPlugin = 1

-- LSP settings

require 'lsp'

-- Set completeopt to have a better completion experience
opt('o', 'completeopt', 'menuone,noinsert,noselect')

-- Avoid showing extra messages when using completion: append 'c'
-- Remove 'F' (required by 'scalameta/nvim-metals')
vim.o.shortmess = string.gsub(vim.o.shortmess, 'F', '') .. 'c'

-- Highlight text after yanking it
cmd 'autocmd TextYankPost * lua vim.highlight.on_yank {on_visual = false}'

--
-- Colors
--

cmd 'colorscheme tempus_summer'

opt('o', 'termguicolors', true)

-- For some reason, highlight settings require this strange workaround (an
-- autocmd which executes a function to set highlight settings after the color
-- scheme is loaded). All highlight settings should go in this function.
function MyHighlightSettings()
    -- Only underline spelling mistakes
    utils.hi("SpellBad",    {ctermfg = "NONE", ctermbg = "NONE", guifg = "NONE", guibg = "NONE", guisp = "NONE"})
    utils.hi("SpellCap",    {ctermfg = "NONE", ctermbg = "NONE", guifg = "NONE", guibg = "NONE", guisp = "NONE"})
    utils.hi("SpellLocal",  {ctermfg = "NONE", ctermbg = "NONE", guifg = "NONE", guibg = "NONE", guisp = "NONE"})
    utils.hi("SpellRare",   {ctermfg = "NONE", ctermbg = "NONE", guifg = "NONE", guibg = "NONE", guisp = "NONE"})
    -- Highlight ruler
    utils.hi("ColorColumn", {ctermbg = "18"})
    -- barbar.nvim
    -- Set 'Buffer*Mod' to the same highlighting as 'Buffer*', but make it bold
    utils.hi("BufferCurrentMod",  {gui = "bold", guifg = g.terminal_color_15, guibg = g.terminal_color_0})
    utils.hi("BufferInactiveMod", {gui = "bold", guifg = "#888888",           guibg = g.terminal_color_15})
    utils.hi("BufferVisibleMod",  {gui = "bold", guifg = g.terminal_color_0,  guibg = g.terminal_color_6})
    -- Enable LSP highlighting
    cmd([[hi! link LspReferenceText CursorColumn]])
    cmd([[hi! link LspReferenceRead CursorColumn]])
    cmd([[hi! link LspReferenceWrite CursorColumn]])
end
utils.create_augroup("MyHighlightSettings", {
    {"ColorScheme", "*", "lua MyHighlightSettings()"},
})
