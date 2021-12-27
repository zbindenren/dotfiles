if status is-interactive
  # Commands to run in interactive sessions can go here
  bind \cg forward-bigword
end

set -x PATH $PATH ~/golang/bin ~/bin

starship init fish | source
