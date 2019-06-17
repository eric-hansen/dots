set nocompatible
set tabstop=4
set shiftwidth=4
set expandtab
set number
set relativenumber
set nobackup
set noswapfile
set nowritebackup
set ignorecase
set hlsearch
set smartindent
set undodir=~/.vim/.cache/undo_dir/
set wrap linebreak nolist
set undofile
set smartcase
set mouse=a
set clipboard=unnamedplus
set colorcolumn=120
set nocursorline
set hidden
set signcolumn=yes
set wildmenu
set lazyredraw
set encoding=utf-8
set smarttab
set t_Co=256
set incsearch
set noshowmode

function! CopyPointToClipboard()
    let currentClipboard=&clipboard
    let currentData = getreg('*')
    echohl String | echon 'Current clipboard setting: ' . currentClipboard . 'with data: ' . currentData | echohl None
    let @* = currentData
endfunction

call plug#begin()

"    autocmd FileType php setlocal shiftwidth=4 softtabstop=4 expandtab

" Plugin frameworks
Plug 'roxma/nvim-yarp'

" NAB plugins (written by me or someone else)
" -- JIRA support
Plug '~/.config/nvim/plugged/nabjira'

" -- Docker stuff 
Plug '~/.config/nvim/plugged/docker'

" General and other things
Plug 'itchyny/lightline.vim'
function! GetRelativeFilename()
  return expand('%')
endfunction

function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf('%dW %dE', all_non_errors, all_errors)
endfunction

let g:lightline = {
            \ 'active': {
            \   'left': [['mode', 'paste'],
            \     ['gitbranch',  'linter_status', 'filename', 'modified']]
            \    },
            \ 'component_function': {
            \   'gitbranch': 'fugitive#head',
            \   'filename': 'GetRelativeFilename',
            \   'linter_status': 'LinterStatus'
            \}
\ }

" let g:lightline.colorscheme = 'seoul256'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<c-f>"
    let g:UltiSnipsJumpBackwardTrigger="<c-b>"

" -- Less typing needed for matching pairs of things
Plug 'jiangmiao/auto-pairs'

" -- Color theme of the moment
" Plug 'dracula/vim'
Plug 'drewtempelmeyer/palenight.vim'

" -- Project management and the like
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
    nnoremap / :BLines<cr>
    nnoremap /saf :Lines<cr>

    " Lets you hit <esc> to close the quickfix window for FZF instead of esc,
    " then typing :q at the command line 
    if has("nvim")
        tnoremap <expr> <Esc> (&filetype == "fzf") ? "<Esc>" : "<c-\><c-n>"
"      au TermOpen * tnoremap <Esc> <c-\><c-n>
"      au FileType fzf tunmap <Esc>
    endif

" -- CTags generator
Plug 'ludovicchabant/vim-gutentags'

let g:gutentags_file_list_command = {
      \ 'markers': {
      \ '.git': 'git ls-files'
      \ }
      \ }

" ---- File explorer in Vim
Plug 'scrooloose/nerdtree'

" -- Git stuff
Plug 'tpope/vim-fugitive'

" Completion supports

" -- Completion system
Plug 'neoclide/coc.nvim', {'do': './install.sh nightly'}

" LanguageServer client for NeoVim.
Plug 'autozimu/LanguageClient-neovim', {
  \ 'branch': 'next',
  \ 'do': 'bash install.sh',
  \ }

" -- JS support
:Plug 'ncm2/ncm2-tern',  {'do': 'npm install'}

" -- PHP support
Plug 'StanAngeloff/php.vim', { 'for': 'php' }
Plug 'shawncplus/phpcomplete.vim'
Plug 'sheerun/vim-polyglot'

" -- DB support

Plug 'vim-vdebug/vdebug'

Plug 'w0rp/ale'

call plug#end()

" Color theme support
set background=dark
syntax on
color palenight
let g:lightline.colorscheme = 'palenight'

if (has("termguicolors"))
  set termguicolors
endif


set completeopt=noinsert,menuone,noselect

set shortmess+=c
inoremap <c-c> <ESC>

" Status line
set laststatus=2

" Keyboard mappings

" -- Split support (do c-* instead of c-wc-*)
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" -- NERDTree
noremap <leader>tb :NERDTreeToggle<cr>

if has("nvim")
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-k> <Up>
    tnoremap <C-j> <Down>
    tnoremap <C-h> <Left>
    tnoremap <C-l> <Right>
    tnoremap <A-h> <C-\><C-N><C-w>h
    tnoremap <A-k> <C-\><C-N><C-w>k
    tnoremap <A-l> <C-\><C-N><C-w>l
    tnoremap <A-j> <C-\><C-N><C-w>j 
endif

set splitbelow
set splitright

let g:mapleader = " "
map <Space> <Leader>

" -- Directional movement while in insert mode
inoremap <C-b> <C-left>
inoremap <C-f> <C-right>
inoremap <C-s> <C-o>^
inoremap <C-e> <C-o>$

" -- Navigating around buffers
nnoremap <silent> <leader>bn :bn<cr>
nnoremap <silent> <leader>bp :bp<cr>

" -- Key bindings for fzf
nnoremap <expr> <leader>f (FugitiveHead() != '' ? ':GFiles<cr>' : ':Files<cr>')
nmap <leader>t :Tags<cr>
nnoremap <leader>ft :BTags<cr>
nnoremap <leader>l :Lines<cr>
nnoremap <leader>fl :BLines<cr>

" List the available buffers
nnoremap <leader>lb :Buffers<cr>

" Destroy current buffer
nnoremap <leader>bd :bd<cr>

" VDebug PHP settings
let g:vdebug_options = {
            \ "debug_file": "~/vdebug.log", 
            \ "debug_file_level": 8,
            \ "path_maps": {"/var/www/html": "/Users/echansen/Projects/Dockerized/pa-php-api/mobile-api"},
            \ "break_on_open": 0,
            \ "port": 9001,
            \ "watch_window_style": "expanded",
            \ "window_arrangement": ["DebuggerWatch", "DebuggerStatus"]
\ }

let g:vdebug_keymaps = {
            \ "run": "<leader>dbg",
            \ "step_over": "<F2>",
            \ "step_into": "<F3>",
            \ "step_out": "<F4>",
            \ "set_breakpoint": "<leader>sbp"
            \ }

" COC things
inoremap <expr> <CR> (pumvisible() ? "\<c-y>" : "\<CR>")
set cmdheight=2
set updatetime=300
set signcolumn=yes

" -- Lookup definition
nmap <silent> <leader>sd <Plug>(coc-definition)
" -- Lookup type definition
nmap <silent> <leader>std <Plug>(coc-type-definition)
" -- Lookup implementation
nmap <silent> <leader>si <Plug>(coc-implementation)
" -- Lookup references
nmap <silent> <leader>sr <Plug>(coc-references)

" Copy path info to system clipboard
" -- Relative path
nnoremap <silent> <leader>crp :let @+ = expand("%")<cr>
" -- Full path
nnoremap <silent> <leader>cfp :let @+ = expand("%:p")<cr>
" -- Filename only
nnoremap <silent> <leader>cfo :let @+ = expand("%:t")<cr>

" Highlight symbol under cursor on CursorHold
augroup CocSupport
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

" Edit vim file
nnoremap <leader>vf :e ~/.config/nvim/init.vim<cr>
" Resource vim file
nnoremap <leader>vs :source ~/.config/nvim/init.vim<cr>

function! s:buflisted()
  " bufnr('$') returns the ID of the current buffer, we then filter all the
  " listed buffers (from :ls) and remove the quickfix buffers if it is
  " unlisted
  return filter(range(1, bufnr('$')), 'buflisted(v:val) && getbufvar(v:val, "&filetype") != "qf"')
endfunction

function! s:KillBuffer(b)
  " Runs :bd on the provided buffer, fails if buffer is modified
  execute printf("bd %s", a:b)
endfunction

function! s:ManageOpenBuffers(lines)
  " a:lines is populated with all the marked items from the fzf dealio.  So we
  " are given an array (a:lines = argument:lines), we then loop through that
  " array and call the KillBuffer command.  This can be replaced by doing the
  " execute call within the for loop, but I'm not. :)
  for b in a:lines
    call s:KillBuffer(b)
  endfor
endfunction

function! s:FormatBuffer(b)
  " Gets the fancy name of the buffer instead of the ID
  return bufname(a:b)
endfunction

  function! s:function(name)
    return function(a:name)
  endfunction

function! MultiSelectBuffers()
  call fzf#run({
        \   'options': ['-m', '+x', '--tiebreak=index', '--header-lines=1', '-d', '\t', '-n', '2,1..2', '--prompt', 'Buffers> '],
        \   'source': map(s:buflisted(), 's:FormatBuffer(v:val)'),
        \   'sink*': function('s:ManageOpenBuffers')
        \})
endfunction

command! -bang -nargs=? ChooseBuffers call MultiSelectBuffers()

" -- ALE/JS Stuff
let b:ale_linters = {'javascript.jsx': ['prettier', 'jshint']}

" JS autocommands
augroup JSSupport
  autocmd!
  autocmd FileType javascript* setl tabstop=2 shiftwidth=2 expandtab
augroup END
