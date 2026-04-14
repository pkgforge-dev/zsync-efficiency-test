#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q filelight | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ICON=/usr/share/icons/hicolor/128x128/apps/filelight.png
export DESKTOP=/usr/share/applications/org.kde.filelight.desktop
export ALWAYS_SOFTWARE=1

# Deploy dependencies
quick-sharun /usr/bin/filelight

#cp -v /usr/lib/libgtk-3.so* ./AppDir/shared/lib

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


# high comp and block
appimage=test-zstd22-S26-$ARCH.AppImage
upinfo="$upinfobase|$appimage.zsync"
mkdwarfs "$@" -C zstd:level=22 -S26 -B6 --output "$appimage"
chmod +x "$appimage"
./"$appimage" --appimage-addupdinfo "$upinfo"
zsyncmake -u "$appimage" "$appimage"

# high comp and low block
appimage=test-zstd22-S20-$ARCH.AppImage
upinfo="$upinfobase|$appimage.zsync"
mkdwarfs "$@"  -C zstd:level=22 -S20 -B6 --output "$appimage"
chmod +x "$appimage"
./"$appimage" --appimage-addupdinfo "$upinfo"
zsyncmake -u "$appimage" "$appimage"

# low comp and high block
appimage=test-zstd10-S26-$ARCH.AppImage
upinfo="$upinfobase|$appimage.zsync"
mkdwarfs "$@" -C zstd:level=10 -S26 -B6 --output "$appimage"
chmod +x "$appimage"
./"$appimage" --appimage-addupdinfo "$upinfo"
zsyncmake -u "$appimage" "$appimage"

# low comp and low block
appimage=test-zstd10-S20-$ARCH.AppImage
upinfo="$upinfobase|$appimage.zsync"
mkdwarfs "$@" -C zstd:level=10 -S20 -B6 --output "$appimage"
chmod +x "$appimage"
./"$appimage" --appimage-addupdinfo "$upinfo"
zsyncmake -u "$appimage" "$appimage"


mkdir -p ./dist
echo "X-AppImage-Name=TEST"    >  ./dist/appinfo
echo "X-AppImage-Version=TEST" >> ./dist/appinfo
echo "X-AppImage-Arch=$ARCH"   >> ./dist/appinfo
mv -v ./*.AppImage* ./dist
