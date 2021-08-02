#!/bin/bash
set -euo pipefail

zip_file="$1"
img_file=cross-compile.img
export MOUNT_POINT=/mnt/root
/mount-and-build-if-necessary.sh "$zip_file" "$img_file"

export RASPBIAN_ROOTFS=$MOUNT_POINT
export COMPILER=aarch64-linux-gnu
export COMPILER_VERSION=8
export COMPILER_PREFIX=/usr
export PATH=$COMPILER_PREFIX/bin:$COMPILER_PREFIX/libexec/gcc/$COMPILER/$COMPILER_VERSION:$PATH
export RASPBERRY_VERSION=1
export CCPREFIX=$COMPILER_PREFIX/bin/$COMPILER-
export PREFIX=/usr/local
export DESTDIR=/src/cross-compile-output
export PKG_CONFIG_LIBDIR="$DESTDIR/$PREFIX/lib:$DESTDIR/opt/vc/lib:$DESTDIR/opt/vc/lib/pkgconfig:${RASPBIAN_ROOTFS}/usr/local/lib" #:${RASPBIAN_ROOTFS}/opt/vc/lib"
export PKG_CONFIG_PATH="$DESTDIR/$PREFIX/lib/pkgconfig:$DESTDIR/opt/vc/lib/pkgconfig:${RASPBIAN_ROOTFS}/usr/local/lib/pkgconfig" #:${RASPBIAN_ROOTFS}/opt/vc/lib/pkgconfig" 
export PKG_CONFIG_SYSROOT_DIR="${DESTDIR}"


cat $COMPILER_PREFIX/lib/gcc-cross/$COMPILER/$COMPILER_VERSION/plugin/include/limitx.h \
    $COMPILER_PREFIX/lib/gcc-cross/$COMPILER/$COMPILER_VERSION/plugin/include/glimits.h \
    $COMPILER_PREFIX/lib/gcc-cross/$COMPILER/$COMPILER_VERSION/plugin/include/limity.h > $(dirname $($COMPILER_PREFIX/bin/$COMPILER-gcc -print-libgcc-file-name))/include-fixed/limits.h

trap 'chown -R 1000:100 $DESTDIR; bash; rm $img_file' EXIT
rm -rf $DESTDIR/*
tmpdir=$(mktemp -d)

cd $tmpdir
git clone https://github.com/raspberrypi/userland
cd userland
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git show f97b1af1b3e653f9da2c1a3643479bfd469e3b74 | git apply -R
git show e31da99739927e87707b2e1bc978e75653706b9c | git apply -R

./buildme --aarch64 $DESTDIR

cd $tmpdir
git clone --depth 1 --branch release/4.4 git://source.ffmpeg.org/ffmpeg.git
#tar xfz /src/ffmpeg.tgz
cd ffmpeg

git clone https://github.com/mirror/x264.git
cd x264

./configure --host=aarch64-linux --cross-prefix=${CCPREFIX} --enable-static --enable-shared --disable-asm
make -j$(nproc)
make install DESTDIR=$DESTDIR




cd $tmpdir/ffmpeg
# ./configure --enable-cross-compile --cross-prefix=${CCPREFIX} --arch=armhf --target-os=linux --enable-gpl --enable-libx264 --extra-cflags="-Ix264/" --extra-ldflags="-Wl,--no-as-needed -ldl -Lx264/"

for patch in /patches-ffmpeg/*; do
    patch -p1 -d . < $patch
done
./configure \
    --enable-cross-compile --target-os=linux --cross-prefix=$CCPREFIX \
    --sysroot="${DESTDIR}" \
    --prefix="$PREFIX" \
    --toolchain=hardened \
    --enable-gpl --enable-nonfree \
    --enable-libx264 \
    --enable-shared \
    --enable-omx --enable-omx-rpi --enable-mmal --enable-neon \
    --extra-cflags="-Ix264/ \
        $(pkg-config --cflags mmal)  \
        -I${DESTDIR}/opt/vc/include/IL" \
    --extra-ldflags="-Wl,--no-as-needed \
        -lpthread -lrt -lm -lc -ldl -Lx264/ \
        $(pkg-config --libs-only-L mmal) \
        -Wl,-rpath-link,${DESTDIR}/opt/vc/lib \
        -Wl,-rpath,/opt/vc/lib" \
    --arch=aarch64


make -j$(nproc)
make install DESTDIR=$DESTDIR

cd $tmpdir

wget http://www.ijg.org/files/jpegsrc.v9.tar.gz
tar xvfz jpegsrc.v9.tar.gz
rm -rf jpegsrc.v9.tar.gz

cd jpeg-9/ 
./configure --host=$COMPILER --prefix=$PREFIX 
make -j$(nproc)
make install DESTDIR=$DESTDIR

cd $tmpdir
wget https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-latest.tar.gz
tar xfz libmicrohttpd-latest.tar.gz
rm -f libmicrohttpd-latest.tar.gz
cd libmicrohttpd-*
./configure --host=$COMPILER --prefix=$PREFIX --disable-examples
make -j$(nproc)
make install DESTDIR=$DESTDIR


cd $tmpdir
git clone --depth 1 --branch release-4.3.2  https://github.com/Motion-Project/motion.git
cd motion
for patch in /patches-motion/*; do
    patch -p1 -d . < $patch
done

autoreconf -fiv

CFLAGS="-O3 $(pkg-config --libs-only-L mmal) -I$DESTDIR$PREFIX/include" \
CPPFLAGS="-I$DESTDIR$PREFIX/include" \
LDFLAGS="-L$DESTDIR$PREFIX/lib $(pkg-config --libs-only-L mmal) -Wl,-rpath-link,${DESTDIR}/opt/vc/lib -Wl,-rpath,/opt/vc/lib -Wl,-rpath,$DESTDIR$PREFIX/lib  -Wl,-rpath-link,$DESTDIR$PREFIX/lib" \
./configure --prefix="$PREFIX" \
    --host=$COMPILER \
    --with-mmal=$DESTDIR/opt/vc \
    --with-ffmpeg=$DESTDIR$PREFIX
    
make -j$(nproc)
make install DESTDIR=$DESTDIR

cd $DESTDIR
find . -name "*.a" -type f -delete
find . -name "*.la" -type f -delete
rm -rf opt/vc/{include,src} usr/local/{include,src}
tar --remove-files -cJf /src/modules/64bit/var/tmp/contents_arm64.tar.xz *
chown 1000:100 /src/modules/64bit/var/tmp/contents_arm64.tar.xz