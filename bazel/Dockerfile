ARG BASE="ubuntu:18.04"
ARG VERSION="4.1.0"

FROM $BASE AS build
ARG BASE
ARG VERSION

## install dependencies 
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        build-essential \
        wget \
        openjdk-11-jdk \
        zip \
        unzip \
        python3 \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && rm -rf /var/lib/apt/lists/*

## bazel from source code 
WORKDIR /opt
RUN wget --show-progress --progress=bar:force https://github.com/bazelbuild/bazel/releases/download/${VERSION}/bazel-${VERSION}-dist.zip && \
    unzip bazel-${VERSION}-dist.zip -d bazel && rm bazel-${VERSION}-dist.zip && \
    cd bazel && \
    env EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash compile.sh && \
    cp output/bazel /usr/local/bin

# FROM $BASE

## bazel runtime 
WORKDIR /opt
RUN rm -rf bazel  

CMD ["/bin/bash"]
