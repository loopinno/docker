ARG BASE="arm64v8/ubuntu:18.04"
ARG VERSION="1.18.3"

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
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && set +e

## install Bazel  
COPY --from=loopinno/bazel:4.1.0-ubuntu-18.04-arm64v8 /usr/local/bin/bazel /usr/local/bin

## build Envoy from source code 
# RUN set -e && \
#     cd /opt && \
#     git clone https://github.com/envoyproxy/envoy.git -b v${VERSION} --depth 1 && \
#     cd envoy && \
#     bazel build --jobs=3 -c opt //source/exe:envoy-static && \
#     set +e 

FROM $BASE

## install Envoy  

CMD ["/bin/bash"]
