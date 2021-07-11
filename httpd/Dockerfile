ARG BASE="arm64v8/ubuntu:18.04"
ARG VERSION="10.24.1"

FROM $BASE AS dev
ARG BASE
ARG VERSION

# install build tools and dependencies
RUN set -e && \
    apt-get update && \
    apt-get install -y \
        wget \
        xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && set +e

RUN set -e && \
    cd /opt && \
    wget --show-progress --progress=bar:force https://nodejs.org/dist/v${VERSION}/node-v${VERSION}-linux-arm64.tar.xz && \
    tar -C /usr/local --strip-components 1 -xJf node-v${VERSION}-linux-arm64.tar.xz && \
    rm node-v${VERSION}-linux-arm64.tar.xz && \
    set +e 

RUN set -e && \
    npm -g install -y http-server && \
    mkdir -p /etc/httpd && \
    set +e 

FROM dev

RUN useradd --user-group --system httpd

EXPOSE 8080

COPY ./index.html /etc/httpd/ 
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["http-server", "/etc/httpd", "-c-1"]
