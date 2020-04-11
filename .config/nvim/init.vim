filetype plugin indent on
syntax enable

set autowriteall
set breakindent
set completeopt=menuone,preview
set diffopt+=algorithm:histogram
set diffopt+=indent-heuristic
set diffopt-=internal
set fileformat=unix
set foldlevel=99
set foldmethod=indent
set lazyredraw
set mouse-=a
set number
set relativenumber
set shortmess+=A
set shortmess+=c
set showtabline=0
set signcolumn=no
set smartcase
set splitbelow
set splitright
set termguicolors
set virtualedit=insert
set wildcharm=<TAB>
set wildignore+=*.class,*.pyc,*.so,*.swp,*.zip,.*/**
set winminheight=0
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab


if !has('nvim')
    set backspace=indent,eol,start
    set encoding=utf-8
    set hlsearch
    set incsearch
    set wildmenu
endif

set grepformat=%f:%l:%c:%m
set grepprg=rg\ --vimgrep

if has('persistent_undo')
    set undodir=~/.undodir/
    set undofile
endif

if has('nvim')
    set inccommand=nosplit
    set wildoptions=pum
endif

silent! colorscheme solarized

let mapleader = "\<Space>"
nnoremap <silent> <leader>* :let @/ = '\<' . expand('<cword>') . '\>' <bar> set hlsearch<CR>
nnoremap <C-L> 20zl
nnoremap <C-H> 20zh

if has('nvim')
    augroup terminal
        au!
        au TermOpen * setlocal nonu nornu
    augroup END
endif

augroup myvimrc
    au!
    au BufWritePost *vimrc\|*init.vim source $MYVIMRC
    au BufEnter .vimrc set ft=vim
augroup END

augroup ColorColumn
    au!
    au WinEnter,BufEnter *.py\|*.vim\|*vimrc\|*.java\|*.hs call matchadd('ColorColumn', '\%81v', 100)
augroup END

augroup AutoWrite
    au!
    au BufWritePre * call system('mkdir -p '.shellescape(expand('%:p:h')))
    au WinLeave * silent! w
    au CursorHold * if &buftype == '' | silent! checktime | endif
    au FocusLost * silent! wall
    au FocusGained * if &buftype == '' | silent! checktime | endif
augroup END

set statusline=%t\ %m\ %h\ %r\ %{winnr()}\%=%l:%v/%L\ %p%%
augroup StatusLine
    au!
    au WinEnter,WinLeave,WinNew * redrawstatus!
augroup END

inoremap <silent> <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent> <expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

cnoremap <expr> <Tab> index(['/', '?'], getcmdtype()) == -1 ? "<TAB>": "<C-G>" 
cnoremap <expr> <S-Tab> index(['/', '?'], getcmdtype()) == -1 ? "<S-TAB>": "<C-T>" 

if &diff
    syntax off
endif

augroup Quickfix
    au!
    au QuickFixCmdPost [^l]* nested cwindow
    au QuickFixCmdPost *l nested lwindow
augroup END
