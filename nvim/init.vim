function! VimrcLoadPlugins()
    " Install vim-plug if not available
    let plug_install = 0
    let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
    if !filereadable(autoload_plug_path)
        silent execute '!curl -fLo ' . autoload_plug_path . ' --create-dirs '
            \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        execute 'source ' . fnameescape(autoload_plug_path)
        let plug_install = 1
    endif
    unlet autoload_plug_path

    call plug#begin(stdpath('data') . '/plugged')

    " Column-align multiple lines
    Plug 'junegunn/vim-easy-align'

    " Tempus colors in vim
    Plug 'https://gitlab.com/protesilaos/tempus-themes-vim.git'

    " Allow user-defined text objects (needed for vim-textobj-line)
    Plug 'kana/vim-textobj-user'

    " Make a new text object for the current line
    Plug 'kana/vim-textobj-line'

    " Make a new text object for lines at the same indent level
    Plug 'michaeljsmith/vim-indent-object'

    " Add new vim verb for surrounding text objects
    Plug 'tpope/vim-surround'

    " Add new vim verb for commenting out lines
    Plug 'tpope/vim-commentary'

    " Integration for fzf in vim
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " Add ability to easily open new files up to a specific line/column
    Plug 'kopischke/vim-fetch'

    " Add ability to use dot operator (.) to repeat plugin map operations
    Plug 'tpope/vim-repeat'

    " Add nice integration with git
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'

    " Languages
    Plug 'rust-lang/rust.vim'

    " Neovim in the browser
    Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

    " Treesitter integration into neovim
    Plug 'nvim-treesitter/nvim-treesitter'

    " Collection of common configurations for the Nvim LSP client
    Plug 'neovim/nvim-lspconfig'

    " Extensions to built-in LSP, for example, providing type inlay hints
    Plug 'nvim-lua/lsp_extensions.nvim'

    " Autocompletion framework for built-in LSP
    Plug 'nvim-lua/completion-nvim'

    " Diagnostic navigation and settings for built-in LSP
    Plug 'nvim-lua/diagnostic-nvim'

    call plug#end()

    " Run PlugInstall if there are missing plugins
    if plug_install || len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        PlugInstall --sync
    endif
    unlet plug_install
endfunction

function! VimrcLoadPluginSettings()
    " fzf

    let g:fzf_command_prefix = 'Fzf'

    " Search other files for code using ripgrep
    command! -bang -nargs=* FzfRg
                \ call fzf#vim#grep(
                \ 'rg --column --line-number --no-heading --ignore-case --follow --color always '.shellescape(<q-args>), 1,
                \ <bang>1 ? fzf#vim#with_preview('up:60%')
                \         : fzf#vim#with_preview('right:50%:hidden', '?'),
                \ <bang>0)

    " gitgutter

    let g:gitgutter_grep = 'rg --color=never'

    " LSP diagnostics (nvim-lua/diagnostic-nvim)

    " Visualize diagnostics
    let g:diagnostic_enable_virtual_text = 1
    let g:diagnostic_trimmed_virtual_text = '40'

    " Don't show diagnostics while in insert mode
    let g:diagnostic_insert_delay = 1

    " LSP extensions (nvim-lua/lsp_extensions.nvim)

    " Enable type inlay hints
    autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
        \ lua require'lsp_extensions'.inlay_hints {
        \   prefix = ' » ',
        \   highlight = "NonText"
        \ }

    " Treesitter

    luafile ~/.config/nvim/lua/treesitter.lua
endfunction

function! VimrcLoadMappings()
    let g:mapleader=','       " map by , instead of /
    let g:maplocalleader='\'  " map local by \

    " clear search
    nmap <silent> <leader>/ :nohlsearch<CR>

    " spelling
    nnoremap <silent> <leader>s :set spell!<CR>

    " Delete trailing whitespace
    nnoremap <silent> <leader>w :call TrimWhitespace()<CR>

    " Split window navigation
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l

    " Buffer navigation
    map  ga <C-^>
    nmap gn :bn<CR>
    nmap gp :bp<CR>
    nmap gk :bp<bar>bd #<CR>

    " Start interactive EasyAlign in visual mode (e.g. vipgs)
    xmap gs <Plug>(EasyAlign)

    " Start interactive EasyAlign for a motion/text object (e.g. gsip)
    nmap gs <Plug>(EasyAlign)

    " Enable code folding with the spacebar
    nnoremap <space> za

    " fzf mappings
    nnoremap <leader>h       <Cmd>FzfHistory<CR>
    nnoremap <leader>b       <Cmd>FzfBuffers<CR>
    nnoremap <leader>f       <Cmd>FzfFiles<CR>
    nnoremap <leader><space> <Cmd>FzfRg<CR>

    " LSP

    nnoremap <silent> gd <Cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> gh <Cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent> gD <Cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <silent> gH <Cmd>lua vim.lsp.buf.signature_help()<CR>
    nnoremap <silent> gr <Cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> gi <Cmd>lua vim.lsp.buf.formatting()<CR>

    nnoremap <silent> g[ <Cmd>PrevDiagnosticCycle<CR>
    nnoremap <silent> g] <Cmd>NextDiagnosticCycle<CR>

    " Trigger completion with <tab>
    inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>CheckBackSpace() ? "\<TAB>" :
        \ completion#trigger_completion()

    " Remove trailing whitespace without affecting the cursor location/search
    " history.
    function! TrimWhitespace()
        let l:save = winsaveview()
        %s/\s\+$//e
        call winrestview(l:save)
    endfun

    function! s:CheckBackSpace() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1] =~ '\s'
    endfunction
endfunction

function! VimrcLoadSettings()
    " Set the command window height to 2 lines, to avoid many cases of having
    " to 'press <Enter> to continue'
    set cmdheight=2

    " Make sure all windows that aren't in focus always have a status line
    set laststatus=2

    " This allows you to switch from an unsaved buffer without saving it
    " first. Also allows you to keep an undo history for multiple files.
    " Vim will complain if you try to quit without saving, and swap files
    " will keep you safe if your computer crashes.
    set hidden

    " Search settings
    set hlsearch    " highlight search
    set incsearch   " reveal search incrementally as typed
    set ignorecase  " case-insensitive match...
    set smartcase   " ...except when uppercase letters are given

    " Instead of failing a command because of unsaved changes, raise a prompt
    " asking if you wish to save changed files
    set confirm

    " Use visual bell instead of beeping when doing something wrong
    set visualbell
    set noerrorbells

    " Showing special characters:
    set list
    set listchars=
    " Place a '#' in the last column when 'wrap' is off and the line continues
    " beyond the right of the screen
    set listchars+=extends:#,
    " Place a '#' in the first column when 'wrap' is off and there is text
    " preceding the character visible in the first column
    set listchars+=precedes:#,
    " Show non-breaking space characters as ¬
    set listchars+=nbsp:¬,
    " Show tabs as ▸ followed by spaces
    set listchars+=tab:▸\ ,
    " Show trailing spaces as ◊
    set listchars+=trail:◊,

    " When scrolling to the top or bottom of the screen, keep 2 lines between
    " the cursor and the edge of the screen
    set scrolloff=2

    " Configure and enable spell checking (without capitalization check)
    set spelllang=en_us
    set spellfile=~/.local/share/nvim/en.utf-8.add
    set spellcapcheck=''
    set spell

    " Display line numbers with relative line numbers
    set number
    set relativenumber

    " Auto-toggling of relative numbers. This will disable relative numbers
    " for panes that do not have focus, and will also disable relative numbers
    " in insert mode
    augroup numbertoggle
        autocmd!
        autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
        autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
    augroup END

    " When opening a new line and no filetype-specific indenting is enabled,
    " keep the same indent as the line you're currently on. Useful for
    " READMEs, etc
    set autoindent

    " Default indentation settings. Display tabs as four characters wide,
    " insert tabs as 4 spaces
    set tabstop=4
    set softtabstop=4
    set shiftwidth=4
    set expandtab

    " By default, don't wrap text
    set nowrap

    " Default textwidth
    " set textwidth=99

    " Add a ruler to visually indicate the file's textwidth setting
    set colorcolumn=+1

    " Set the default location of window splits
    set splitbelow
    set splitright

    " Enable code folding, initialize with folds disabled
    set foldmethod=indent
    set foldlevel=99

    " Indicate if folded lines have been changed
    set foldtext=gitgutter#fold#foldtext()

    " Rapidly write swap file to disk, which speeds up gitgutter updates
    set updatetime=100

    " Set pop-up-menu transparency.
    set pumblend=30

    " LSP settings

    luafile ~/.config/nvim/lua/lsp.lua

    " Show diagnostic popup on cursor hover
    autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()

    " Set completeopt to have a better completion experience
    set completeopt=menuone,noinsert,noselect

    " Avoid showing extra messages when using completion
    set shortmess+=c
endfunction

function! VimrcLoadColors()
    colorscheme tempus_summer

    set termguicolors

    " Set custom highlighting for various spelling mistakes
    highlight clear SpellBad
    highlight SpellBad cterm=underline
    highlight clear SpellCap
    highlight SpellCap cterm=underline
    highlight clear SpellLocal
    highlight SpellLocal cterm=underline
    highlight clear SpellRare
    highlight SpellRare cterm=underline

    " Highlight ruler
    highlight ColorColumn ctermbg=18
endfunction

call VimrcLoadPlugins()
call VimrcLoadPluginSettings()
call VimrcLoadMappings()
call VimrcLoadSettings()
call VimrcLoadColors()
