#!/usr/bin/bash

vncviewer &

echo "Please make vncviewer connect to 127.0.0.1:5901"

echo ""

echo "socks5 proxy = socks://127.0.0.1:1080"

echo ""

echo "use:"
echo "export all_proxy=socks://127.0.0.1:1080"
echo "export ALL_PROXY=socks://127.0.0.1:1080"
echo ""

echo "http proxy = http://127.0.0.1:8888"

echo ""

echo "use:"
echo "export http_proxy=http://127.0.0.1:8888"
echo "export HTTP_PROXY=http://127.0.0.1:8888"
echo "export https_proxy=http://127.0.0.1:8888"
echo "export HTTPS_PROXY=http://127.0.0.1:8888"

echo ""

echo "run docker run --rm \
    --device /dev/net/tun \
    --cap-add NET_ADMIN \
    -ti \
    -e PASSWORD=xxxx \
    -e URLWIN=1 \
    -v $HOME/.ecdata:/root \
    -p 127.0.0.1:5901:5901 \
    -p 127.0.0.1:1080:1080 \
    -p 127.0.0.1:8888:8888 \
    hagb/docker-easyconnect:7.6.7 "

docker run --rm \
    --device /dev/net/tun \
    --cap-add NET_ADMIN \
    -ti \
    -e PASSWORD=xxxx \
    -e URLWIN=1 \
    -v $HOME/.ecdata:/root \
    -p 127.0.0.1:5901:5901 \
    -p 127.0.0.1:1080:1080 \
    -p 127.0.0.1:8888:8888 \
    hagb/docker-easyconnect:7.6.7
