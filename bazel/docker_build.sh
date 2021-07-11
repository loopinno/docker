#!/usr/bin/env bash

REPO="loopinno/bazel"
VERSION="4.1.0"
SYSTEM="ubuntu:18.04"
ARCH="arm64v8"

function usage()
{
cat <<EOF
Usage: $(basename $0) [options] ...
OPTIONS:
    -h, --help                  Display this help and exit.
    -v, --version <0.0.0>       Specify the version.
    -s, --system <ubuntu:18.04> Specify the operating system.
    -a, --arch <arm64v8>        Specify the architecture.
EOF
exit 0
}

while [ $# -gt 0 ]
do
    case "$1" in
    -h | --help )       usage
                        exit
                        ;;
    -v | --version )    shift
                        VERSION=$1
                        ;;
    -s | --system )     shift
                        SYSTEM=$1
                        ;;
    -a | --arch )       shift
                        ARCH=$1
                        ;;
    *)                  usage
                        exit 1
    esac
    shift
done

echo "VERSION: ${VERSION}"
echo "SYSTEM: ${SYSTEM}"
echo "ARCH: ${ARCH}"

TAG="${VERSION}-${SYSTEM//:/$'-'}-${ARCH}"
echo "TAG: ${TAG}"

BASE="${ARCH}/${SYSTEM}"
echo "BASE: ${BASE}"

## dev 
IMAGE="${REPO}:${TAG}-dev"
echo "IMAGE: ${IMAGE}"

docker build \
    --build-arg BASE=${BASE} \
    --build-arg VERSION="${VERSION}" \
    --target="dev" \
    -t ${IMAGE} \
    .

## runtime
IMAGE="${REPO}:${TAG}"
echo "IMAGE: ${IMAGE}"

docker build \
    --build-arg BASE=${BASE} \
    --build-arg VERSION="${VERSION}" \
    -t ${IMAGE} \
    .
