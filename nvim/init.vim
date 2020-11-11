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

    " Status bar
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'edkolev/tmuxline.vim'

    " Column-align multiple lines
    Plug 'junegunn/vim-easy-align'

    " Base16 colors in vim
    Plug 'chriskempson/base16-vim'

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

    " LSP
    Plug 'dense-analysis/ale'

    " Neovim in the browser
    Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

    call plug#end()

    " Run PlugInstall if there are missing plugins
    if plug_install || len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        PlugInstall --sync
    endif
    unlet plug_install
endfunction

function! VimrcLoadPluginSettings()
    " airline

    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif

    let g:airline_theme = 'base16_classic'

    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''
    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.paste = 'ρ'
    let g:airline_symbols.spell = 'Ꞩ'

    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#formatter = 'default'

    let g:airline#extensions#tmuxline#enabled = 1
    let g:airline#extensions#tmuxline#snapshot_file = "~/.tmux-statusline-colors.conf"

    let g:airline#extensions#ale#enabled = 1

    " fzf

    let g:fzf_command_prefix = 'Fzf'

    " Search other files for code using ripgrep
    command! -bang -nargs=* FzfRg
                \ call fzf#vim#grep(
                \ 'rg --column --line-number --no-heading --ignore-case --follow --color always '.shellescape(<q-args>), 1,
                \ <bang>1 ? fzf#vim#with_preview('up:60%')
                \         : fzf#vim#with_preview('right:50%:hidden', '?'),
                \ <bang>0)

    " tmuxline

    let l:tmux_widget_are_keys_off = '#([ "$(tmux show-option -qv key-table)" = "off" ] && echo "[OFF] ")'
    let g:tmuxline_preset = {
        \'a'    : '#S',
        \'win'  : ['#I', '#W#F'],
        \'cwin' : ['#I', '#W'],
        \'y'    : [l:tmux_widget_are_keys_off . '%a %b %d %Y', '%H:%M %Z'],
        \'z'    : '#h',
        \'options' : {'status-justify' : 'left'}}

    " ale

    " De-prioritize all lint commands.
    let g:ale_command_wrapper = 'nice -n4'

    " Open ALE preview window when the cursor moves onto lines with problems.
    let g:ale_cursor_detail = 1

    " Enable auto-complete with ALE.
    let g:ale_completion_enabled = 1

    let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'c': ['clang-format'],
    \   'cpp': ['clang-format'],
    \   'json': ['jq'],
    \   'python': ['black'],
    \   'rust': ['rustfmt'],
    \   'scala': ['scalafmt'],
    \   'sh': ['shfmt'],
    \}

    let g:ale_linters = {
    \   'c': ['ccls'],
    \   'cpp': ['ccls'],
    \   'rust': ['analyzer'],
    \   'scala': ['metals', 'scalastyle'],
    \}

    " Options for JSON fixer, jq:
    " * Indents should be 4 spaces.
    let g:ale_json_jq_options = '--indent 4'

    " Options for Shell script fixer, shfmt:
    " * Indents should be 4 spaces.
    let g:ale_sh_shfmt_options = '-i 4'

    let g:ale_c_ccls_init_options = {
    \   'compilationDatabaseCommand': 'compiledb make'
    \ }

    let g:ale_cpp_ccls_init_options = {
    \   'compilationDatabaseCommand': 'compiledb make'
    \ }

    " gitgutter

    let g:gitgutter_grep = 'rg --color=never'
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
    nnoremap <leader>p :FzfHistory<CR>
    nnoremap <leader>b :FzfBuffers<CR>
    nnoremap <leader>t :FzfFiles<CR>
    nnoremap <leader>f :FzfRg<CR>

    " ALE mappings
    nnoremap <leader>d :ALEGoToDefinition<CR>
    nnoremap <leader>r :ALEFindReferences<CR>
    nnoremap <leader>h :ALEHover<CR>
    nnoremap <leader>i :ALEFix<CR>
    nmap <silent> gj <Plug>(ale_next_wrap)

    " Function for removing trailing whitespace without affecting the cursor
    " location/search history:
    fun! TrimWhitespace()
        let l:save = winsaveview()
        %s/\s\+$//e
        call winrestview(l:save)
    endfun
endfunction

function! VimrcLoadSettings()
    " Set the command window height to 2 lines, to avoid many cases of having
    " to 'press <Enter> to continue'
    set cmdheight=2

    " Don't show what mode we're in on the last line, I'm already using
    " airline
    set noshowmode

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
endfunction

function! VimrcLoadColors()
    if filereadable(expand("~/.vimrc_background"))
      let g:base16colorspace=256
      source ~/.vimrc_background
    endif

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