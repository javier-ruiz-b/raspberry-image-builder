#!/bin/bash
set -euxo pipefail

bash /decompress-image.sh
bash /mount.sh

export COMPILER=arm-linux-gnueabihf
export COMPILER_PATH=/opt/cross-pi-gcc
export PATH=$COMPILER_PATH/bin:$COMPILER_PATH/libexec/gcc/arm-linux-gnueabihf/8.3.0:$PATH
export RASPBIAN_ROOTFS=/mnt/root
export RASPBERRY_VERSION=1
export CCPREFIX=$COMPILER_PATH/bin/$COMPILER-
export PREFIX=/usr/local
export DESTDIR=/src/cross-compile-output
export PKG_CONFIG_LIBDIR="$DESTDIR/$PREFIX/lib:${RASPBIAN_ROOTFS}/usr/local/lib:${RASPBIAN_ROOTFS}/opt/vc/lib"
export PKG_CONFIG_PATH="$DESTDIR/$PREFIX/lib/pkgconfig:${RASPBIAN_ROOTFS}/usr/local/lib/pkgconfig:${RASPBIAN_ROOTFS}/opt/vc/lib/pkgconfig" 
export PKG_CONFIG_SYSROOT_DIR="${RASPBIAN_ROOTFS}"

cat $COMPILER_PATH/lib/gcc/arm-linux-gnueabihf/8.3.0/plugin/include/limitx.h \
    $COMPILER_PATH/lib/gcc/arm-linux-gnueabihf/8.3.0/plugin/include/glimits.h \
    $COMPILER_PATH/lib/gcc/arm-linux-gnueabihf/8.3.0/plugin/include/limity.h > $(dirname $($COMPILER_PATH/bin/arm-linux-gnueabihf-gcc -print-libgcc-file-name))/include-fixed/limits.h

trap 'chown -R 1000:100 $DESTDIR; bash' EXIT
rm -rf $DESTDIR/*
tmpdir=$(mktemp -d)

cd $tmpdir
# git clone --depth 1 --branch release/4.4 git://source.ffmpeg.org/ffmpeg.git
tar xfz /src/ffmpeg.tgz
cd ffmpeg

git clone https://github.com/mirror/x264.git
cd x264

./configure --host=arm-linux --cross-prefix=${CCPREFIX} --enable-static --enable-shared --disable-asm
make -j$(nproc)
make install DESTDIR=$DESTDIR



cd $tmpdir/ffmpeg
# ./configure --enable-cross-compile --cross-prefix=${CCPREFIX} --arch=armhf --target-os=linux --enable-gpl --enable-libx264 --extra-cflags="-Ix264/" --extra-ldflags="-Wl,--no-as-needed -ldl -Lx264/"

for patch in /patches-ffmpeg/*; do
    patch -p1 -d . < $patch
done
./configure \
    --enable-cross-compile --target-os=linux --cross-prefix=$CCPREFIX \
    --sysroot="${RASPBIAN_ROOTFS}" \
    --prefix="$PREFIX" \
    --toolchain=hardened \
    --enable-gpl --enable-nonfree \
    --enable-libx264 \
    --enable-shared \
    --enable-omx --enable-omx-rpi --enable-mmal --enable-neon \
    --extra-cflags="-Ix264/ \
        $(pkg-config --cflags mmal)  \
        -I${RASPBIAN_ROOTFS}/opt/vc/include/IL" \
    --extra-ldflags="-Wl,--no-as-needed \
        -lpthread -lrt -lm -lc -ldl -Lx264/ \
        $(pkg-config --libs-only-L mmal) \
        -Wl,-rpath-link,${RASPBIAN_ROOTFS}/opt/vc/lib \
        -Wl,-rpath,/opt/vc/lib" \
    --arch=arm --cpu=arm1176jzf-s 

    # 	"/opt/cross-pi-gcc/arm-linux-gnueabihf/lib"
	# "/opt/cross-pi-gcc/lib"
	# "${SYSROOT_PATH}/opt/vc/lib"
	# "${SYSROOT_PATH}/lib/${TOOLCHAIN_HOST}"
	# "${SYSROOT_PATH}/usr/local/lib"
	# "${SYSROOT_PATH}/usr/lib/${TOOLCHAIN_HOST}"
	# "${SYSROOT_PATH}/usr/lib"
	# "${SYSROOT_PATH}/usr/lib/${TOOLCHAIN_HOST}/blas"
	# "${SYSROOT_PATH}/usr/lib/${TOOLCHAIN_HOST}/lapack"

    # --target-os=linux \

# patch -p1 -d . < 2000-disable-zerocopy-via-avoptions.patch
# wget https://raw.githubusercontent.com/jasaw/motioneyeos/motion-disable-omx-zerocopy/package/motion/enable-h264-omx-codec.patch
# patch -p1 -d . < enable-h264-omx-codec.patch

# --prefix=/usr --extra-version='1~deb10u1+rpt1'
#  --toolchain=hardened --incdir=/usr/include/arm-linux-gnueabihf --enable-gpl \
#  --disable-stripping --enable-avresample --disable-filter=resample --enable-avisynth --enable-gnutls --enable-ladspa \
#  --enable-libaom --enable-libass --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libcodec2 \
#  --enable-libflite --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libgme --enable-libgsm \
#  --enable-libjack --enable-libmp3lame --enable-libmysofa --enable-libopenjpeg --enable-libopenmpt --enable-libopus \
#  --enable-libpulse --enable-librsvg --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr \
#  --enable-libspeex --enable-libssh --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvorbis \
#  --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid \
#  --enable-libzmq --enable-libzvbi --enable-lv2 --enable-omx --enable-openal --enable-opengl --enable-sdl2 \
#  --enable-omx-rpi --enable-mmal --enable-neon --enable-rpi --enable-libdc1394 --enable-libdrm --enable-libiec61883 \
#  --enable-chromaprint --enable-frei0r --enable-libx264 --enable-shared --libdir=/usr/lib/arm-linux-gnueabihf --cpu=arm1176jzf-s --arch=arm


#rpi
#configuration: --prefix=/usr --extra-version='1~deb10u1+rpt1' --toolchain=hardened --incdir=/usr/include/arm-linux-gnueabihf --enable-gpl --disable-stripping --enable-avresample --disable-filter=resample --enable-avisynth --enable-gnutls --enable-ladspa --enable-libaom --enable-libass --enable-libbluray --enable-libbs2b --enable-libcaca --enable-libcdio --enable-libcodec2 --enable-libflite --enable-libfontconfig --enable-libfreetype --enable-libfribidi --enable-libgme --enable-libgsm --enable-libjack --enable-libmp3lame --enable-libmysofa --enable-libopenjpeg --enable-libopenmpt --enable-libopus --enable-libpulse --enable-librsvg --enable-librubberband --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libssh --enable-libtheora --enable-libtwolame --enable-libvidstab --enable-libvorbis --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx265 --enable-libxml2 --enable-libxvid --enable-libzmq --enable-libzvbi --enable-lv2 --enable-omx --enable-openal --enable-opengl --enable-sdl2 --enable-omx-rpi --enable-mmal --enable-neon --enable-rpi --enable-libdc1394 --enable-libdrm --enable-libiec61883 --enable-chromaprint --enable-frei0r --enable-libx264 --enable-shared --libdir=/usr/lib/arm-linux-gnueabihf --cpu=arm1176jzf-s --arch=arm

make -j$(nproc)
make install DESTDIR=$DESTDIR

# apt-get install -y autoconf automake pkgconf libtool libjpeg-dev build-essential libzip-dev gettext libmicrohttpd-dev
cd $tmpdir

bash

# chroot $RASPBIAN_ROOTFS apt-get install -y  libjpeg-dev libzip-dev

wget http://www.ijg.org/files/jpegsrc.v9.tar.gz
tar xvfz jpegsrc.v9.tar.gz
rm -rf jpegsrc.v9.tar.gz

cd jpeg-9/ 
./configure --host=$COMPILER --prefix=$PREFIX 
make -j$(nproc)
make install DESTDIR=$DESTDIR



wget https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-latest.tar.gz
tar xfz libmicrohttpd-latest.tar.gz
rm -f libmicrohttpd-latest.tar.gz
cd libmicrohttpd-*
./configure --host=$COMPILER --prefix=$PREFIX 
make -j$(nproc)
make install DESTDIR=$DESTDIR
# git clone -depth 1 --branch master https://github.com/raspberrypi/userland.git




git clone --depth 1 --branch release-4.3.2  https://github.com/Motion-Project/motion.git
cd motion
for patch in /patches-motion/*; do
    patch -p1 -d . < $patch
done



autoreconf -fiv


CFLAGS="-O3 -march=armv6zk -mcpu=arm1176jzf-s -mtune=arm1176jzf-s -mfpu=vfp -mfloat-abi=hard $(pkg-config --libs-only-L mmal) -I$DESTDIR$PREFIX/include" \
CPPFLAGS="-I$DESTDIR$PREFIX/include" \
LDFLAGS="-L$DESTDIR$PREFIX/lib $(pkg-config --libs-only-L mmal) -Wl,-rpath-link,${RASPBIAN_ROOTFS}/opt/vc/lib -Wl,-rpath,/opt/vc/lib -Wl,-rpath,$DESTDIR$PREFIX/lib  -Wl,-rpath-link,$DESTDIR$PREFIX/lib" \
./configure --prefix="$PREFIX" \
    --host=$COMPILER \
    --with-mmal=$RASPBIAN_ROOTFS/opt/vc \
    --with-ffmpeg=$DESTDIR$PREFIX
    
# CC=${CCPREFIX}gcc \
# CPP=${CCPREFIX}cpp \

#  \
# -Wl,-rpath-link,${RASPBIAN_ROOTFS}/opt/vc/lib \
# -Wl,-rpath,/opt/vc/lib
# -I $RASPBIAN_ROOTFS/usr/include \
# -I $RASPBIAN_ROOTFS/usr/include/arm-linux-gnueabihf \

make -j$(nproc)
make install DESTDIR=$DESTDIR

# ENV CMAKE_C_COMPILER "/opt/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc"
# ENV CMAKE_CXX_COMPILER "/opt/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin/arm-linux-gnueabihf-g++"
# ENV MMAL_CFLAGS="-I/opt/vc/include"
# ENV MMAL_LIBS="-L/opt/vc/lib"
# RUN cd /sandbox/motion && \
# 	autoreconf -fiv && \
# 	./configure --with-ffmpeg=/opt/arm/  --host=arm-unknown-linux-gnueabi --prefix=/opt/arm  --without-sqlite3 && \
# 	make && \
# 	make install


cd $DESTDIR
rm usr/local/lib/*.a
tar --remove-files -czf contents.tgz *