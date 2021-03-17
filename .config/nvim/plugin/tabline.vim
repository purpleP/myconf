if exists('g:loaded_tabline')
    finish
endif
let g:loaded_tabline = 1

fu! s:Hl(group, attrs_dict)
    let command = 'hi! ' . a:group
    let attrs = []
    for [attr, val] in items(a:attrs_dict.gui)
        if val != ''
            call add(attrs, attr)
        endif
    endfor
    let command .= ' gui=' . join(attrs, ',')
    let command .= ' guifg=' . a:attrs_dict.guifg
    let command .= ' guibg=' . a:attrs_dict.guibg
    exe command
endfu

fu! s:AsDict(group) abort
    let hl = {
        \ 'gui': {
            \ 'bold': '',
            \ 'reverse': '',
            \ 'italic': '',
            \ 'standout': '',
            \ 'underline': '',
            \ 'undercurl': '',
        \},
        \ 'guifg': 'NONE',
        \ 'guibg': 'NONE',
    \}
    for attr in keys(hl.gui)
        let hl.gui[attr] = synIDattr(synIDtrans(hlID(a:group)), attr, 'gui')
    endfor
    let hl.guifg = synIDattr(synIDtrans(hlID(a:group)), 'fg', 'gui')
    let hl.guibg = synIDattr(synIDtrans(hlID(a:group)), 'bg', 'gui')
    if hl.guifg == ''
        let hl.guifg = 'NONE'
    endif
    if hl.guibg == ''
        let hl.guibg = 'NONE'
    endif
    return hl
endfu

fu! tabline#ShowTabCwd() abort
    let l:current_tabnr = tabpagenr()
    let s = ''
    for i in range(tabpagenr('$'))
        if i + 1 == l:current_tabnr
            let s .= '%#TabNrSel#%T ' . (i + 1) . '%#TabLineSel#'
        else
            let s .= '%#TabNr#%T ' . (i + 1) . '%#TabLine#'
        endif
        let s .= ' %{fnamemodify(getcwd(-1, ' . (i + 1) . '), '':t'')} %#Tabline#|'
    endfor
    let s .= '%#TabLineFill#%T'
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999Xclose'
    endif
    return s
endfu

fu! tabline#ShortCwd() abort
    return substitute(getcwd(), $HOME, '~', '')
endfu

fu! s:UpdateGroups()
    let s:hl = s:AsDict('StatusLineNC')
    let s:hl['gui']['bold'] = "1"
    call s:Hl('StatusLineNCCwd', s:hl)

    let s:hl = s:AsDict('StatusLine')
    let s:hl['gui']['bold'] = "1"
    call s:Hl('StatusLineCwd', s:hl)

    let s:hl = s:AsDict('TabLineSel')
    let s:hl['gui']['bold'] = "1"
    call s:Hl('TabNrSel', s:hl)

    let s:hl = s:AsDict('TabLine')
    let s:hl['gui']['bold'] = "1"
    call s:Hl('TabNr', s:hl)
endfu

fu! s:SetStatusLine(enter)
    if &buftype =~ '\(quickfix\|preview\|prompt\)'
        return
    endif
    if a:enter
        let base = 'StatusLine'
    else
        let base = 'StatusLineNC'
    endif
    setl stl=
    let &l:stl .= '%#' . base . '#%{tabline#ShortCwd()}%#' . base . '#'
    setl stl+=\ %t
    setl stl+=\ %m
    setl stl+=\ %h
    setl stl+=\ %r
    setl stl+=\ %{winnr()}
    setl stl+=\%=%l:%v/%L\ %p%%
endfu
set tabline=%!tabline#ShowTabCwd()

augroup StatusLine
    au!
    au ColorScheme * call <SID>UpdateGroups() | redrawstatus!
    au WinEnter,WinNew,TermOpen * call <SID>SetStatusLine(1) | redrawstatus!
    au WinLeave * call <SID>SetStatusLine(0) | redrawstatus!
augroup END

call s:UpdateGroups()
call s:SetStatusLine(1)
