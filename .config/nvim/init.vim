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
set bg=light
set list!
set listchars=tab:░░,trail:·

if !has('nvim')
    set backspace=indent,eol,start
    set encoding=utf-8
    set hlsearch
    set incsearch
    set wildmenu
    set inccommand=nosplit
    set wildoptions=pum
    augroup terminal
        au!
        au TermOpen * setlocal nonu nornu
    augroup END
endif

set grepformat=%f:%l:%c:%m
set grepprg=rg\ --vimgrep

if has('persistent_undo')
    set undodir=~/.undodir/
    set undofile
endif

silent! colorscheme solarized

let mapleader = "\<Space>"
nnoremap <C-L> 20zl
nnoremap <C-H> 20zh

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


let g:netrw_list_hide = '^\.\.\?/$'
let g:netrw_hide = 1

nnoremap <silent> <CR> :Tele find_files<CR>
nnoremap <silent> <C-I> <C-I>
nnoremap <silent> <C-H> <C-H>
nnoremap <silent> <TAB> :Tele lsp_document_symbols<CR>
nnoremap <silent> <DEL> :Tele live_grep<CR>

nnoremap <silent> <BS> :Ex<CR>
augroup Quickfix
    au!
    au BufReadPost quickfix nnoremap <buffer> <CR> <CR>
    au CmdwinEnter * nnoremap <buffer> <CR> <CR>
    au QuickFixCmdPost [^l]* nested cwindow
    au QuickFixCmdPost *l nested lwindow
augroup END

augroup HighlightYank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup END

augroup Clean
    au!
    au InsertLeave * keepp s/\s\+$//e
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
  buf_set_keymap('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

require'lspconfig'.rust_analyzer.setup {
  capabilities = capabilities,
  on_attach = on_attach,
}

require('snippy').setup({
    mappings = {
        is = {
            ['<Tab>'] = 'expand_or_advance',
            ['<S-Tab>'] = 'previous',
        },
        nx = {
            ['<leader>x'] = 'cut_text',
        },
    },
})
require("nvim-autopairs").setup({
    check_ts = true,
    ts_config = {
        lua = {'string'},-- it will not add a pair on that treesitter node
        javascript = {'template_string'},
        python = {'string'},
        rust = {'string_literal'},
        java = {'string'},
    }
})
-- Set up nvim-cmp.
local cmp = require'cmp'

  local has_words_before = function()
    junpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end
  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require('snippy').can_expand_or_advance() then
              require('snippy').expand_or_advance()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require('snippy').can_jump(-1) then
              require('snippy').previous()
            else
              fallback()
            end
          end, { "i", "s" }),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

EOF
let g:rustfmt_fail_silently = 1
