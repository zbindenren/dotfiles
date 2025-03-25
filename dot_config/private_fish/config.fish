set fish_greeting ""

set -gx TERM xterm-256color

if status is-interactive
  # Commands to run in interactive sessions can go here
  bind \cF forward-bigword
  bind -k nul accept-autosuggestion

  atuin init fish | source
end

# ━━ Setup brew ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
set -x PATH $PATH $HOME/homebrew/bin
set -x PATH $PATH /opt/homebrew/bin
set -x PATH $PATH /home/linuxbrew/.linuxbrew/bin
set -x PATH $PATH /usr/local/bin

eval "$(brew shellenv)"

set -x PATH $PATH ~/go/bin ~/bin

starship init fish | source

zoxide init fish | source
