ARG BASE=docker.io/arm64v8/ubuntu:18.04

FROM $BASE
LABEL maintainer "Loopinno"

# install build tools and dependencies
RUN set -e && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        xz-utils \
    && rm -rf /var/lib/apt/lists/* \
    && set +e

RUN set -e && \
    cd /opt && \
    wget --show-progress --progress=bar:force -O node.tar.xz https://nodejs.org/dist/v10.24.1/node-v10.24.1-linux-arm64.tar.xz && \
    tar -C /usr/local --strip-components 1 -xJf node.tar.xz && \
    rm node.tar.xz && \
    set +e 

RUN set -e && \
    npm -g install -y http-server && \
    mkdir -p /etc/httpd && \
    set +e 

RUN useradd --user-group --system httpd

EXPOSE 8080

COPY ./index.html /etc/httpd/ 
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["http-server", "/etc/httpd", "-c-1"]
