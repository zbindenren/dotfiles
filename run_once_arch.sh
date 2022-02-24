#!/bin/sh
if ! type pacman > /dev/null; then
  echo "not arch system"
  exit 0
fi

PACKAGES="noto-fonts \
  noto-fonts-emoji \
  fd \
  bat \
  delve \
  gopls \
  gdu \
  btop \
  diff-so-fancy \
  kitty \
  fish \
  fisher \
  starship \
  age \
  k9s \
  lazygit \
  pettier \
"

AUR_PACKAGES="jumpapp \
  puppet-lint \
  tmux-plugin-manager
  jo
"


sudo pacman -S --noconfirm --needed $PACKAGES

for p in $AUR_PACKAGES
do
  if ! type "$p" > /dev/null; then
    yay -S "aur/$p" --noconfirm --needed
  fi
done

fish -c 'fisher install jethrokuan/fzf'
fish -c 'fisher install dracula/fish'
fish -c 'fisher install 2m/fish-history-merge'
