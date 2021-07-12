ARG BASE="ubuntu:18.04"
ARG VERSION="1.0.0"

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
        libjson-glib-1.0-0 \
        libjson-glib-dev \       
        openssl \
        libssl-dev \
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
    && rm -rf /var/lib/apt/lists/* 

## rtspd from source code 
WORKDIR /opt
RUN git clone -b ${VERSION} --depth 1 https://github.com/loopinno/rtspd.git && \
    cd rtspd && \
    make && make install && \
    mkdir -p /etc/rtspd && \
    cp *.json /etc/rtspd/

FROM $BASE

# install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libjson-glib-1.0-0 \
        libgstrtspserver-1.0 \
    && rm -rf /var/lib/apt/lists/* 

## rtspd runtime  
WORKDIR /opt
RUN rm -rf rtspd
COPY --from=build /usr/local/bin/rtspd /usr/local/bin/

RUN useradd --user-group --system rtspd
EXPOSE 8554

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["rtspd", "-c", "/etc/rtspd/rtspd.json"]
