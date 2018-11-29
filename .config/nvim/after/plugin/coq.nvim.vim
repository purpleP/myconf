fu! s:SetupMappings()
    nnoremap <buffer> <silent> [c <Plug>(coc-diagnostic-prev)
    nnoremap <buffer> <silent> ]c <Plug>(coc-diagnostic-next)

    nnoremap <buffer> <silent> gd <Plug>(coc-definition)
    nnoremap <buffer> <silent> gy <Plug>(coc-type-definition)
    nnoremap <buffer> <silent> gi <Plug>(coc-implementation)
    nnoremap <buffer> <silent> gr <Plug>(coc-references)

    nnoremap <buffer> <silent> K :call <SID>show_documentation()<CR>
endfu

augroup SetupCocMappings
    au!
    au FileType java call <SID>SetupMappings()
    au FileType json call <SID>SetupMappings()
    au FileType javascript call <SID>SetupMappings()
    au FileType typescript call <SID>SetupMappings()
augroup END
