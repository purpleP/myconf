function! s:UltiSnips_Complete()
    call UltiSnips#ExpandSnippet()
    if g:ulti_expand_res == 0
        if pumvisible()
            return "\<C-n>"
        else
            call UltiSnips#JumpForwards()
            if g:ulti_jump_forwards_res == 0
                return "\<TAB>"
            endif
        endif
    endif
    return ''
endfunction

function! s:UltiSnips_Reverse()
    call UltiSnips#JumpBackwards()
    if g:ulti_jump_backwards_res == 0
        return "\<C-P>"
    endif
    return ''
endfunction


let g:UltiSnipsJumpForwardTrigger = "<TAB>"
let g:UltiSnipsJumpBackwardTrigger = "<S-TAB>"

augroup UltisnipsMappings
    au!
    au InsertEnter * inoremap <silent> <TAB> <C-R>=<SID>UltiSnips_Complete()<CR>
    au InsertEnter * inoremap <silent> <S-TAB> <C-R>=<SID>UltiSnips_Reverse()<CR>
augroup END
