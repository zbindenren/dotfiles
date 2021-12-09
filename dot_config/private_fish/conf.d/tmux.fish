function tmn
  set name (basename $PWD)
  tmux new-session -s $name -d
  tmux send-keys -t $name 'vi' C-m
  tmux split-window -p 10
  tmux split-window -h
  tmux -2 attach-session -d
end

alias tma="tmux attach -t"
alias tms="tmux switch -t"
alias tml="tmux ls"
alias tmd="tmux detach"
alias tmk="tmux kill-session -t"
