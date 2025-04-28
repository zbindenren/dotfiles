# XDG base directories.
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"

set -gx EDITOR nvim

set -gx LESS -X

set -gx TASK_X_REMOTE_TASKFILES 1

# create-go-app
set -gx CREATE_GO_APP_IGNORE Makefile
