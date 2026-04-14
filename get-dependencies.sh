#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm filelight kvantum qt6ct

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano kiconthemes-mini

wget https://github.com/mhx/dwarfs/releases/download/v0.15.3/dwarfs-universal-0.15.3-Linux-"$ARCH" -O /usr/bin/dwarfs
chmod +x /usr/bin/dwarfs

