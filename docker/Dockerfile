FROM debian:bullseye-slim

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
        debootstrap \
        dosfstools \
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
        qemu \
        qemu-user-static \
        qemu-utils \
        sudo \
        pv \
        texinfo \
        udev \
        unzip \
        wget \
        xz-utils \
        zip \
        zlib1g-dev \
        zstd


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

# RUN wget https://github.com/Pro/raspi-toolchain/releases/latest/download/raspi-toolchain.tar.gz \
#     && tar xfz raspi-toolchain.tar.gz --strip-components=1 -C /opt

# RUN apt-get install -yq \
#     sudo gcc make gcc-aarch64-linux-gnu g++-aarch64-linux-gnu binutils-aarch64-linux-gnu gcc-10-plugin-dev-aarch64-linux-gnu


# ENV PATH=$PATH:/opt/cross-pi-gcc/bin
ENV DEBIAN_FRONTEND=noninteractive 
ENV DEBCONF_NONINTERACTIVE_SEEN=true

# Configure apt-cacher-ng to listen on localhost
RUN apt-get install -yq \
        apt-cacher-ng \
    && sed -i 's/^# Port:.*$/Port:3142/' /etc/apt-cacher-ng/acng.conf \
    && sed -i 's/^# BindAddress:.*$/BindAddress:127.0.0.1/' /etc/apt-cacher-ng/acng.conf \
    && sed -i 's|^CacheDir:.*|CacheDir: /cache/apt-cacher-ng|' /etc/apt-cacher-ng/acng.conf

COPY docker-image-copy /
RUN chmod +x /*.sh

WORKDIR "/src"
ENTRYPOINT ["dumb-init", "bash"]