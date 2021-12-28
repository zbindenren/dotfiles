if status is-interactive
  # Commands to run in interactive sessions can go here
  #bind \cM forward-bigword
  bind -k nul accept-autosuggestion
end

set -x PATH $PATH ~/golang/bin ~/bin

starship init fish | source
