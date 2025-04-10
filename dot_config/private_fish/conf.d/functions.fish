function task_select
    set line (task -l | grep -v Available| fzf) # Clean up the output
    set task (echo $line |awk  '{print $2}'| sed 's/:$//')
    go-task $task
end

function task_select_all
    set line (task -a | grep -v Available| fzf) # Clean up the output
    set task (echo $line |awk  '{print $2}'| sed 's/:$//')
    go-task $task
end

function task_select_global
    set line (task -g -l | grep -v Available| fzf) # Clean up the output
    set task (echo $line |awk  '{print $2}'| sed 's/:$//')
    go-task -g $task
end

# kill tmux sessions
function tmk
    set sessions (tmux list-sessions -F '#S' | fzf --multi)
    if test -n "$sessions"
        for session in $sessions
            tmux kill-session -t $session
        end
    end
end

# attach tmux session
function tma
    if test -n "$TMUX"
        echo "cannot attach form within tmux session"
        return
    end
    set session (tmux list-sessions -F '#S' | fzf --no-multi)
    if test -n "$session"
        tmux attach -t $session
    end
end

# yazi integration
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
