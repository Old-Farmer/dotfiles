# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# cp /etc/skel/.bashrc ~/.bashrc to restore default

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# I delete PS1 settings as using starship

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Custom part, by Shixin Chai

# Some usefule aliases defined by Shixin Chai
alias rm="rm -i"
alias tarc="tar -czvf"
alias tarx="tar -xzvf"
alias unzip_cp936="unzip -O cp936"
alias grep="grep --color=auto"
alias c="clear"
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
alias vic="nvim --clean"
alias vip="NVIM_APPNAME=no_plugin nvim"
alias vin="/usr/bin/nvim" # nightly
alias vi="nvim"
alias lvi="NVIM_APPNAME=lazyvim nvim" # lazyvim
alias ldevvi="NVIM_APPNAME=lazyvimdev vin" # nightly
alias kickstartvi="NVIM_APPNAME=kickstart_nvim nvim"
alias codevi="NVIM_APPNAME=vscode_neovim nvim"

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
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
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
