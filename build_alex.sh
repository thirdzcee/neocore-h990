export KBUILD_BUILD_USER=Jahlex
export KBUILD_BUILD_HOST=ArchLinux
export ARCH=arm64
export CROSS_COMPILE=/home/alex/matthewdalex-aarch64-linux-android-7.x-7abde5972f4a/bin/aarch64-linux-android-

DIR=$(pwd)
BUILD="$DIR/build"
OUT="$DIR/zip"
ZIPNAME="DirtySanta-h990-1.3-u721-v10g.zip"
NPR=`expr $(nproc) + 1`

echo "cleaning build..."
if [ -d "$BUILD" ]; then
rm -rf "$BUILD"
fi
if [ -d "$OUT" ]; then
rm -rf "$OUT/modules"
rm -rf "$OUT/Image.gz-dtb"
fi

echo "setting up build..."
mkdir "$BUILD"
make O="$BUILD" elsa_global_h990_defconfig

echo "building kernel..."
time make O="$BUILD" -j$NPR 2>&1 |tee ../compile.log

echo "building modules..."
make O="$BUILD" INSTALL_MOD_PATH="." INSTALL_MOD_STRIP=1 modules_install
rm $BUILD/lib/modules/*/build
rm $BUILD/lib/modules/*/source

mkdir -p $OUT/modules
mv "$BUILD/arch/arm64/boot/Image.gz-dtb" "$OUT/Image.gz-dtb"
find "$BUILD/lib/modules/" -name *.ko | xargs -n 1 -I '{}' mv {} "$OUT/modules"
cd zip
mv modules/exfat.ko modules/texfat.ko
zip -q -r "$ZIPNAME" anykernel.sh META-INF tools modules Image.gz-dtb setfiles.conf ramdisk patch

mv "$ZIPNAME" "/media/sf_VirtualBox_Partage/$ZIPNAME"

rm -rf "$OUT/modules"
rm -rf "$OUT/Image.gz-dtb"

echo "Done !"


