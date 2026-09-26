#/usr/bin/bash

ln -sr ./.bash_addition ~/
ln -sr ./.gdbinit ~/
ln -sr ./.inputrc ~/
ln -sr ./.config/git ~/.config/

ln -sr ./.tmux.conf ~/

ln -sr ./.config/starship.toml ~/.config/

ln -sr ./.config/nvim ~/.config/
ln -sr ./.config/vscode_neovim ~/.config/
ln -sr ./.vimrc ~/
ln -sr ./.ideavimrc ~/
ln -sr ./.vim/coc-settings.json ~/.vim/
ln -sr ./.config/charxed ~/.config/
ln -sr ./.config/old_nvim ~/.config/

ln -sr ./.config/fcitx5 ~/.config/

ln -sr ./.config/neovide ~/.config/

ln -sr ./.config/kitty ~/.config/
ln -sr ./.config/alacritty.toml ~/.config/


cat <<'EOF' >> ~/.bashrc
if [ -f ~/.bash_addition ]; then
    . ~/.bash_addition
fi
EOF
