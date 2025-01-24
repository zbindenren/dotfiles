function tmn
  set name (basename $PWD)
  tmux new-session -s $name -d -n neovim
  tmux send-keys -t $name:neovim 'vi' C-m
  tmux new-window -t $name -n term01
  tmux new-window -t $name -n term02
  tmux new-window -t $name -n term03
  tmux new-window -t $name -n term04
  tmux -2 attach-session -t $name:neovim
end

function tmK
  set name k9s
  tmux new-session -s $name -d
  tmux send-keys -t $name 'k9s --as=zbindenren --as-group=system:masters' C-m
  tmux -2 attach-session -d
end

alias tms="tmux switch -t"
alias tml="tmux ls"
alias tmd="tmux detach"
alias tmp="tmux new-session -s paam"
