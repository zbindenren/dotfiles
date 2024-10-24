function tmn
  set name (basename $PWD)
  tmux new-session -s $name -d
  tmux send-keys -t $name 'vi' C-m
  tmux -2 attach-session -d
end

function tmK
  set name k9s
  tmux new-session -s $name -d
  tmux send-keys -t $name 'k9s --as=zbindenren --as-group=system:masters' C-m
  tmux -2 attach-session -d
end

alias tma="tmux attach -t"
alias tms="tmux switch -t"
alias tml="tmux ls"
alias tmd="tmux detach"
alias tmp="tmux new-session -s paam"
