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
lua << EOF
require'lspconfig'.rust_analyzer.setup{}
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<LEADER>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<LEADER>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<LEADER>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  Formatexpr_wrapper = function()
    if not fn.mode() == 'n' then
      return 1
    end

    local opts = {}
    local start_line = vim.v.lnum
    local end_line = start_line + vim.v.count - 1
    if start_line >= 0 and end_line >= 0 then
      lsp.buf.range_formatting(opts, {start_line, 0}, {end_line, 0})
    end

    return 0
  end
  if client.resolved_capabilities.document_range_formatting then
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Use a loop to conveniently both setup defined servers
-- and map buffer local keybindings when the language server attaches
local servers = { "rust_analyzer" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end
EOF
