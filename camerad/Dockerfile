ARG BASE="loopinno/l4t-opencv:32.4.4-ridgerun"

FROM $BASE
LABEL maintainer "Reeplayer"

# install dependencies 
RUN set -e && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        sudo \
        iproute2 \
        iputils-ping \
        build-essential \
        pkg-config \
        wget \
        git \
        gengetopt \
        autogen \
        autoconf \
        automake \
        libtool \
        libconfig-dev \
        openssl \
        libssl-dev \
        gtk-doc-tools \
        libglib2.0-dev \
        libyaml-cpp-dev \
        libjsonrpccpp-dev \
        libjsonrpccpp-tools \
        libcpputest-dev \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        python3-dev \
        python3-numpy \
        ninja-build \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && set +e

# upgrade cmake 
RUN set -e && \
    cd /opt && \
    wget --show-progress --progress=bar:force -O cmake-linux.sh https://github.com/Kitware/CMake/releases/download/v3.20.5/cmake-3.20.5-linux-aarch64.sh && \
    sh cmake-linux.sh -- --skip-license --prefix=/usr && \
    rm cmake-linux.sh && \
    set +e 

# grpc 
RUN set -e && \
    cd /opt && \
    git clone --recurse-submodules -b v1.38.1 https://github.com/grpc/grpc && \
    cd grpc/third_party/protobuf && \ 
    ./autogen.sh && ./configure && \
    make && make install && ldconfig && \
    cd /opt/grpc && \
    mkdir -p cmake/build && \
    cd cmake/build && \
    cmake -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF ../.. && \
    make -j8 && make install && \
    cd /opt/grpc/third_party/abseil-cpp && \
    mkdir -p cmake/build && \
    cd cmake/build && \
    cmake -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE ../.. && \
    make -j8 && make install && \
    set +e 

# meson used to build gst-stitcher 
RUN set -e && \
    pip3 install git+https://github.com/mesonbuild/meson.git && \
    set +e 

RUN useradd --user-group --system camerad

EXPOSE 9090

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]
