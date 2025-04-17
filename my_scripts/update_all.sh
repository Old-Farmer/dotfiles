#!/usr/bin/bash

# neovim
./nvim_install.sh
# ./nvim_dev_install.sh

# kitty
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

# rustup
rustup update

# starship
curl -sS https://starship.rs/install.sh | sh -s -- -b ~/.local/bin

# # fzf
# cd ~/.fzf && git pull && ./install

# fnm
curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell

# # zed
# curl https://zed.dev/install.sh | sh
# # zed preview
# curl https://zed.dev/install.sh | ZED_CHANNEL=preview sh
