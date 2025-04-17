#!/bin/bash

function split_version() {
    local version=${1:1}
    IFS='.' read -r major minor patch <<< "$version"
    echo "$major" "$minor" "$patch"
}

function compare_versions() {
    local ver1=($(split_version $1))
    local ver2=($(split_version $2))

    for i in {0..2}; do
        if [[ ${ver1[i]} -lt ${ver2[i]} ]]; then
            echo -1
            return
        elif [[ ${ver1[i]} -gt ${ver2[i]} ]]; then
            echo 1
            return
        fi
    done

    echo 0
}

# old
#wget -nv https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
#rm -rf ${HOME}/nvim-linux64
#tar -zxf nvim-linux64.tar.gz -C ${HOME}
#rm -f nvim-linux64.tar.gz

function install_nvim_by_appimage() {
    mkdir -p "$HOME/.local/bin"
    cd "$HOME/.local/bin" # will not influence outside
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
    chmod u+x nvim-linux-x86_64.appimage
    mv nvim-linux-x86_64.appimage nvim
}

function install_nvim_by_binary() {
    cd "$HOME"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    mv nvim-linux-x86_64 nvim-linux-x86_64-prev
    tar -xzvf nvim-linux-x86_64.tar.gz
    rm nvim-linux-x86_64.tar.gz
    # mkdir -p "$HOME/.local/bin"
    # cd "$HOME/.local/bin"
    # ln -sf "$HOME/nvim-linux-x86_64/bin/nvim" nvim
    cd /usr/local/bin
    sudo ln -sf "$HOME/nvim-linux-x86_64/bin/nvim" nvim
}

latest_version_info_link=https://api.github.com/repos/neovim/neovim/releases/latest

# check link
if [ $(curl -s -I $latest_version_info_link | head -n 1 | cut -d ' ' -f 2) -ne 200 ]; then
    echo "Link error, please check link"
    exit
fi

current_version=$(nvim --version 2>/dev/null | head -n 1 | cut -d ' ' -f 2)
#current_version=v0.9.4
latest_stable_version=$(curl -s $latest_version_info_link | grep "tag_name" | cut -d '"' -f 4)

if [ -z $current_version ]; then
    echo "nvim not installed"
    echo "Installing..."
    install_nvim_by_binary
    current_version=$(nvim --version 2>/dev/null | head -n 1 | cut -d ' ' -f 2)
elif [[ $(compare_versions $current_version $latest_stable_version) -eq -1 ]]; then
    echo "Update needed:" $current_version "->" $latest_stable_version
    echo "Updating..."
    install_nvim_by_binary
    current_version=$(nvim --version 2>/dev/null | head -n 1 | cut -d ' ' -f 2)
else
    echo "Already the newest version"
fi

echo "All is ok!! The current nvim version is" $current_version
