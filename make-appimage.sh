#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q filelight | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export ICON=/usr/share/icons/hicolor/128x128/apps/filelight.png
export DESKTOP=/usr/share/applications/org.kde.filelight.desktop
export ALWAYS_SOFTWARE=1

# Deploy dependencies
quick-sharun /usr/bin/filelight

runtime=$(command -v uruntime-appimage-dwarfs-lite-"$ARCH")
upinfobase="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest"

set -- \
	--force \
	--set-owner 0 \
	--set-group 0 \
	--no-history \
	--no-create-timestamp \
	--header "$runtime" \
	--input "$PWD"/AppDir

mkdwarfs "$@" \
	          -C zstd:level=22 -S26 -B6 \	
         --output ./test-zstd22-S26.AppImage
UPINFO="$upinfobase|test-zstd22-S26.AppImage.zsync"
./test-zstd22-S26.AppImage --appimage-addupdinfo "$UPINFO"
zsyncmake -u ./test-zstd22-S26.AppImage.zsync ./test-zstd22-S26.AppImage

mkdwarfs "$@" \
	          -C zstd:level=22 -S20 -B6 \
	     --output ./test-zstd22-S20.AppImage
UPINFO="$upinfobase|test-zstd22-S20.AppImage.zsync"
./test-zstd10-S26.AppImage --appimage-addupdinfo "$UPINFO"
zsyncmake -u ./test-zstd10-S26.AppImage.zsync ./test-zstd10-S26.AppImage

mkdwarfs "$@" \
             -C zstd:level=10 -S26 -B6 \
         --output ./test-zstd10-S26.AppImage
UPINFO="$upinfobase|test-zstd10-S26.AppImage.zsync"
./test-zstd10-S26.AppImage --appimage-addupdinfo "$UPINFO"
zsyncmake -u ./test-zstd10-S26.AppImage.zsync ./test-zstd10-S26.AppImage

mkdwarfs "$@" \
              -C zstd:level=10 -S20 -B6 \
         --output ./test-zstd10-S20.AppImage
UPINFO="$upinfobase|test-zstd10-S20.AppImage.zsync"
./test-zstd10-S20.AppImage --appimage-addupdinfo "$UPINFO"
zsyncmake -u ./test-zstd10-S20.AppImage.zsync ./test-zstd10-S20.AppImage


mkdir -p ./dist
echo "X-AppImage-Name=TEST"    >  ./dist/appinfo
echo "X-AppImage-Version=TEST" >> ./dist/appinfo
echo "X-AppImage-Arch=$ARCH"   >> ./dist/appinfo
mv -v ./*.AppImage* ./dist
