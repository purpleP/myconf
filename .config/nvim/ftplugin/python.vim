nnoremap gb :call AddBreakPoint()<cr>

setlocal includeexpr=substitute(v:fname,'\\.','/','g')

setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab

augroup ClosePreview
    au!
    au CompleteDone * pclose
augroup END

function! AddBreakPoint()
    let l:line = line('.')
    let l:indentChar = ' '
    call append(l:line - 1, repeat(l:indentChar, indent(l:line)) . "import pdb;pdb.set_trace()")
endfunction
