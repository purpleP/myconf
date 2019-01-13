fu! s:SetupMappings()
	augroup ClosePopup
		au! CompleteDone * if pumvisible() == 0 | pclose | endif
	augroup END
    inoremap <buffer> <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
    nmap <buffer> <silent> gd <Plug>(coc-definition)
    nmap <buffer> <silent> gy <Plug>(coc-type-definition)
    nmap <buffer> <silent> gi <Plug>(coc-implementation)
    nmap <buffer> <silent> gr <Plug>(coc-references)
    nmap <buffer> <leader>a <Plug>(coc-codeaction)
    setlocal formatexpr=CocAction('formatSelected')
    nnoremap <buffer> <silent> K :call <SID>show_documentation()<CR>
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
    au User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END
