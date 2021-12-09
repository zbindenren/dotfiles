if status is-interactive
  # Commands to run in interactive sessions can go here
end

set -x PATH $PATH ~/golang/bin

starship init fish | source
