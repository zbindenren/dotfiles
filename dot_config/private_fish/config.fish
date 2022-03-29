if status is-interactive
  # Commands to run in interactive sessions can go here
  bind \cF forward-bigword
  bind -k nul accept-autosuggestion
end

set -x PATH $PATH ~/go/bin ~/bin

starship init fish | source
