function task_select
    set line (task -l | grep -v Available| fzf) # Clean up the output
    set task (echo $line |awk  '{print $2}'| sed 's/:$//')
    task $task
end

function task_select_all
    set line (task -a | grep -v Available| fzf) # Clean up the output
    set task (echo $line |awk  '{print $2}'| sed 's/:$//')
    task $task
end

function task_select_global
    set line (task -g -l | grep -v Available| fzf) # Clean up the output
    set task (echo $line |awk  '{print $2}'| sed 's/:$//')
    task -g $task
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

function proxy_user
    set -l default_port 3128
    echo "Proxy host:"
    read proxy
    echo "Port (default $default_port):"
    read port
    if test -z "$port"
        set port $default_port
    end
    echo "Password:"
    read -s password
    echo
    set -gx http_proxy "http://$USER:$password@$proxy:$port"
    set -gx https_proxy "http://$USER:$password@$proxy:$port"
end

# Interactively change the current directory using fd and fzf.
set EXCLUDE_DIRS Library go/pkg qmk_firmware .cache .git/ Pictures/ Music/ Applications/
function c
    set -l fd_exclude_args
    if set -q EXCLUDE_DIRS && test (count $EXCLUDE_DIRS) -gt 0
        for dir in $EXCLUDE_DIRS
            set -a fd_exclude_args -E $dir
        end
    end

    # fd_exclude_args will be empty if TST_EXCLUDE_DIRS was not set or empty
    set selected_dir (fd -t d $fd_exclude_args -H | fzf)

    if test -n "$selected_dir"
        z "$selected_dir"
    end
end
