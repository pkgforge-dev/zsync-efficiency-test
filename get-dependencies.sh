#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm filelight kvantum qt6ct

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano kiconthemes-mini

wget https://github.com/mhx/dwarfs/releases/download/v0.15.3/dwarfs-universal-0.15.3-Linux-"$ARCH" -O /usr/bin/mkdwarfs
chmod +x /usr/bin/mkdwarfs

wget https://github.com/VHSgunzo/squashfs-tools-static/releases/download/v4.7.5/mksquashfs-"$ARCH" -O /usr/bin/mksquashfs
chmod +x /usr/bin/mksquashfs

wget https://github.com/VHSgunzo/uruntime/releases/download/v0.5.7/uruntime-appimage-dwarfs-lite-"$ARCH" -O /usr/bin/uruntime-appimage-dwarfs-lite-"$ARCH"
wget https://github.com/VHSgunzo/uruntime/releases/download/v0.5.7/uruntime-appimage-squashfs-lite-"$ARCH" -O /usr/bin/uruntime-appimage-squashfs-lite-"$ARCH"
chmod +x /usr/bin/uruntime*
