ARG BASE="loopinno/bazel:4.1.0-ubuntu-18.04"
ARG VERSION="1.18.3"

FROM $BASE AS build
ARG BASE
ARG VERSION

## install build tools and dependencies 
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        build-essential \
        wget \
        git \
        pkg-config \
        gengetopt \
        autogen \
        autoconf \
        automake \
        libtool \
        openjdk-11-jdk \
        zip \
        unzip \
        xz-utils \
        make \
        cmake \
        ninja-build \
        patch \
        python3 \
        python3-pip \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

# build Envoy from source code 
WORKDIR /opt
RUN git clone -b v${VERSION} --depth 1 https://github.com/envoyproxy/envoy.git && \
    cd envoy && \
    bazel build --jobs=3 -c opt //source/exe:envoy-static 

# FROM $BASE

# envoy runtime 
WORKDIR /opt 
RUN rm -rf envoy 

CMD ["/bin/bash"]
