#!/bin/sh
sudo pacman -S --noconfirm --needed noto-fonts noto-fonts-emoji fd

sudo pacman -S --noconfirm --needed kitty fish fisher starship


if ! type jumpapp > /dev/null; then
  yay -S aur/jumpapp --noconfirm --needed
fi

if [! -f /usr/share/tmux-plugin-manager/tpm ]; then
  yay -S aur/tmux-plugin-manager --noconfirm --needed
fi

fish -c 'fisher install jethrokuan/fzf'
fish -c 'fisher install dracula/fish'
