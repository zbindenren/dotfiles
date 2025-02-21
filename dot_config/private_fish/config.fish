set fish_greeting ""

set -gx TERM xterm-256color

if status is-interactive
  # Commands to run in interactive sessions can go here
  bind \cF forward-bigword
  bind -k nul accept-autosuggestion

  atuin init fish | source
end

set -x PATH $PATH ~/go/bin ~/bin

starship init fish | source

zoxide init fish | source
