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
        libyaml-cpp-dev \
        gstreamer1.0-doc \
        gstreamer1.0-tools \
        gstreamer1.0-libav \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
        gstreamer1.0-plugins-bad \
        gstreamer1.0-plugins-ugly \
        libgstreamer1.0 \
        libgstreamer1.0-dev \
        libgstreamer-plugins-base1.0-dev \
        libgstrtspserver-1.0 \
        libgstrtspserver-1.0-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && set +e

## rtspd from source code 
RUN set -e && \
    cd /opt && \
    git clone https://github.com/loopinno/rtspd.git && \
    cd rtspd && \
    make && make install && \
    mkdir -p /etc/rtspd && \
    cp *.yaml /etc/rtspd/ && \
    cd /opt && rm -rf rtspd && \
    set +e

RUN useradd --user-group --system rtspd

EXPOSE 8554

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["rtspd", "-c", "/etc/rtspd/rtspd.yaml"]
