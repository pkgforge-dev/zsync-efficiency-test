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

# cp -v /usr/lib/libgtk-3.so* ./AppDir/shared/lib

upinfobase="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest"

# squashfs for reference
runtime=$(command -v uruntime-appimage-squashfs-lite-"$ARCH")
appimage=sqfs-zstd22-B1M-$ARCH.AppImage
upinfo="$upinfobase|$appimage.zsync"
mksquashfs ./AppDir ./squashfs -comp zstd -Xcompression-level 22 -b 1M
cp -v "$runtime" "$appimage"
cat ./squashfs >> "$appimage"
chmod +x "$appimage"
./"$appimage" --appimage-addupdinfo "$upinfo"
zsyncmake -u "$appimage" "$appimage"


# now dwarfs
runtime=$(command -v uruntime-appimage-dwarfs-lite-"$ARCH")
set -- \
	--force \
	--order=none \
	--compression=none \
	--set-owner 0 \
	--set-group 0 \
	--no-history \
	--no-create-timestamp \
	--header "$runtime" \
	--input "$PWD"/AppDir

appimage=dwfs-nocomp-$ARCH.AppImage
upinfo="$upinfobase|$appimage.zsync"
mkdwarfs "$@" --output "$appimage"
chmod +x "$appimage"
./"$appimage" --appimage-addupdinfo "$upinfo"
zsyncmake -u "$appimage" "$appimage"

mkdir -p ./dist
echo "X-AppImage-Name=TEST"    >  ./dist/appinfo
echo "X-AppImage-Version=TEST" >> ./dist/appinfo
echo "X-AppImage-Arch=$ARCH"   >> ./dist/appinfo
mv -v ./*.AppImage* ./dist
