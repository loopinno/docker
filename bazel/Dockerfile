ARG BASE="arm64v8/ubuntu:18.04"
ARG VERSION="4.1.0"

FROM $BASE AS dev
ARG BASE
ARG VERSION

## install dependencies 
RUN set -e && \
    apt-get update && \
    apt-get install -y \
        build-essential \
        wget \
        openjdk-11-jdk \
        zip \
        unzip \
        python3 \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && set +e

## bazel from source code 
RUN set -e && \
    cd /opt && \
    wget --show-progress --progress=bar:force https://github.com/bazelbuild/bazel/releases/download/${VERSION}/bazel-${VERSION}-dist.zip && \
    unzip bazel-${VERSION}-dist.zip -d bazel && rm bazel-${VERSION}-dist.zip && \
    cd bazel && \
    env EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash compile.sh && \
    cp output/bazel /usr/local/bin && \
    set +e 

FROM dev

## runtime only 
RUN set -e && \
    cd /opt && \
    rm -rf bazel && \
    set +e 

# FROM $BASE

# ## install dependencies 
# RUN set -e && \
#     apt-get update && \
#     apt-get install -y \
#         openjdk-11-jdk \
#     && apt-get autoremove -y \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/* \
#     && set +e

# ## install Bazel  
# COPY --from=dev /usr/local/bin/bazel /usr/local/bin

CMD ["/bin/bash"]
