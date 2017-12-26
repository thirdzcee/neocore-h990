export KBUILD_BUILD_USER=thirdzcee
export ARCH=arm64
export USE_CCACHE=1
export CCACHE_DIR=/home/ironbuang/.ccache
export PATH="/usr/lib/ccache:$PATH"
export CROSS_COMPILE=/home/ironbuang/android/toolchains/gcc-prebuilts/bin/aarch64-linaro-linux-android-

DIR=$(pwd)
BUILD="$DIR/build"
OUT="$DIR/zip"
DATE=`date '+%Y-%m-%d--%H-%M-%S'`;
ZIPNAME="neocore-$DATE.zip"
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
make O="$BUILD" h990_neo_defconfig

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
#mv modules/exfat.ko modules/texfat.ko
zip -q -r "$ZIPNAME" anykernel.sh META-INF tools modules Image.gz-dtb setfiles.conf ramdisk patch

mv "$ZIPNAME" "/home/ironbuang/android/h990/$ZIPNAME"

rm -rf "$OUT/modules"
rm -rf "$OUT/Image.gz-dtb"

echo "Done !"


