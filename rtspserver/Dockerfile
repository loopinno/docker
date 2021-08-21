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
        git \
        libgstrtspserver-1.0-dev \
        libjson-glib-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

WORKDIR /opt

# su-exec from source code 
RUN git clone --depth 1 https://github.com/ncopa/su-exec.git && \
    cd su-exec && \
    make && cp su-exec /usr/local/bin/

## rtspserver from source code 
RUN git clone --depth 1 https://github.com/loopinno/rtspserver.git && \
    cd rtspserver && \
    make && make install && \
    mkdir -p /etc/rtspserver && cp *.json /etc/rtspserver/

FROM $BASE

# install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libgstrtspserver-1.0 \
        libjson-glib-1.0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

## rtspserver runtime  
WORKDIR /opt
COPY --from=build /usr/local/bin/su-exec /usr/local/bin/
COPY --from=build /usr/local/bin/rtspserver /usr/local/bin/
COPY --from=build /etc/rtspserver/*.json /etc/rtspserver/

RUN useradd --user-group --system rtsp
EXPOSE 8554

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["rtspserver", "-c", "/etc/rtspserver/rtspserver.json"]
