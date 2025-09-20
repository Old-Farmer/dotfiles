# Some usefule aliases defined by Shixin Chai
alias rm="rm -i"
alias tarc="tar -czvf"
alias tarx="tar -xzvf"
alias unzip_cp936="unzip -O cp936"
alias grep="grep --color=auto"
# alias htop="htop --tree"

# tmux aliases defined by Shixin Chai
# alias main="tmux new-session -A -s main"
# alias attach="tmux attach"

# Aliases about apt defined by Shixin Chai
alias apuu="sudo apt update && sudo apt upgrade"
# alias apl="apt list"
# alias aps="apt search"
# alias apin="sudo apt install"
# alias apr="sudo apt remove"
# alias apar="sudo apt autoremove"
# alias app="sudo apt purge"
alias apap="sudo apt autopurge"
# alias apc="sudo apt clean"
# alias apac="sudo apt autoclean"
# alias aplu="apt list --upgradable"

# Aliases about git defined by Shixin Chai

# Interesting aliases defined by Shixin Chai
# alias hi="echo Hello my honored $USER!"
# alias please="sudo"

# alias for neovim
alias vi="nvim"
alias lvi="NVIM_APPNAME=lazyvimdev vi"
alias kickstartvi="NVIM_APPNAME=kickstart_nvim vi"
alias codevi="NVIM_APPNAME=vscode_neovim vi"

# # alias for kitty
# if [ "$TERM" = "xterm-kitty" ]; then
#     alias ssh='kitten ssh'
# fi

# Some workflows

# makefile
# alias make="make -j $(nproc)"
function bear_make() {
    bear_command="bear -- make -j $(nproc) --always-make --dry-run $@"
    echo "Executing: $bear_command"
    eval "$bear_command"
}

# cmake
export CMAKE_EXPORT_COMPILE_COMMANDS=ON # Auto generate complie_commands.json

function cmake_debug() {
    cmake -DCMAMKE_BUILD_TYPE=Debug ..
    make -j $(nproc)
}

function cmake_release() {
    cmake -DCMAMKE_BUILD_TYPE=Release ..
    make -j $(nproc)
}

# git

# add commit
function git_add_commit() {
    if [ -n "$1" ]; then
        git add . && git commit -m "$1"
    else
        git add . && git commit
    fi
}

# add commit push
function git_add_commit_push() {
    if [ -n "$1" ]; then
        git_add_commit "$1" && git push
    else
        git_add_commit && git push
    fi
}

# Some usefule functions defined by Shixin Chai
# Quiet output
function quiet() {
    eval "$@ > /dev/null 2>&1"
}

# # prompt defined by Shixin Chai
# source /etc/bash_completion.d/git-prompt
# export GIT_PS1_DESCRIBE_STYLE='contains'
# export GIT_PS1_SHOWCOLORHINTS='y'
# export GIT_PS1_SHOWDIRTYSTATE='y'
# export GIT_PS1_SHOWSTASHSTATE='y'
# export GIT_PS1_SHOWUNTRACKEDFILES='y'
# export GIT_PS1_SHOWUPSTREAM='auto'

# # father_dir/current_dur
# export PROMPT_DIRTRIM=2

# # 🐅🐅❤️ 🕺  💩👉  💻👉
# export PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[33m\]$(__git_ps1 "(%s)")\[\033[00m\]\$ '

export PATH=$HOME/my_scripts:$PATH

#if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [ ! -n "$vscode" ]; then
#  if [ "$PWD" != "$HOME" ]; then
#    tmux new-session -c "$PWD" && exit;
#  else
#    tmux new-session -A -s main && exit;
#  fi
#fi

# # Use jemalloc for all user apps
# export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so:$LD_PRELOAD

# some apps

# go apps
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:~/go/bin/

# go bash completion
complete -C /home/shixinchai/go/bin/gocomplete go

# cargo
. "$HOME/.cargo/env"

# starship
eval "$(starship init bash)"

# fnm
export PATH="$HOME/.local/share/fnm:$PATH"
eval "$(fnm env --use-on-cd)"
export FNM_NODE_DIST_MIRROR="https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/"
# from an installed version
fnm-reinstall-packages-from() {
    npm install -g $(fnm exec --using=$1 npm list -g | grep "├──\|└──" | awk '{gsub(/@[0-9.]+/, "", $2); print $2}' | tr '\n' ' ' | sed 's/ $//')
}

# fzf
# see apt show fzf
# source /usr/share/doc/fzf/examples/key-bindings.bash
export FZF_DEFAULT_COMMAND='fd --type f --color=always --exclude .git'
# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'
# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
}
# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
}

# java home
export JAVA_HOME="/usr/lib/jvm/default-java/"

# manually setup conda when necessary
conda_setup() {
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/home/shixinchai/miniconda3/bin/conda' 'shell.bash' 'hook' 2>/dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/home/shixinchai/miniconda3/etc/profile.d/conda.sh" ]; then
            . "/home/shixinchai/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="/home/shixinchai/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<

    unset -f conda_setup
}

# # Better man page viewer
# export MANPAGER='nvim +Man!'
ulimit -c unlimited
