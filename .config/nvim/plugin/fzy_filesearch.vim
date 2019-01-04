if exists('g:loaded_fzy_filesearch')
    finish
endif

let g:loaded_fzy_filesearch = 1

let s:files_cmd = 'find -L -type d -path "*/.*" -prune -o -type f -print -type l -print'

fu! s:TryGitLsFiles()
    call jobstart(
       \ ['git', 'rev-parse', '--is-inside-work-tree'],
       \ {'on_stdout': function('<SID>SetGitFileSearch')}
    \ )
endfu

fu! s:SetGitFileSearch(job, data, error)
    if a:data[0] == 'true'
        let s:files_cmd = 'git ls-files'
    endif
endfu

augroup CheckForGit
    au!
    au DirChanged * call <SID>TryGitLsFiles()
augroup END

call s:TryGitLsFiles()

fu! s:FzyBuffer()
    let l:tmp = tempname()
    call writefile(map(getbufinfo(), 'v:val.name'), l:tmp)
    call s:FzyCommand('cat ' . fnameescape(l:tmp), ':b ')
endfu

fu! s:FzyFiles()
    call s:FzyCommand(s:files_cmd, ':e ')
endfu

fu! s:FzyCommand(choice_command, vim_command) abort
    let l:callback = {
        \ 'window_id': win_getid(),
        \ 'filename': tempname(),
        \ 'vim_command': a:vim_command
    \ }
    fu! l:callback.on_exit(job_id, data, event) abort
        bdelete!
        call win_gotoid(self.window_id)
        if filereadable(self.filename)
            try
                let l:selected_filename = readfile(self.filename)[0]
                exec self.vim_command . l:selected_filename
            catch /E684/
            endtry
        endif
        call delete(self.filename)
    endfu

    botright 10 new
    let l:term_command = a:choice_command . ' | fzy > ' .  fnameescape(l:callback.filename)
    echom l:term_command
    call termopen(l:term_command, l:callback)
    setf fzf
    setlocal nospell bufhidden=wipe nobuflisted nonu nornu
    startinsert
endfu

nnoremap <Leader>f :call <SID>FzyFiles()<CR>
nnoremap <Leader>b :call <SID>FzyBuffer()<CR>
