fu! s:SearchFile()
    fu! OpenFile(j, d, e)
        normal gf
        silent bwipeout! #
    endfu
    enew
    call termopen('git ls-files | fzy -l $LINES', {'on_exit': function('OpenFile')})
    tnoremap <buffer> <CR> <CR><C-\><C-n>
    tnoremap <buffer> <Esc> <C-\><C-n>
    startinsert
endfu
nnoremap <Leader>f :call <SID>SearchFile()<CR>
