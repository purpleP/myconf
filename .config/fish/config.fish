abbr --add 'v' 'nvim'
abbr --add 'g' 'git'
fish_vi_key_bindings

function reverse_history_search
    history | fzy | read -l command
    if test "$command"
        commandline --replace -- $command
    end
    commandline --function repaint
end

function fish_user_key_bindings
    bind -M insert \cr reverse_history_search
end
