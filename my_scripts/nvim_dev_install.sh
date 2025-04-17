#!/usr/bin/bash

cd ~/mine/projects/neovim
git pull

read -p "Continue? (y/n): " response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Continue..."
else
    echo "Stop"
    exit 0
fi

make CMAKE_BUILD_TYPE=RelWithDebInfo
cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
