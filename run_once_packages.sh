#!/bin/sh
sudo pacman -S --noconfirm --needed noto-fonts noto-fonts-emoji fd

sudo pacman -S --noconfirm --needed kitty fish fisher starship

yay -S aur/jumpapp --noconfirm --needed

fish -c 'fisher install jethrokuan/fzf'
fish -c 'fisher install dracula/fish'
