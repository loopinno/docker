ARG BASE="ubuntu:18.04"
ARG VERSION="0.11.3"

FROM $BASE AS build
ARG BASE
ARG VERSION

# install build tools and dependencies
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
        libconfig-dev \
        libglib2.0-dev \
        openssl \
        libssl-dev \
        libjansson-dev \
        libmicrohttpd-dev \
        libcurl4-openssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

WORKDIR /opt

# su-exec from source code 
RUN git clone --depth 1 https://github.com/ncopa/su-exec.git && \
    cd su-exec && \
    make && cp su-exec /usr/local/bin/

## libnice from source code 
## 0.1.16 is the last version using the make tool by default
## following version start to use meson
RUN wget --show-progress --progress=bar:force https://libnice.freedesktop.org/releases/libnice-0.1.16.tar.gz && \
    tar -xzf libnice-0.1.16.tar.gz && rm libnice-0.1.16.tar.gz && \
    cd libnice-0.1.16 && \
    ./configure && \
    make && make install

## libsrtp2 from source code
RUN wget --show-progress --progress=bar:force https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz && \
    tar -xzf v2.2.0.tar.gz && rm v2.2.0.tar.gz && \
    cd libsrtp-2.2.0 && \
    ./configure --enable-openssl && \
    make shared_library && make install 

## janus from source code 
RUN git clone -b v${VERSION} --depth 1 https://github.com/meetecho/janus-gateway.git && \
    cd janus-gateway && \
    ./autogen.sh && ./configure && \
    make && make install && make configs && \
    mkdir -p /etc/janus && cp /usr/local/etc/janus/*.jcfg /etc/janus/ 

FROM $BASE 
ARG VERSION

# install dependencies
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
        libconfig-dev \
        libglib2.0-dev \
        openssl \
        libssl-dev \
        libjansson-dev \
        libmicrohttpd-dev \
        libcurl4-openssl-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

## janus runtime 
WORKDIR /opt
COPY --from=build /usr/local/bin/su-exec /usr/local/bin/

## libnice from source code 
## 0.1.16 is the last version using the make tool by default
## following version start to use meson
RUN wget --show-progress --progress=bar:force https://libnice.freedesktop.org/releases/libnice-0.1.16.tar.gz && \
    tar -xzf libnice-0.1.16.tar.gz && rm libnice-0.1.16.tar.gz && \
    cd libnice-0.1.16 && \
    ./configure && \
    make && make install && \
    cd /opt && rm -rf libnice-0.1.16

## libsrtp2 from source code
RUN wget --show-progress --progress=bar:force https://github.com/cisco/libsrtp/archive/v2.2.0.tar.gz && \
    tar -xzf v2.2.0.tar.gz && rm v2.2.0.tar.gz && \
    cd libsrtp-2.2.0 && \
    ./configure --enable-openssl && \
    make shared_library && make install && \
    cd /opt && rm -rf libsrtp-2.2.0

## janus from source code 
RUN git clone -b v${VERSION} --depth 1 https://github.com/meetecho/janus-gateway.git && \
    cd janus-gateway && \
    ./autogen.sh && ./configure && \
    make && make install && make configs && \
    mkdir -p /etc/janus && cp /usr/local/etc/janus/*.jcfg /etc/janus/ && \
    cd /opt && rm -rf janus-gateway

RUN useradd --user-group --system janus
EXPOSE 8088

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["janus", "-C", "/etc/janus/janus.jcfg", "-F", "/etc/janus"]
