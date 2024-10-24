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

function tmkk
    # Capture the output of tmux ls command and pipe it to fzf for selection
    set sessions (tmux list-sessions -F '#S' | fzf --multi)

    # Check if any sessions were selected
    if test -n "$sessions"
        # Iterate over each selected session and kill it
        for session in $sessions
            tmux kill-session -t $session
        end
    end
end
