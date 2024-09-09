set -x EDITOR nvim

set -gx PATH $PATH $HOME/.krew/bin
set -gx PATH $PATH $HOME/.npm-packages/bin

set -gx LESS -X

# create-go-app
set -gx CREATE_GO_APP_IGNORE Makefile

