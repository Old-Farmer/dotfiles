#!/usr/bin/bash

sudo modprobe siw
sudo rdma link add siw0 type siw netdev wlo1

ip addr | grep wlo1 | grep inet