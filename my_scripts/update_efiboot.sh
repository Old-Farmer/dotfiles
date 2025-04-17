#!/usr/bin/bash

efibootmgr

echo "To execute sudo efibootmgr -o 0001,0002,2001,3002"

read -p "Continue? (y/n): " response

if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Continue..."
else
    echo "Stop"
    exit 0
fi

sudo efibootmgr -o 0001,0002,2001,3002
