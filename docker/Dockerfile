FROM debian:buster-slim

RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        autoconf \
        automake \
        binfmt-support \
        bison \
        build-essential \
        bzip2 \
        ca-certificates \
        cmake \
        dumb-init \
        fdisk \
        file \
        flex \
        g++ \
        gawk \
        gcc \
        git \
        git-core \
        help2man \
        libass-dev \
        libfreetype6-dev \
        libncurses5-dev \
        libsdl2-dev \
        libtool \
        libtool-bin \
        libva-dev \
        libvdpau-dev \
        libvorbis-dev \
        libx264-dev \
        libxcb1-dev \
        libxcb-shm0-dev \
        libxcb-xfixes0-dev \
        make \
        nasm \ 
        parted \
        patch \
        pkg-config \
        qemu-user-static \
        qemu-utils \
        texinfo \
        unzip \
        wget \
        xz-utils \
        zip \
        zlib1g-dev


# RUN git clone https://github.com/crosstool-ng/crosstool-ng
# RUN cd /crosstool-ng \
#     && ./bootstrap \
#     && ./configure --prefix=/opt/cross \
#     && make -j$(nproc) \
#     && make install \
#     && mkdir ~/ctng /root/src \
#     && cd ~/ctng \
#     && mv /var/tmp/.config . \
#     && /opt/cross/bin/ct-ng build

RUN wget https://github.com/Pro/raspi-toolchain/releases/latest/download/raspi-toolchain.tar.gz \
    && tar xfz raspi-toolchain.tar.gz --strip-components=1 -C /opt
# RUN wget https://github.com/Pro/raspi-toolchain/blob/master/Toolchain-rpi.cmake

# ENV PATH=$PATH:/opt/cross-pi-gcc/bin
COPY docker-image-copy /
WORKDIR "/src"
ENTRYPOINT ["dumb-init", "bash"]