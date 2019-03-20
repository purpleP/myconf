fu! s:SetupMappings()
	augroup ClosePopup
        au!
		au CompleteDone * if pumvisible() == 0 | pclose | endif
        au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	augroup END
    inoremap <buffer> <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
    nmap <buffer> <silent> gd <Plug>(coc-definition)
    nmap <buffer> <silent> gy <Plug>(coc-type-definition)
    nmap <buffer> <silent> gi <Plug>(coc-implementation)
    nmap <buffer> <silent> gr <Plug>(coc-references)
    nmap <buffer> <Leader>a <Plug>(coc-codeaction)
    setlocal formatexpr=CocAction('formatSelected')
    nmap <buffer> <silent> <Leader>r <Plug>(coc-rename)
    nnoremap <buffer> <silent> K :call CocAction('doHover')<CR>
    vmap <buffer> <Leader>a <Plug>(coc-codeaction-selected)
endfu

augroup SetupCocMappings
    au!
    au FileType c call <SID>SetupMappings()
    au FileType cpp call <SID>SetupMappings()
    au FileType haskell call <SID>SetupMappings()
    au FileType java call <SID>SetupMappings()
    au FileType javascript call <SID>SetupMappings()
    au FileType json call <SID>SetupMappings()
    au FileType python call <SID>SetupMappings()
    au FileType typescript call <SID>SetupMappings()
augroup END
