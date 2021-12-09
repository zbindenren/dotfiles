#!/bin/sh
sudo pacman -S --noconfirm --needed noto-fonts noto-fonts-emoji

sudo pacman -S --noconfirm --needed fish fisher

fish -c 'fisher install jethrokuan/fzf'
fish -c 'fisher install dracula/fish'
