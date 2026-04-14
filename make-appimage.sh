#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q filelight | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/128x128/apps/filelight.png
export DESKTOP=/usr/share/applications/org.kde.filelight.desktop
export ALWAYS_SOFTWARE=1

# Deploy dependencies
quick-sharun /usr/bin/filelight

dwarfs \
	--force \
	--set-owner 0 \
	--set-group 0 \
	--no-history \
	--no-create-timestamp \
	--header "$(command -v uruntime-appimage-dwarfs-lite-"$ARCH")" \
	--input ./AppDir
	--output ./test.AppImage

zsyncmake -u
mkdir -p ./dist
mv -v ./*.AppImage* ./dist
