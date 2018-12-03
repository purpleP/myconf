if exists('g:loaded_fzy_filesearch')
    finish
endif
let g:loaded_fzy_filesearch = 1


let s:files_prg = 'find -L -type d -path "*/.*" -prune -o -type f -print -type l -print'

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
    enew
    call termopen('nvr -s "$(' . s:files_prg . ' | fzy -l 100)"')
    startinsert
endfu
nnoremap <Leader>f :call <SID>SearchFile()<CR>
