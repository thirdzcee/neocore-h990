export KBUILD_BUILD_USER=Dixon
export KBUILD_BUILD_HOST=ArchLinux
export ARCH=arm64
export CROSS_COMPILE=/home/dixon/toolchains/aarch64-linux-android-7.x/bin/aarch64-linux-android-

DIR=$(pwd)
BUILD="$DIR/build"
OUT="$DIR/out"
NPR=`expr $(nproc) + 1`

echo "cleaning build..."
if [ -d "$BUILD" ]; then
rm -rf "$BUILD"
fi
if [ -d "$OUT" ]; then
rm -rf "$OUT"
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

echo "Image.gz-dtb and modules can be found in $OUT"


