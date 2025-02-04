set -x EDITOR nvim

set -gx PATH $PATH $HOME/.krew/bin
set -gx PATH $PATH $HOME/.npm-packages/bin

set -gx LESS -X

set -gx TASK_X_REMOTE_TASKFILES 1

# create-go-app
set -gx CREATE_GO_APP_IGNORE Makefile

set -gx NODE_EXTRA_CA_CERTS /etc/ssl/certs/ca-certificates.crt
