ARG BASE="arm64v8/ubuntu:18.04"
ARG VERSION="1.38.1"

FROM $BASE AS dev
ARG BASE
ARG VERSION

## install dependencies 
RUN set -e && \
    apt-get update && \
    apt-get install -y \
        build-essential \
        wget \
        git \
        pkg-config \
        gengetopt \
        autogen \
        autoconf \
        automake \
        libtool \
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

# grpc from source code  
RUN set -e && \
    cd /opt && \
    git clone --recurse-submodules -b v${VERSION} --depth 1 https://github.com/grpc/grpc && \
    cd grpc/third_party/protobuf && \ 
    ./autogen.sh && ./configure && \
    make && make install && ldconfig && \
    cd /opt/grpc && \
    mkdir -p cmake/build && \
    cd cmake/build && \
    cmake -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF ../.. && \
    make -j"$(nproc)" && make install && \
    cd /opt/grpc/third_party/abseil-cpp && \
    mkdir -p cmake/build && \
    cd cmake/build && \
    cmake -DCMAKE_POSITION_INDEPENDENT_CODE=TRUE ../.. && \
    make -j"$(nproc)" && make install && \
    set +e 

FROM dev

# runtime only 
RUN set -e && \
    cd /opt && \
    rm -rf grpc && \
    set +e 

CMD ["/bin/bash"]
