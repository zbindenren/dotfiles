#!/bin/sh
if ! type brew > /dev/null; then
  echo "brew not found"
  exit 0
fi

brew install starship fisher tpm


fish -c 'fisher install jethrokuan/fzf'
fish -c 'fisher install dracula/fish'
fish -c 'fisher install 2m/fish-history-merge'
