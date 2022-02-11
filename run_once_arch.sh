#!/bin/sh
if ! type pacman > /dev/null; then
  echo "not arch system"
  exit 0
fi

sudo pacman -S --noconfirm --needed noto-fonts noto-fonts-emoji fd bat delve gopls diff-so-fancy

sudo pacman -S --noconfirm --needed kitty fish fisher starship age k9s


if ! type jumpapp > /dev/null; then
  yay -S aur/jumpapp --noconfirm --needed
fi

if ! type puppet-lint > /dev/null; then
  yay -S aur/puppet-lint --noconfirm --needed
fi

if [! -f /usr/share/tmux-plugin-manager/tpm ]; then
  yay -S aur/tmux-plugin-manager --noconfirm --needed
fi

fish -c 'fisher install jethrokuan/fzf'
fish -c 'fisher install dracula/fish'
fish -c 'fisher install 2m/fish-history-merge'
