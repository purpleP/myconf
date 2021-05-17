filetype plugin indent on
syntax enable

set autowriteall
set breakindent
set completeopt=menuone,preview,noselect
set diffopt+=algorithm:histogram
set diffopt+=indent-heuristic
set diffopt-=internal
set fileformat=unix
set foldlevel=99
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
nnoremap <C-L> 20zl
nnoremap <C-H> 20zh

if has('nvim')
    augroup terminal
        au!
        au TermOpen * setlocal nonu nornu
    augroup END
endif

augroup ColorColumn
    au!
    au WinEnter,BufEnter *.py\|*.vim\|*vimrc\|*.java\|*.hs\|*.rs call matchadd('ColorColumn', '\%81v', 100)
augroup END

augroup AutoWrite
    au!
    au BufWritePre * call system('mkdir -p '.shellescape(expand('%:p:h')))
    au WinLeave * silent! w
    au CursorHold * if &buftype == '' | silent! checktime | endif
    au FocusLost * silent! wall | setlocal nornu
    au FocusGained * if &buftype == '' | setlocal rnu | silent! checktime | endif
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

lua <<EOF
require'nvim-treesitter.configs'.setup {
  indent = {
    enable = true
  },
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}
EOF
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
lua <<EOF
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

require'lspconfig'.rust_analyzer.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 80;
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
EOF
inoremap <silent><expr> <C-y> compe#confirm('<CR>')
inoremap <silent><expr> <C-e> compe#close('<C-e>')
inoremap <silent><expr> <C-f> compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d> compe#scroll({ 'delta': -4 })
