ARG BASE=docker.io/arm64v8/ubuntu:18.04

FROM $BASE
LABEL maintainer "Loopinno"

# install build tools and dependencies
RUN set -e && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        build-essential \
        pkg-config \
        libglib2.0-dev \
        libssl-dev \
        openssl \
        wget \
        git \
        gengetopt \
        autogen \
        autoconf \
        automake \
        libtool \
        libconfig-dev \
        libjansson-dev \
        libmicrohttpd-dev \
        libcurl4-openssl-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && set +e

## 0.1.16 is the last version using the make tool by default
## following version start to use meson
RUN set -e && \
    cd /opt && \
    wget --show-progress --progress=bar:force https://libnice.freedesktop.org/releases/libnice-0.1.16.tar.gz && \
    tar -xzf libnice-0.1.16.tar.gz && rm libnice-0.1.16.tar.gz && \
    cd libnice-0.1.16 && \
    ./configure && \
    make && make install && \
    cd /opt && rm -rf libnice-0.1.16 && \
    set +e

## libsrtp2 from source code
RUN set -e && \
    cd /opt && \
    wget --show-progress --progress=bar:force https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz && \
    tar -xzf v2.2.0.tar.gz && rm v2.2.0.tar.gz && \
    cd libsrtp-2.2.0 && \
    ./configure --enable-openssl && \
    make shared_library  && make install && \
    cd /opt && rm -rf libsrtp-2.2.0 && \
    set +e

## janus from source code 
RUN set -e && \
    cd /opt && \
    git clone https://github.com/meetecho/janus-gateway.git && \
    cd janus-gateway && \
    ./autogen.sh && \
    ./configure && \
    make && make install && make configs && \
    mkdir -p /etc/janus && \
    cp /usr/local/etc/janus/*.jcfg /etc/janus/ && \
    cd /opt && rm -rf janus-gateway && \
    set +e

RUN useradd --user-group --system janus

EXPOSE 8088

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["janus", "-C", "/etc/janus/janus.jcfg", "-F", "/etc/janus"]
