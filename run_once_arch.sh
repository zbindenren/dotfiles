#!/bin/sh
if ! type pacman > /dev/null; then
  echo "not arch system"
  exit 0
fi

PACKAGES="noto-fonts \
  noto-fonts-emoji \
  ttf-fira-code \
  fd \
  bat \
  delve \
  gdu \
  btop \
  kitty \
  fish \
  fisher \
  starship \
  age \
  k9s \
  lazygit \
  prettier \
  onefetch \
  gping \
  dog \
  ripgrep \
  broot \
  git-delta \
  github-cli \
  pcsc-tools \
  ccid \
  libusb-compat \
  fzf \
  sshuttle \
  libfido2 \
  go-task \
  git-cliff \
  kubectl \
  kubectx \
  k9s \
  yubico-piv-tool \
  opensc \
  xclip \
  jq \
  yq \
  kind \
"

AUR_PACKAGES="jumpapp \
  puppet-lint \
  tmux-plugin-manager
  jo \
  git-town \
  logdy-bin \
  nodejs-commitizen \
  choose-rust-git
"


sudo pacman -Sy --noconfirm --needed $PACKAGES

for p in $AUR_PACKAGES
do
  if ! type "$p" > /dev/null; then
    yay -S "aur/$p" --noconfirm --needed
  fi
done

fish -c 'fisher install danhper/fish-ssh-agent'


test -s $(go env GOPATH)/bin/kube-tmux || go install github.com/marcsauter/kube-tmux@latest
