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
