let s:files_prg = 'find -L -type d -path */.* -prune -o -type f -print type l -print'

fu! s:TryGitLsFiles()
    call jobstart(
       \ ['git', 'rev-parse', '--is-inside-work-tree'],
       \ {'on_stdout': function('s:SetDeniteGitFileSearch')}
    \ )
endfu

fu! s:SetDeniteGitFileSearch(job, data, error)
    if a:data[0] == 'true'
        let s:files_prg = 'git ls-files'
    endif
endfu

augroup CheckForGit
    au!
    au DirChanged * call s:TryGitLsFiles()
augroup END

call s:TryGitLsFiles()

fu! s:SearchFile()
    fu! OpenFile(j, d, e)
        normal gf
        silent bwipeout! #
    endfu
    enew
    call termopen(s:files_prg . ' | fzy -l $LINES', {'on_exit': function('OpenFile')})
    tnoremap <buffer> <CR> <CR><C-\><C-n>
    tnoremap <buffer> <Esc> <C-\><C-n>
    startinsert
endfu
nnoremap <Leader>f :call <SID>SearchFile()<CR>
