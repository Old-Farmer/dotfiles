#!/usr/bin/bash

wechat_dir="/home/shixinchai/DoChat/WeChat Files/tmpfiles"
if [ "$1" = "update" ]; then
    curl -sL https://raw.githubusercontent.com/huan/docker-wechat/master/dochat.sh | bash
elif [ "$1" = "open" ]; then
    curl -sL https://raw.githubusercontent.com/huan/docker-wechat/master/dochat.sh | DOCHAT_SKIP_PULL=true bash
elif [ "$1" = "upload" ]; then
	cp "$2" "$wechat_dir"
elif [ "$1" = "clear" ]; then
	rm -rf "$wechat_dir"/*
elif [ "$1" = "opdir" ]; then
	xdg-open "/home/shixinchai/DoChat/WeChat Files/tmpfiles"
else
	echo "Usage: $(basename $0) update|open|upload|clear|opdir"
fi
